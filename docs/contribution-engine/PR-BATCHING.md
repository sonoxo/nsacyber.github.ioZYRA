# Pull Request Batching

Batch findings only when they share one detector class and a common repair strategy.

Recommended limits:

- 1-20 fixes per normal PR.
- One generated-file refresh may accompany its source change.
- Separate functional PowerShell changes from catalog metadata changes.
- Separate accessibility-only changes from content corrections.
- Never mix speculative fixes with deterministic failures.

The objective is high throughput with low reviewer entropy: each PR should be understandable, testable, and reversible as a unit.