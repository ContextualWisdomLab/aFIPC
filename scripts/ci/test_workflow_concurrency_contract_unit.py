import tempfile
import unittest
from pathlib import Path

from test_workflow_concurrency_contract import discover_workflows, validate_workflow_text


VALID = """name: Example
on:
  pull_request:
    types: [opened, synchronize, reopened, ready_for_review]
concurrency:
  group: ${{ github.workflow }}-${{ github.repository }}-${{ github.event.pull_request.number || github.run_id }}
  cancel-in-progress: ${{ github.event_name == 'pull_request' }}
jobs:
  check:
    if: ${{ github.event_name != 'pull_request' || github.event.pull_request.draft == false }}
    runs-on: ubuntu-latest
"""


class WorkflowConcurrencyContractTest(unittest.TestCase):
    """Exercise discovery and top-level concurrency parsing edge cases."""

    def test_discovers_yml_and_yaml(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "a.yml").write_text("name: a\n")
            (root / "b.yaml").write_text("name: b\n")
            (root / "ignored.txt").write_text("name: ignored\n")
            self.assertEqual([path.name for path in discover_workflows(root)], ["a.yml", "b.yaml"])

    def test_accepts_exact_top_level_contract(self) -> None:
        validate_workflow_text(Path("valid.yml"), VALID)

    def test_rejects_noop_pull_request_lifecycle_events(self) -> None:
        malformed = VALID.replace(
            "types: [opened, synchronize, reopened, ready_for_review]",
            "types: [opened, synchronize, reopened, ready_for_review, converted_to_draft, closed]",
        )
        with self.assertRaisesRegex(AssertionError, "pull-request lifecycle"):
            validate_workflow_text(Path("noop-events.yml"), malformed)

    def test_rejects_nested_lookalike(self) -> None:
        malformed = """name: Example
on: pull_request
jobs:
  check:
    concurrency:
      group: ${{ github.workflow }}-${{ github.repository }}-${{ github.event.pull_request.number || github.run_id }}
      cancel-in-progress: ${{ github.event_name == 'pull_request' }}
    runs-on: ubuntu-latest
"""
        with self.assertRaisesRegex(AssertionError, "top-level concurrency"):
            validate_workflow_text(Path("nested.yml"), malformed)

    def test_rejects_nested_concurrency_entries(self) -> None:
        malformed = VALID.replace("  group:", "  policy:\n    group:").replace(
            "  cancel-in-progress:", "    cancel-in-progress:"
        )
        with self.assertRaisesRegex(AssertionError, "unsafe concurrency group"):
            validate_workflow_text(Path("nested-entries.yml"), malformed)

    def test_rejects_duplicate_top_level_concurrency(self) -> None:
        with self.assertRaisesRegex(AssertionError, "exactly one top-level concurrency"):
            validate_workflow_text(Path("duplicate.yml"), VALID + "\nconcurrency:\n  group: duplicate\n")

    def test_rejects_wrong_group(self) -> None:
        malformed = VALID.replace("github.repository", "github.ref")
        with self.assertRaisesRegex(AssertionError, "unsafe concurrency group"):
            validate_workflow_text(Path("wrong-group.yml"), malformed)

    def test_rejects_unconditional_cancellation(self) -> None:
        malformed = VALID.replace(
            "cancel-in-progress: ${{ github.event_name == 'pull_request' }}",
            "cancel-in-progress: true",
        )
        with self.assertRaisesRegex(AssertionError, "unsafe cancellation policy"):
            validate_workflow_text(Path("wrong-cancel.yml"), malformed)

    def test_rejects_draft_runner_admission(self) -> None:
        malformed = VALID.replace(
            "github.event.pull_request.draft == false",
            "github.event.pull_request.draft == true",
        )
        with self.assertRaisesRegex(AssertionError, "draft pull requests"):
            validate_workflow_text(Path("draft.yml"), malformed)

    def test_rejects_flow_style_pull_request_trigger(self) -> None:
        malformed = VALID.replace(
            "on:\n  pull_request:\n    types: [opened, synchronize, reopened, ready_for_review]",
            "on: [pull_request]",
        )
        with self.assertRaisesRegex(AssertionError, "pull-request trigger"):
            validate_workflow_text(Path("flow.yml"), malformed)

    def test_ignores_comment_lookalikes(self) -> None:
        malformed = VALID.replace("  pull_request:", "  # pull_request:")
        with self.assertRaisesRegex(AssertionError, "pull-request trigger"):
            validate_workflow_text(Path("comment.yml"), malformed)


if __name__ == "__main__":
    unittest.main()
