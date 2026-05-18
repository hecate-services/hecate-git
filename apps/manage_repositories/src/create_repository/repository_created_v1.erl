%%% @doc Event `repository_created_v1`.
-module(repository_created_v1).
-behaviour(evoq_event).

-export([event_type/0]).
-export([new/1, from_map/1, to_map/1]).
-export([get_repository_id/1, get_name/1, get_steward/1, get_default_branch/1, get_visibility/1]).

-record(repository_created_v1, {
    repository_id :: binary() | undefined,
    name :: binary() | undefined,
    steward :: binary() | undefined,
    default_branch :: binary() | undefined,
    visibility :: binary() | undefined
}).

-opaque t() :: #repository_created_v1{}.
-export_type([t/0]).

event_type() -> repository_created_v1.

-spec new(map()) -> {ok, t()}.
new(#{repository_id := Id} = Params) ->
    {ok, #repository_created_v1{
        repository_id = Id,
        name = maps:get(name, Params, undefined),
        steward = maps:get(steward, Params, undefined),
        default_branch = maps:get(default_branch, Params, undefined),
        visibility = maps:get(visibility, Params, undefined)
    }}.

-spec from_map(map()) -> {ok, t()}.
from_map(#{<<"repository_id">> := Id} = Map) ->
    {ok, #repository_created_v1{
        repository_id = Id,
        name = maps:get(<<"name">>, Map, undefined),
        steward = maps:get(<<"steward">>, Map, undefined),
        default_branch = maps:get(<<"default_branch">>, Map, undefined),
        visibility = maps:get(<<"visibility">>, Map, undefined)
    }}.

-spec to_map(t()) -> map().
to_map(#repository_created_v1{} = Ev) ->
    #{
        event_type => repository_created_v1,
        repository_id => Ev#repository_created_v1.repository_id,
        name => Ev#repository_created_v1.name,
        steward => Ev#repository_created_v1.steward,
        default_branch => Ev#repository_created_v1.default_branch,
        visibility => Ev#repository_created_v1.visibility
    }.

get_repository_id(#repository_created_v1{repository_id = V}) -> V.
get_name(#repository_created_v1{name = V}) -> V.
get_steward(#repository_created_v1{steward = V}) -> V.
get_default_branch(#repository_created_v1{default_branch = V}) -> V.
get_visibility(#repository_created_v1{visibility = V}) -> V.
