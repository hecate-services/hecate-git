%%% @doc Event `repository_retired_v1`.
-module(repository_retired_v1).
-behaviour(evoq_event).

-export([event_type/0]).
-export([new/1, from_map/1, to_map/1]).
-export([get_repository_id/1, get_reason/1]).

-record(repository_retired_v1, {
    repository_id :: binary() | undefined,
    reason :: binary() | undefined
}).

-opaque t() :: #repository_retired_v1{}.
-export_type([t/0]).

event_type() -> repository_retired_v1.

-spec new(map()) -> {ok, t()}.
new(#{repository_id := Id} = Params) ->
    {ok, #repository_retired_v1{
        repository_id = Id,
        reason = maps:get(reason, Params, undefined)
    }}.

-spec from_map(map()) -> {ok, t()}.
from_map(#{<<"repository_id">> := Id} = Map) ->
    {ok, #repository_retired_v1{
        repository_id = Id,
        reason = maps:get(<<"reason">>, Map, undefined)
    }}.

-spec to_map(t()) -> map().
to_map(#repository_retired_v1{} = Ev) ->
    #{
        event_type => repository_retired_v1,
        repository_id => Ev#repository_retired_v1.repository_id,
        reason => Ev#repository_retired_v1.reason
    }.

get_repository_id(#repository_retired_v1{repository_id = V}) -> V.
get_reason(#repository_retired_v1{reason = V}) -> V.
