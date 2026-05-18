%%% @doc Macula RPC dispatch for hecate-git.
%%%
%%% Registers every advertised capability with the SDK at boot via
%%% `macula:advertise/5`. Handler form is `{?MODULE, handle_<method>}`,
%%% one entry per capability — encodes the procedure string once at
%%% advertise time, keeps the per-call hot path off the BEAM mailbox.
%%%
%%% Degrades silently when no pool / no realm — gen_server stays up,
%%% local `dispatch/2` keeps working for tests + HTTP admin.
-module(hecate_git_mesh_rpc).
-behaviour(gen_server).

-export([
    start_link/0,
    dispatch/2,
    handle_create_repository/1,
    handle_rename_repository/1,
    handle_retire_repository/1,
    handle_advance_ref/1,
    handle_retire_ref/1,
    handle_get_repository_by_id/1,
    handle_get_repository_by_name/1,
    handle_list_repositories_page/1,
    handle_get_ref/1,
    handle_list_refs_for_repo/1
]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

-spec dispatch(binary(), map()) -> {ok, term()} | {error, term()}.
dispatch(Method, Params) ->
    gen_server:call(?MODULE, {dispatch, Method, Params}).

init([]) ->
    advertise_all(),
    {ok, #{}}.

handle_call({dispatch, Method, Params}, _From, S) ->
    {reply, route(Method, Params), S};
handle_call(_, _From, S) -> {reply, {error, unknown_call}, S}.

handle_cast(_, S) -> {noreply, S}.
handle_info(_, S) -> {noreply, S}.
terminate(_, _)   -> ok.

%%% Internal: register every capability with the SDK

advertise_all() ->
    case {hecate_om:macula_client(), hecate_om_identity:realm()} of
        {{ok, Pool}, {ok, Realm}} ->
            lists:foreach(
                fun({Cap, Fun}) ->
                    try
                        ok = macula:advertise(Pool, Realm, Cap,
                                              {?MODULE, Fun}, #{})
                    catch _:_ -> ok
                    end
                end,
                handler_table()
            );
        _ ->
            ok
    end.

handler_table() ->
    [
        {<<"hecate-git.create_repository">>,     handle_create_repository},
        {<<"hecate-git.rename_repository">>,     handle_rename_repository},
        {<<"hecate-git.retire_repository">>,     handle_retire_repository},
        {<<"hecate-git.advance_ref">>,           handle_advance_ref},
        {<<"hecate-git.retire_ref">>,            handle_retire_ref},
        {<<"hecate-git.get_repository_by_id">>,  handle_get_repository_by_id},
        {<<"hecate-git.get_repository_by_name">>,handle_get_repository_by_name},
        {<<"hecate-git.list_repositories_page">>,handle_list_repositories_page},
        {<<"hecate-git.get_ref">>,               handle_get_ref},
        {<<"hecate-git.list_refs_for_repo">>,    handle_list_refs_for_repo}
    ].

%%% Internal: handler entry points (one per capability)

handle_create_repository(P)      -> route(<<"hecate-git.create_repository">>, P).
handle_rename_repository(P)      -> route(<<"hecate-git.rename_repository">>, P).
handle_retire_repository(P)      -> route(<<"hecate-git.retire_repository">>, P).
handle_advance_ref(P)            -> route(<<"hecate-git.advance_ref">>, P).
handle_retire_ref(P)             -> route(<<"hecate-git.retire_ref">>, P).
handle_get_repository_by_id(P)   -> route(<<"hecate-git.get_repository_by_id">>, P).
handle_get_repository_by_name(P) -> route(<<"hecate-git.get_repository_by_name">>, P).
handle_list_repositories_page(P) -> route(<<"hecate-git.list_repositories_page">>, P).
handle_get_ref(P)                -> route(<<"hecate-git.get_ref">>, P).
handle_list_refs_for_repo(P)     -> route(<<"hecate-git.list_refs_for_repo">>, P).

%%% Internal: method → slice handler

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
