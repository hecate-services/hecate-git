%%% @doc Event `repository_renamed_v1`.
-module(repository_renamed_v1).
-behaviour(evoq_event).

-export([event_type/0]).
-export([new/1, from_map/1, to_map/1]).
-export([get_repository_id/1, get_new_name/1]).

-record(repository_renamed_v1, {
    repository_id :: binary() | undefined,
    new_name :: binary() | undefined
}).

-opaque t() :: #repository_renamed_v1{}.
-export_type([t/0]).

event_type() -> repository_renamed_v1.

-spec new(map()) -> {ok, t()}.
new(#{repository_id := Id} = Params) ->
    {ok, #repository_renamed_v1{
        repository_id = Id,
        new_name = maps:get(new_name, Params, undefined)
    }}.

-spec from_map(map()) -> {ok, t()}.
from_map(#{<<"repository_id">> := Id} = Map) ->
    {ok, #repository_renamed_v1{
        repository_id = Id,
        new_name = maps:get(<<"new_name">>, Map, undefined)
    }}.

-spec to_map(t()) -> map().
to_map(#repository_renamed_v1{} = Ev) ->
    #{
        event_type => repository_renamed_v1,
        repository_id => Ev#repository_renamed_v1.repository_id,
        new_name => Ev#repository_renamed_v1.new_name
    }.

get_repository_id(#repository_renamed_v1{repository_id = V}) -> V.
get_new_name(#repository_renamed_v1{new_name = V}) -> V.
