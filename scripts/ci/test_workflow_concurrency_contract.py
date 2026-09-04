from pathlib import Path


WORKFLOWS = Path(".github/workflows")
EXPECTED_GROUP = "${{ github.workflow }}-${{ github.repository }}-${{ github.event_name == 'pull_request' && github.event.pull_request.number || github.run_id }}"
EXPECTED_CANCEL = "cancel-in-progress: ${{ github.event_name == 'pull_request' }}"


def main() -> None:
    files = sorted(WORKFLOWS.glob("*.yml"))
    assert files, "no workflows found"
    for path in files:
        text = path.read_text()
        assert f"group: {EXPECTED_GROUP}" in text, f"{path}: unsafe concurrency group"
        assert EXPECTED_CANCEL in text, f"{path}: unsafe cancellation policy"


if __name__ == "__main__":
    main()
