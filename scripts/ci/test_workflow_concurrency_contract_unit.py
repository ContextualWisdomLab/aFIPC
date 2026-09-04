import tempfile
import unittest
from pathlib import Path

from test_workflow_concurrency_contract import discover_workflows, validate_workflow_text


VALID = """name: Example
on: pull_request
concurrency:
  group: ${{ github.workflow }}-${{ github.repository }}-${{ github.event.pull_request.number || github.run_id }}
  cancel-in-progress: ${{ github.event_name == 'pull_request' }}
jobs:
  check:
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


if __name__ == "__main__":
    unittest.main()
