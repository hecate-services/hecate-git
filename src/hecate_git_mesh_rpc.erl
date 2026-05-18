%%% @doc Macula RPC dispatch table for hecate-git.
-module(hecate_git_mesh_rpc).
-behaviour(gen_server).

-export([start_link/0, dispatch/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

-spec dispatch(binary(), map()) -> {ok, term()} | {error, term()}.
dispatch(Method, Params) ->
    gen_server:call(?MODULE, {dispatch, Method, Params}).

init([]) -> {ok, #{}}.

handle_call({dispatch, Method, Params}, _From, S) ->
    {reply, route(Method, Params), S};
handle_call(_, _From, S) -> {reply, {error, unknown_call}, S}.

handle_cast(_, S) -> {noreply, S}.
handle_info(_, S) -> {noreply, S}.
terminate(_, _)   -> ok.

route(<<"hecate-git.create_repository">>, P) ->
    delegate(create_repository_v1, maybe_create_repository, P);
route(<<"hecate-git.rename_repository">>, P) ->
    delegate(rename_repository_v1, maybe_rename_repository, P);
route(<<"hecate-git.retire_repository">>, P) ->
    delegate(retire_repository_v1, maybe_retire_repository, P);
route(<<"hecate-git.advance_ref">>, P) ->
    delegate(advance_ref_v1, maybe_advance_ref, P);
route(<<"hecate-git.retire_ref">>, P) ->
    delegate(retire_ref_v1, maybe_retire_ref, P);
route(<<"hecate-git.get_repository_by_id">>, #{<<"repository_id">> := Id}) ->
    get_repository_by_id:handle(Id);
route(<<"hecate-git.get_repository_by_name">>, P) ->
    get_repository_by_name:handle(P);
route(<<"hecate-git.list_repositories_page">>, P) ->
    list_repositories_page:handle(P);
route(<<"hecate-git.get_ref">>, P) ->
    get_ref:handle(P);
route(<<"hecate-git.list_refs_for_repo">>, P) ->
    list_refs_for_repo:handle(P);
route(Other, _P) ->
    {error, {unknown_method, Other}}.

delegate(CmdMod, HandlerMod, Params) ->
    case CmdMod:from_map(Params) of
        {ok, Cmd} ->
            case HandlerMod:dispatch(Cmd) of
                ok                  -> {ok, #{status => accepted}};
                {ok, Result}        -> {ok, Result};
                {error, _} = E      -> E
            end;
        {error, _} = E -> E
    end.
