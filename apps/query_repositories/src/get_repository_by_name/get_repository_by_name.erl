%%% @doc Query desk: get_repository_by_name. Returns a page of results.
-module(get_repository_by_name).

-export([handle/1]).

-spec handle(map()) -> {ok, [map()]} | {error, term()}.
handle(_Params) ->
    %% TODO: SELECT page from SQLite read model.
    {ok, []}.
