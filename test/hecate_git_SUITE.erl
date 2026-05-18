%%% @doc Smoke tests for hecate-git.
-module(hecate_git_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("stdlib/include/assert.hrl").

-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([service_info/1, capabilities_count/1, mesh_rpc_unknown/1]).

all() ->
    [service_info, capabilities_count, mesh_rpc_unknown].

init_per_suite(Config) ->
    {ok, _} = application:ensure_all_started(hecate_git),
    Config.

end_per_suite(_Config) ->
    application:stop(hecate_git),
    ok.

service_info(_Config) ->
    Info = hecate_git_service:info(),
    ?assertEqual(<<"hecate-git">>, maps:get(name, Info)).

capabilities_count(_Config) ->
    Caps = hecate_git_service:capabilities(),
    ?assertEqual(10, length(Caps)).

mesh_rpc_unknown(_Config) ->
    ?assertMatch({error, {unknown_method, _}},
                 hecate_git_mesh_rpc:dispatch(<<"hecate-git.no_such">>, #{})).
