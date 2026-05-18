%%% @doc Query desk: list_refs_for_repo. Returns a page of results.
-module(list_refs_for_repo).

-export([handle/1]).

-spec handle(map()) -> {ok, [map()]} | {error, term()}.
handle(_Params) ->
    %% TODO: SELECT page from SQLite read model.
    {ok, []}.
