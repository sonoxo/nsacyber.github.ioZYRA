# Finding Format

Each finding uses a stable shape:

```json
{
  "id": "finding-0123456789abcdef",
  "class": "catalog.invalid-url",
  "severity": "error",
  "path": "code.json",
  "evidence": "repositoryURL is not absolute HTTP/HTTPS",
  "proposedAction": "normalize repositoryURL",
  "confidence": 1.0
}
```

`id` is deterministic from class, path, and evidence so reruns can deduplicate findings. `confidence` ranges from 0 to 1 and represents detector confidence, not maintainer acceptance.