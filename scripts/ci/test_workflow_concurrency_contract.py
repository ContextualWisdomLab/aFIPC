"""Validate repository-owned workflow concurrency without parsing lookalike text."""

from pathlib import Path


WORKFLOWS = Path(".github/workflows")
EXPECTED_GROUP = (
    "${{ github.workflow }}-${{ github.repository }}-"
    "${{ github.event_name == 'pull_request' && github.run_attempt == 1 && "
    "github.event.pull_request.number || github.run_id }}"
)
EXPECTED_CANCEL = "${{ github.event_name == 'pull_request' }}"
EXPECTED_PR_TYPES = (
    "types: [opened, synchronize, reopened, ready_for_review, converted_to_draft, closed]"
)
EXPECTED_PR_ADMISSION = (
    "${{ github.event_name != 'pull_request' || "
    "(github.event.action != 'closed' && github.event.pull_request.draft == false) }}"
)


def discover_workflows(root: Path = WORKFLOWS) -> list[Path]:
    """Return every YAML workflow file under the repository workflow directory."""
    return sorted({*root.glob("*.yml"), *root.glob("*.yaml")})


def _top_level_concurrency_entries(path: Path, text: str) -> dict[str, list[str]]:
    """Return direct key/value entries from the sole top-level concurrency block."""
    lines = text.splitlines()
    starts = [index for index, line in enumerate(lines) if line == "concurrency:"]
    assert len(starts) == 1, f"{path}: expected exactly one top-level concurrency block"

    start = starts[0] + 1
    end = len(lines)
    for index in range(start, len(lines)):
        stripped = lines[index].strip()
        if not stripped or stripped.startswith("#"):
            continue
        if lines[index][0] not in " \t":
            end = index
            break

    entries: dict[str, list[str]] = {}
    index = start
    while index < end:
        line = lines[index]
        if not line.startswith("  ") or line.startswith("    "):
            index += 1
            continue

        key, separator, raw_value = line[2:].partition(":")
        if not separator:
            index += 1
            continue

        value = raw_value.strip()
        if value in {">", ">-"}:
            continuation: list[str] = []
            cursor = index + 1
            while cursor < end and lines[cursor].startswith("    "):
                assert not lines[cursor].startswith(
                    "      "
                ), f"{path}: folded concurrency scalar uses indentation that preserves newlines"
                stripped = lines[cursor].strip()
                if stripped and not stripped.startswith("#"):
                    continuation.append(stripped)
                cursor += 1
            value = " ".join(continuation)
            index = cursor
        else:
            index += 1

        entries.setdefault(key, []).append(value)

    return entries


def _has_pull_request_trigger(text: str) -> bool:
    """Return whether the workflow has a top-level pull-request trigger block."""
    lines = text.splitlines()
    try:
        start = lines.index("on:") + 1
    except ValueError:
        return False
    for line in lines[start:]:
        if line and not line[0].isspace():
            break
        if line == "  pull_request:":
            return True
    return False


def _pull_request_types(text: str) -> list[str]:
    """Return direct entries from the top-level pull-request trigger."""
    lines = text.splitlines()
    start = lines.index("  pull_request:") + 1
    entries: list[str] = []
    for line in lines[start:]:
        if line and (
            not line[0].isspace()
            or (line.startswith("  ") and not line.startswith("    "))
        ):
            break
        if line.startswith("    ") and not line.startswith("      "):
            entries.append(line[4:])
    return entries


def _job_admissions(text: str) -> list[str]:
    """Return direct ``if`` values for every top-level job."""
    lines = text.splitlines()
    start = lines.index("jobs:") + 1
    admissions: list[str] = []
    for index in range(start, len(lines)):
        line = lines[index]
        if line and not line[0].isspace():
            break
        if line.startswith("  ") and not line.startswith("    ") and line.endswith(":"):
            job_end = next(
                (
                    candidate
                    for candidate in range(index + 1, len(lines))
                    if lines[candidate].startswith("  ")
                    and not lines[candidate].startswith("    ")
                ),
                len(lines),
            )
            direct_if = [
                entry[8:]
                for entry in lines[index + 1 : job_end]
                if entry.startswith("    if: ")
            ]
            admissions.extend(direct_if or [""])
    return admissions


def validate_workflow_text(path: Path, text: str) -> None:
    """Require exact PR lifecycle, admission, grouping, and cancellation semantics."""
    entries = _top_level_concurrency_entries(path, text)

    assert entries.get("group") == [EXPECTED_GROUP], f"{path}: unsafe concurrency group"
    assert entries.get("cancel-in-progress") == [
        EXPECTED_CANCEL
    ], f"{path}: unsafe cancellation policy"
    assert _has_pull_request_trigger(
        text
    ), f"{path}: missing structured pull-request trigger"
    assert EXPECTED_PR_TYPES in _pull_request_types(
        text
    ), f"{path}: incomplete pull-request lifecycle"
    assert _job_admissions(text) and all(
        admission == EXPECTED_PR_ADMISSION for admission in _job_admissions(text)
    ), f"{path}: draft or closed pull requests occupy a runner"


def main() -> None:
    """Validate every source-backed workflow in the repository."""
    files = discover_workflows()
    assert files, "no workflows found"
    for path in files:
        validate_workflow_text(path, path.read_text())


if __name__ == "__main__":
    main()
