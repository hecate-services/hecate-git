%%% @doc Command `retire_repository_v1`.
%%%
%%% Generated stub. Add validation in `maybe_retire_repository` once the slice
%%% has real business rules.
-module(retire_repository_v1).
-behaviour(evoq_command).

-export([command_type/0]).
-export([new/1, from_map/1, validate/1, to_map/1]).
-export([stream_id/1]).
-export([get_repository_id/1, get_reason/1]).

-record(retire_repository_v1, {
    repository_id :: binary() | undefined,
    reason :: binary() | undefined
}).

-opaque t() :: #retire_repository_v1{}.
-export_type([t/0]).

-spec command_type() -> atom().
command_type() -> retire_repository_v1.

-spec new(map()) -> {ok, t()} | {error, term()}.
new(#{repository_id := Id} = Params) ->
    {ok, #retire_repository_v1{
        repository_id = Id,
        reason = maps:get(reason, Params, undefined)
    }};
new(_) ->
    {error, missing_aggregate_id}.

-spec from_map(map()) -> {ok, t()} | {error, term()}.
from_map(#{<<"repository_id">> := Id} = Map) ->
    {ok, #retire_repository_v1{
        repository_id = Id,
        reason = maps:get(<<"reason">>, Map, undefined)
    }};
from_map(_) ->
    {error, missing_aggregate_id}.

-spec validate(t()) -> ok | {error, term()}.
validate(#retire_repository_v1{repository_id = undefined}) -> {error, missing_aggregate_id};
validate(_) -> ok.

-spec to_map(t()) -> map().
to_map(#retire_repository_v1{} = Cmd) ->
    #{
        command_type => retire_repository_v1,
        repository_id => Cmd#retire_repository_v1.repository_id,
        reason => Cmd#retire_repository_v1.reason
    }.

-spec stream_id(t()) -> binary().
stream_id(#retire_repository_v1{repository_id = Id}) ->
    <<"repository-", Id/binary>>.

-spec get_repository_id(t()) -> binary() | undefined.
get_repository_id(#retire_repository_v1{repository_id = V}) -> V.

-spec get_reason(t()) -> binary() | undefined.
get_reason(#retire_repository_v1{reason = V}) -> V.
