# hecate-git

**Git-over-mesh** for the Hecate realm. Serves git repositories over
the Macula transport — the server side of
[`git-remote-mesh`](https://codeberg.org/macula-io/git-remote-mesh).

Realm-bound service. Runs on Hecate infrastructure nodes. Implements
the `hecate_om_service` behaviour.

## Why

Today the realm pushes to codeberg.org and mirrors to GitHub. Both
forges are good, but neither is the realm's. `hecate-git` is the
realm's own git surface, reachable across the mesh without leaving
the sovereign stack. Once it's live, `git-remote-mesh`'s URLs
resolve to it.

## Layer position

```
Layer 4 — apps        (a future Codeberg/Forgejo-style web UI plugin)
Layer 3 — session     hecate-daemon → calls hecate-git via mesh RPC
Layer 2 — services    ▶ hecate-git ◀ (this repo)
Layer 1 — identity    hecate-realm
Layer 0 — kernel      macula-station
```

Substrate: [`hecate-om`](https://codeberg.org/hecate-services/hecate-om).

## Capabilities

| Capability | Purpose |
|------------|---------|
| `hecate-git.create_repository` | Create a new repo under the realm |
| `hecate-git.rename_repository` | Rename a repo |
| `hecate-git.retire_repository` | Retire a repo |
| `hecate-git.advance_ref` | Push: move a ref to a new oid |
| `hecate-git.retire_ref` | Delete a ref |
| `hecate-git.get_repository_by_id` | Fetch repo metadata |
| `hecate-git.get_repository_by_name` | Resolve `realm/repo` to id |
| `hecate-git.list_repositories_page` | Listing |
| `hecate-git.get_ref` | Resolve `repo + ref` → oid (fetch) |
| `hecate-git.list_refs_for_repo` | All refs of a repo |

## Umbrella

| App | Department | Purpose |
|-----|-----------|---------|
| `git` | shared | notation + `hecate_git_http` helpers |
| `manage_repositories` | CMD | create / rename / retire repos |
| `manage_refs` | CMD | advance / retire refs (push side) |
| `project_repositories` | PRJ | repositories read-model projections |
| `project_refs` | PRJ | refs read-model projections |
| `query_repositories` | QRY | repo lookups + listings |
| `query_refs` | QRY | ref → oid resolution (fetch hot path) |

Object storage (actual git packfiles + loose objects) lives on
`/bulk0/hecate/hecate-git/repositories/<repo-id>/`. The event store
and read model only carry metadata + ref state.

## Build / deploy

Standard `hecate-services` flow. See
`hecate-om/guides/container_deployment.md`.

## Status

**Scaffold.** Vertical slices stubbed; mesh RPC dispatch table wired.
The actual git smart-protocol implementation
(`git-upload-pack` / `git-receive-pack` over Macula streaming RPC),
object storage, pack-file streaming, and integrity checks remain
TODO.

## License

Apache-2.0.
