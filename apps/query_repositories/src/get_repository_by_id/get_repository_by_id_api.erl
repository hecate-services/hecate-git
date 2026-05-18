%%% @doc Cowboy handler — GET /api/git/repositories/:repository_id.
-module(get_repository_by_id_api).

-export([init/2, routes/0]).

routes() -> [{"/api/git/repositories/:repository_id", ?MODULE, []}].

init(Req0, _State) ->
    case cowboy_req:method(Req0) of
        <<"GET">> ->
            Id = cowboy_req:binding(repository_id, Req0),
            case get_repository_by_id:handle(Id) of
                {ok, Result} ->
                    hecate_git_http:ok_json(Result, Req0);
                {error, not_found} ->
                    hecate_git_http:not_found(Req0);
                {error, Reason} ->
                    hecate_git_http:bad_request(
                        iolist_to_binary(io_lib:format("~p", [Reason])), Req0)
            end;
        _ ->
            hecate_git_http:method_not_allowed(Req0)
    end.
