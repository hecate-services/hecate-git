%%% @doc Command `rename_repository_v1`.
%%%
%%% Generated stub. Add validation in `maybe_rename_repository` once the slice
%%% has real business rules.
-module(rename_repository_v1).
-behaviour(evoq_command).

-export([command_type/0]).
-export([new/1, from_map/1, validate/1, to_map/1]).
-export([stream_id/1]).
-export([get_repository_id/1, get_new_name/1]).

-record(rename_repository_v1, {
    repository_id :: binary() | undefined,
    new_name :: binary() | undefined
}).

-opaque t() :: #rename_repository_v1{}.
-export_type([t/0]).

-spec command_type() -> atom().
command_type() -> rename_repository_v1.

-spec new(map()) -> {ok, t()} | {error, term()}.
new(#{repository_id := Id} = Params) ->
    {ok, #rename_repository_v1{
        repository_id = Id,
        new_name = maps:get(new_name, Params, undefined)
    }};
new(_) ->
    {error, missing_aggregate_id}.

-spec from_map(map()) -> {ok, t()} | {error, term()}.
from_map(#{<<"repository_id">> := Id} = Map) ->
    {ok, #rename_repository_v1{
        repository_id = Id,
        new_name = maps:get(<<"new_name">>, Map, undefined)
    }};
from_map(_) ->
    {error, missing_aggregate_id}.

-spec validate(t()) -> ok | {error, term()}.
validate(#rename_repository_v1{repository_id = undefined}) -> {error, missing_aggregate_id};
validate(_) -> ok.

-spec to_map(t()) -> map().
to_map(#rename_repository_v1{} = Cmd) ->
    #{
        command_type => rename_repository_v1,
        repository_id => Cmd#rename_repository_v1.repository_id,
        new_name => Cmd#rename_repository_v1.new_name
    }.

-spec stream_id(t()) -> binary().
stream_id(#rename_repository_v1{repository_id = Id}) ->
    <<"repository-", Id/binary>>.

-spec get_repository_id(t()) -> binary() | undefined.
get_repository_id(#rename_repository_v1{repository_id = V}) -> V.

-spec get_new_name(t()) -> binary() | undefined.
get_new_name(#rename_repository_v1{new_name = V}) -> V.
