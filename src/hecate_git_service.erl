%%% @doc Git — implements the hecate_om_service behaviour.
-module(hecate_git_service).
-behaviour(hecate_om_service).

-export([info/0, start/1, stop/1, health/0, capabilities/0, identity_spec/0]).

info() ->
    #{
        name        => <<"hecate-git">>,
        version     => <<"0.1.0">>,
        description => <<"Git-over-mesh: serve git repositories over the Macula transport">>
    }.

start(_Opts) ->
    hecate_git_sup:start_link().

stop(_State) ->
    ok.

health() ->
    %% TODO: replace with a real health probe of the service.
    ok.

capabilities() ->
    %% TODO: list capabilities this service exposes on the mesh.
    [].

identity_spec() ->
    #{
        scope     => <<"hecate-git">>,
        actions   => [<<"publish_summary">>, <<"answer_query">>],
        resources => [<<"hecate-git/*">>],
        ttl_days  => 30
    }.
