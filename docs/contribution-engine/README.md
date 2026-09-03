# Contribution Engine

This directory documents a review-first workflow for producing useful patches against the NSA Cyber public catalog without generating duplicate or low-value changes.

## Pipeline

1. Validate catalog structure.
2. Detect malformed or duplicate repository metadata.
3. Detect broken local Markdown references.
4. Normalize findings into a machine-readable repair manifest.
5. Rank findings by severity and confidence.
6. Group only related fixes into reviewable pull requests.
7. Re-run integrity checks before proposing upstream changes.

The engine is intentionally deterministic: the same repository state should produce the same finding identifiers and repair candidates.