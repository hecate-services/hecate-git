%%% @doc Query desk: get_ref. Returns a page of results.
-module(get_ref).

-export([handle/1]).

-spec handle(map()) -> {ok, [map()]} | {error, term()}.
handle(_Params) ->
    %% TODO: SELECT page from SQLite read model.
    {ok, []}.
