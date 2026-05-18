-- Read-model table for projected repository facts.
-- Owned by project_repositories. Read by query_repositories.

CREATE TABLE IF NOT EXISTS repositories (
    repository_id    TEXT PRIMARY KEY,
    name             TEXT NOT NULL UNIQUE,
    steward          TEXT NOT NULL,
    default_branch   TEXT NOT NULL DEFAULT 'main',
    visibility       TEXT NOT NULL DEFAULT 'realm',  -- realm | private | public
    created_at_ms    INTEGER NOT NULL,
    renamed_from     TEXT,
    retired_at_ms    INTEGER
);

CREATE INDEX IF NOT EXISTS repositories_by_steward
    ON repositories (steward);
