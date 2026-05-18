%%% @doc Cowboy handler — GET /api/git/repositories.
-module(list_repositories_page_api).

-export([init/2, routes/0]).

routes() -> [{"/api/git/repositories", ?MODULE, []}].

init(Req0, _State) ->
    case cowboy_req:method(Req0) of
        <<"GET">> ->
            Params = maps:from_list(cowboy_req:parse_qs(Req0)),
            case list_repositories_page:handle(Params) of
                {ok, Items} ->
                    hecate_git_http:ok_json(#{items => Items}, Req0);
                {error, Reason} ->
                    hecate_git_http:bad_request(
                        iolist_to_binary(io_lib:format("~p", [Reason])), Req0)
            end;
        _ ->
            hecate_git_http:method_not_allowed(Req0)
    end.
