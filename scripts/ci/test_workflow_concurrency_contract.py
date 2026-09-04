"""Validate repository-owned workflow concurrency without parsing lookalike text."""

from pathlib import Path


WORKFLOWS = Path(".github/workflows")
EXPECTED_GROUP = (
    "${{ github.workflow }}-${{ github.repository }}-"
    "${{ github.event.pull_request.number || github.run_id }}"
)
EXPECTED_CANCEL = "${{ github.event_name == 'pull_request' }}"


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
        line.strip()
        for line in lines[start:end]
        if line.strip() and not line.lstrip().startswith("#")
    ]


def validate_workflow_text(path: Path, text: str) -> None:
    """Require exact group and PR-only cancellation values in top-level concurrency."""
    entries = _top_level_concurrency_lines(path, text)
    groups = [entry for entry in entries if entry.startswith("group:")]
    cancellations = [entry for entry in entries if entry.startswith("cancel-in-progress:")]

    assert groups == [f"group: {EXPECTED_GROUP}"], f"{path}: unsafe concurrency group"
    assert cancellations == [
        f"cancel-in-progress: {EXPECTED_CANCEL}"
    ], f"{path}: unsafe cancellation policy"


def main() -> None:
    """Validate every source-backed workflow in the repository."""
    files = discover_workflows()
    assert files, "no workflows found"
    for path in files:
        validate_workflow_text(path, path.read_text())


if __name__ == "__main__":
    main()
