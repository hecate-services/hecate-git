%%% @doc Public facade for hecate-git (admin / introspection).
-module(hecate_git).

-export([info/0, health/0, capabilities/0]).

info() -> hecate_git_service:info().
health() -> hecate_om:health().
capabilities() -> hecate_git_service:capabilities().
