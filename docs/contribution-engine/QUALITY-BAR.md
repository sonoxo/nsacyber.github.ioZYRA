# Quality Bar

A candidate patch is eligible for upstream review only when all of the following are true:

- The finding is reproducible against the current upstream state.
- The proposed change is minimal and scoped to the finding.
- Generated files are regenerated when source metadata changes.
- No unrelated branding, product integration, or repository-specific customization is included.
- Validation passes after the patch.
- The pull request explains evidence, expected impact, and rollback path.
- Duplicate findings are collapsed before review.

High finding volume is handled by batching related fixes rather than lowering the review standard.