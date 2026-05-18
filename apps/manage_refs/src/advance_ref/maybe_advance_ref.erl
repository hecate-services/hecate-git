%%% @doc Handler for `advance_ref_v1`. Validates the command and produces
%%% `ref_advanced_v1` as its outcome. Wire into evoq via
%%% `evoq:register_handler(advance_ref_v1, ?MODULE)` once business rules
%%% land here.
-module(maybe_advance_ref).

-export([handle/1, handle/2, dispatch/1]).

-spec handle(advance_ref_v1:t()) ->
    {ok, [ref_advanced_v1:t()]} | {error, term()}.
handle(Cmd) -> handle(Cmd, undefined).

-spec handle(advance_ref_v1:t(), term()) ->
    {ok, [ref_advanced_v1:t()]} | {error, term()}.
handle(Cmd, _State) ->
    case advance_ref_v1:validate(Cmd) of
        ok ->
            {ok, Event} = ref_advanced_v1:new(#{
                repository_id => advance_ref_v1:get_repository_id(Cmd)
                %% TODO: copy relevant fields from Cmd into Event
            }),
            {ok, [Event]};
        {error, R} ->
            {error, R}
    end.

%% @doc Dispatch via evoq — persists the produced event(s).
-spec dispatch(advance_ref_v1:t()) -> ok | {error, term()}.
dispatch(Cmd) ->
    StreamId = advance_ref_v1:stream_id(Cmd),
    evoq:dispatch(rag_store, StreamId, Cmd, ?MODULE).
