-- Read-model table for projected ref facts (branches, tags).
-- Owned by project_refs. Read by query_refs (fetch hot path).

CREATE TABLE IF NOT EXISTS refs (
    repository_id    TEXT NOT NULL,
    ref              TEXT NOT NULL,                  -- e.g. refs/heads/main
    oid              TEXT NOT NULL,                  -- 40-char hex
    pusher           TEXT NOT NULL,
    advanced_at_ms   INTEGER NOT NULL,
    retired_at_ms    INTEGER,
    PRIMARY KEY (repository_id, ref)
);

CREATE INDEX IF NOT EXISTS refs_by_repository
    ON refs (repository_id)
    WHERE retired_at_ms IS NULL;
