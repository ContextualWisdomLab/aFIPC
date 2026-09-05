"""Validate repository-owned workflow concurrency without parsing lookalike text."""

from pathlib import Path


WORKFLOWS = Path(".github/workflows")
EXPECTED_GROUP = (
    "${{ github.workflow }}-${{ github.repository }}-"
    "${{ github.event_name == 'pull_request' && github.run_attempt == 1 && "
    "github.event.pull_request.number || github.run_id }}"
)
EXPECTED_CANCEL = "${{ github.event_name == 'pull_request' }}"
EXPECTED_PR_TYPES = "types: [opened, synchronize, reopened, ready_for_review]"
EXPECTED_PR_ADMISSION = (
    "${{ github.event_name != 'pull_request' || github.event.pull_request.draft == false }}"
)


def discover_workflows(root: Path = WORKFLOWS) -> list[Path]:
    """Return every YAML workflow file under the repository workflow directory."""
    return sorted({*root.glob("*.yml"), *root.glob("*.yaml")})


def _top_level_concurrency_lines(path: Path, text: str) -> list[str]:
    """Return non-comment entries from the sole top-level concurrency block."""
    lines = text.splitlines()
    starts = [
        index
        for index, line in enumerate(lines)
        if line == "concurrency:"
    ]
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

    return [
        line[2:]
        for line in lines[start:end]
        if line.startswith("  ") and not line.startswith("    ")
    ]


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
    """Require exact group and PR-only cancellation values in top-level concurrency."""
    entries = _top_level_concurrency_lines(path, text)
    groups = [entry for entry in entries if entry.startswith("group:")]
    cancellations = [entry for entry in entries if entry.startswith("cancel-in-progress:")]

    assert groups == [f"group: {EXPECTED_GROUP}"], f"{path}: unsafe concurrency group"
    assert cancellations == [
        f"cancel-in-progress: {EXPECTED_CANCEL}"
    ], f"{path}: unsafe cancellation policy"
    assert _has_pull_request_trigger(
        text
    ), f"{path}: missing structured pull-request trigger"
    assert EXPECTED_PR_TYPES in _pull_request_types(
        text
    ), f"{path}: incomplete pull-request lifecycle"
    assert _job_admissions(text) and all(
        admission == EXPECTED_PR_ADMISSION for admission in _job_admissions(text)
    ), f"{path}: draft pull requests occupy a runner"


def main() -> None:
    """Validate every source-backed workflow in the repository."""
    files = discover_workflows()
    assert files, "no workflows found"
    for path in files:
        validate_workflow_text(path, path.read_text())


if __name__ == "__main__":
    main()
