%%% @doc Event `ref_advanced_v1`.
-module(ref_advanced_v1).
-behaviour(evoq_event).

-export([event_type/0]).
-export([new/1, from_map/1, to_map/1]).
-export([get_repository_id/1, get_ref/1, get_old_oid/1, get_new_oid/1, get_pusher/1]).

-record(ref_advanced_v1, {
    repository_id :: binary() | undefined,
    ref :: binary() | undefined,
    old_oid :: binary() | undefined,
    new_oid :: binary() | undefined,
    pusher :: binary() | undefined
}).

-opaque t() :: #ref_advanced_v1{}.
-export_type([t/0]).

event_type() -> ref_advanced_v1.

-spec new(map()) -> {ok, t()}.
new(#{repository_id := Id} = Params) ->
    {ok, #ref_advanced_v1{
        repository_id = Id,
        ref = maps:get(ref, Params, undefined),
        old_oid = maps:get(old_oid, Params, undefined),
        new_oid = maps:get(new_oid, Params, undefined),
        pusher = maps:get(pusher, Params, undefined)
    }}.

-spec from_map(map()) -> {ok, t()}.
from_map(#{<<"repository_id">> := Id} = Map) ->
    {ok, #ref_advanced_v1{
        repository_id = Id,
        ref = maps:get(<<"ref">>, Map, undefined),
        old_oid = maps:get(<<"old_oid">>, Map, undefined),
        new_oid = maps:get(<<"new_oid">>, Map, undefined),
        pusher = maps:get(<<"pusher">>, Map, undefined)
    }}.

-spec to_map(t()) -> map().
to_map(#ref_advanced_v1{} = Ev) ->
    #{
        event_type => ref_advanced_v1,
        repository_id => Ev#ref_advanced_v1.repository_id,
        ref => Ev#ref_advanced_v1.ref,
        old_oid => Ev#ref_advanced_v1.old_oid,
        new_oid => Ev#ref_advanced_v1.new_oid,
        pusher => Ev#ref_advanced_v1.pusher
    }.

get_repository_id(#ref_advanced_v1{repository_id = V}) -> V.
get_ref(#ref_advanced_v1{ref = V}) -> V.
get_old_oid(#ref_advanced_v1{old_oid = V}) -> V.
get_new_oid(#ref_advanced_v1{new_oid = V}) -> V.
get_pusher(#ref_advanced_v1{pusher = V}) -> V.
