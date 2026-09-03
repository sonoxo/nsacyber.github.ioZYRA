# Security Boundary

The contribution engine operates only on public repository content and generated local findings.

It must not:

- access secrets, credentials, private repositories, or privileged systems;
- auto-merge changes into upstream repositories;
- manufacture empty commits or backdate contribution events;
- bypass branch protection, required reviews, or maintainer approval;
- convert low-confidence findings directly into patches.

Automation may generate, validate, rank, and batch candidate repairs. Upstream acceptance remains a maintainer-controlled event.