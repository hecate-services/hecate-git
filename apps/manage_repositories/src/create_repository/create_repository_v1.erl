%%% @doc Command `create_repository_v1`.
%%%
%%% Generated stub. Add validation in `maybe_create_repository` once the slice
%%% has real business rules.
-module(create_repository_v1).
-behaviour(evoq_command).

-export([command_type/0]).
-export([new/1, from_map/1, validate/1, to_map/1]).
-export([stream_id/1]).
-export([get_repository_id/1, get_name/1, get_steward/1, get_default_branch/1, get_visibility/1]).

-record(create_repository_v1, {
    repository_id :: binary() | undefined,
    name :: binary() | undefined,
    steward :: binary() | undefined,
    default_branch :: binary() | undefined,
    visibility :: binary() | undefined
}).

-opaque t() :: #create_repository_v1{}.
-export_type([t/0]).

-spec command_type() -> atom().
command_type() -> create_repository_v1.

-spec new(map()) -> {ok, t()} | {error, term()}.
new(#{repository_id := Id} = Params) ->
    {ok, #create_repository_v1{
        repository_id = Id,
        name = maps:get(name, Params, undefined),
        steward = maps:get(steward, Params, undefined),
        default_branch = maps:get(default_branch, Params, undefined),
        visibility = maps:get(visibility, Params, undefined)
    }};
new(_) ->
    {error, missing_aggregate_id}.

-spec from_map(map()) -> {ok, t()} | {error, term()}.
from_map(#{<<"repository_id">> := Id} = Map) ->
    {ok, #create_repository_v1{
        repository_id = Id,
        name = maps:get(<<"name">>, Map, undefined),
        steward = maps:get(<<"steward">>, Map, undefined),
        default_branch = maps:get(<<"default_branch">>, Map, undefined),
        visibility = maps:get(<<"visibility">>, Map, undefined)
    }};
from_map(_) ->
    {error, missing_aggregate_id}.

-spec validate(t()) -> ok | {error, term()}.
validate(#create_repository_v1{repository_id = undefined}) -> {error, missing_aggregate_id};
validate(_) -> ok.

-spec to_map(t()) -> map().
to_map(#create_repository_v1{} = Cmd) ->
    #{
        command_type => create_repository_v1,
        repository_id => Cmd#create_repository_v1.repository_id,
        name => Cmd#create_repository_v1.name,
        steward => Cmd#create_repository_v1.steward,
        default_branch => Cmd#create_repository_v1.default_branch,
        visibility => Cmd#create_repository_v1.visibility
    }.

-spec stream_id(t()) -> binary().
stream_id(#create_repository_v1{repository_id = Id}) ->
    <<"repository-", Id/binary>>.

-spec get_repository_id(t()) -> binary() | undefined.
get_repository_id(#create_repository_v1{repository_id = V}) -> V.

-spec get_name(t()) -> binary() | undefined.
get_name(#create_repository_v1{name = V}) -> V.

-spec get_steward(t()) -> binary() | undefined.
get_steward(#create_repository_v1{steward = V}) -> V.

-spec get_default_branch(t()) -> binary() | undefined.
get_default_branch(#create_repository_v1{default_branch = V}) -> V.

-spec get_visibility(t()) -> binary() | undefined.
get_visibility(#create_repository_v1{visibility = V}) -> V.
