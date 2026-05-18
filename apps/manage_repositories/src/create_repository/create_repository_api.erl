%%% @doc Cowboy handler — POST /api/git/repositories/create.
-module(create_repository_api).

-export([init/2, routes/0]).

routes() -> [{"/api/git/repositories/create", ?MODULE, []}].

init(Req0, State) ->
    case cowboy_req:method(Req0) of
        <<"POST">> -> handle(Req0, State);
        _                  -> hecate_git_http:method_not_allowed(Req0)
    end.

handle(Req0, _State) ->
    case hecate_git_http:read_json_body(Req0) of
        {ok, Params, Req1} ->
            case create_repository_v1:from_map(Params) of
                {ok, Cmd} ->
                    case maybe_create_repository:dispatch(Cmd) of
                        ok ->
                            hecate_git_http:ok_json(#{status => accepted}, Req1);
                        {error, Reason} ->
                            hecate_git_http:bad_request(reason_to_bin(Reason), Req1)
                    end;
                {error, Reason} ->
                    hecate_git_http:bad_request(reason_to_bin(Reason), Req1)
            end;
        {error, invalid_json, Req1} ->
            hecate_git_http:bad_request(<<"Invalid JSON">>, Req1)
    end.

reason_to_bin(R) when is_atom(R)   -> atom_to_binary(R, utf8);
reason_to_bin(R) when is_binary(R) -> R;
reason_to_bin(R)                   -> iolist_to_binary(io_lib:format("~p", [R])).
