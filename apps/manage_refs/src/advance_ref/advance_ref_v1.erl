%%% @doc Command `advance_ref_v1`.
%%%
%%% Generated stub. Add validation in `maybe_advance_ref` once the slice
%%% has real business rules.
-module(advance_ref_v1).
-behaviour(evoq_command).

-export([command_type/0]).
-export([new/1, from_map/1, validate/1, to_map/1]).
-export([stream_id/1]).
-export([get_repository_id/1, get_ref/1, get_old_oid/1, get_new_oid/1, get_pusher/1]).

-record(advance_ref_v1, {
    repository_id :: binary() | undefined,
    ref :: binary() | undefined,
    old_oid :: binary() | undefined,
    new_oid :: binary() | undefined,
    pusher :: binary() | undefined
}).

-opaque t() :: #advance_ref_v1{}.
-export_type([t/0]).

-spec command_type() -> atom().
command_type() -> advance_ref_v1.

-spec new(map()) -> {ok, t()} | {error, term()}.
new(#{repository_id := Id} = Params) ->
    {ok, #advance_ref_v1{
        repository_id = Id,
        ref = maps:get(ref, Params, undefined),
        old_oid = maps:get(old_oid, Params, undefined),
        new_oid = maps:get(new_oid, Params, undefined),
        pusher = maps:get(pusher, Params, undefined)
    }};
new(_) ->
    {error, missing_aggregate_id}.

-spec from_map(map()) -> {ok, t()} | {error, term()}.
from_map(#{<<"repository_id">> := Id} = Map) ->
    {ok, #advance_ref_v1{
        repository_id = Id,
        ref = maps:get(<<"ref">>, Map, undefined),
        old_oid = maps:get(<<"old_oid">>, Map, undefined),
        new_oid = maps:get(<<"new_oid">>, Map, undefined),
        pusher = maps:get(<<"pusher">>, Map, undefined)
    }};
from_map(_) ->
    {error, missing_aggregate_id}.

-spec validate(t()) -> ok | {error, term()}.
validate(#advance_ref_v1{repository_id = undefined}) -> {error, missing_aggregate_id};
validate(_) -> ok.

-spec to_map(t()) -> map().
to_map(#advance_ref_v1{} = Cmd) ->
    #{
        command_type => advance_ref_v1,
        repository_id => Cmd#advance_ref_v1.repository_id,
        ref => Cmd#advance_ref_v1.ref,
        old_oid => Cmd#advance_ref_v1.old_oid,
        new_oid => Cmd#advance_ref_v1.new_oid,
        pusher => Cmd#advance_ref_v1.pusher
    }.

-spec stream_id(t()) -> binary().
stream_id(#advance_ref_v1{repository_id = Id}) ->
    <<"repository-", Id/binary>>.

-spec get_repository_id(t()) -> binary() | undefined.
get_repository_id(#advance_ref_v1{repository_id = V}) -> V.

-spec get_ref(t()) -> binary() | undefined.
get_ref(#advance_ref_v1{ref = V}) -> V.

-spec get_old_oid(t()) -> binary() | undefined.
get_old_oid(#advance_ref_v1{old_oid = V}) -> V.

-spec get_new_oid(t()) -> binary() | undefined.
get_new_oid(#advance_ref_v1{new_oid = V}) -> V.

-spec get_pusher(t()) -> binary() | undefined.
get_pusher(#advance_ref_v1{pusher = V}) -> V.
