# Changelog

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning: [SemVer](https://semver.org/).

## [Unreleased]

### Added
- Initial scaffold. Third hecate-service (after `hecate-rag` and
  `hecate-dns`). Server side of `git-remote-mesh`.
- 10 advertised capabilities (repositories + refs).
- Vertical-sliced umbrella: `manage_repositories` + `manage_refs`
  (CMD), `project_repositories` + `project_refs` (PRJ),
  `query_repositories` + `query_refs` (QRY).

### Planned
- Implement `git-upload-pack` over Macula streaming RPC (fetch)
- Implement `git-receive-pack` (push) with pre-receive hook against
  realm policy
- Object storage layout on `/bulk0/hecate/hecate-git/repositories/`
- Pack-file streaming + delta resolution
- Integrity checks: oid-known-to-realm validation, sha256 conflict

## [0.1.0] - YYYY-MM-DD

_Not yet released._
