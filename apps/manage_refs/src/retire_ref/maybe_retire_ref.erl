%%% @doc Handler for `retire_ref_v1`. Validates the command and produces
%%% `ref_retired_v1` as its outcome. Wire into evoq via
%%% `evoq:register_handler(retire_ref_v1, ?MODULE)` once business rules
%%% land here.
-module(maybe_retire_ref).

-export([handle/1, handle/2, dispatch/1]).

-spec handle(retire_ref_v1:t()) ->
    {ok, [ref_retired_v1:t()]} | {error, term()}.
handle(Cmd) -> handle(Cmd, undefined).

-spec handle(retire_ref_v1:t(), term()) ->
    {ok, [ref_retired_v1:t()]} | {error, term()}.
handle(Cmd, _State) ->
    case retire_ref_v1:validate(Cmd) of
        ok ->
            {ok, Event} = ref_retired_v1:new(#{
                repository_id => retire_ref_v1:get_repository_id(Cmd)
                %% TODO: copy relevant fields from Cmd into Event
            }),
            {ok, [Event]};
        {error, R} ->
            {error, R}
    end.

%% @doc Dispatch via evoq — persists the produced event(s).
-spec dispatch(retire_ref_v1:t()) -> ok | {error, term()}.
dispatch(Cmd) ->
    StreamId = retire_ref_v1:stream_id(Cmd),
    evoq:dispatch(rag_store, StreamId, Cmd, ?MODULE).
