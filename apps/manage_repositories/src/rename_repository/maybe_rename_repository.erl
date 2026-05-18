%%% @doc Handler for `rename_repository_v1`. Validates the command and produces
%%% `repository_renamed_v1` as its outcome. Wire into evoq via
%%% `evoq:register_handler(rename_repository_v1, ?MODULE)` once business rules
%%% land here.
-module(maybe_rename_repository).

-export([handle/1, handle/2, dispatch/1]).

-spec handle(rename_repository_v1:t()) ->
    {ok, [repository_renamed_v1:t()]} | {error, term()}.
handle(Cmd) -> handle(Cmd, undefined).

-spec handle(rename_repository_v1:t(), term()) ->
    {ok, [repository_renamed_v1:t()]} | {error, term()}.
handle(Cmd, _State) ->
    case rename_repository_v1:validate(Cmd) of
        ok ->
            {ok, Event} = repository_renamed_v1:new(#{
                repository_id => rename_repository_v1:get_repository_id(Cmd)
                %% TODO: copy relevant fields from Cmd into Event
            }),
            {ok, [Event]};
        {error, R} ->
            {error, R}
    end.

%% @doc Dispatch via evoq — persists the produced event(s).
-spec dispatch(rename_repository_v1:t()) -> ok | {error, term()}.
dispatch(Cmd) ->
    StreamId = rename_repository_v1:stream_id(Cmd),
    evoq:dispatch(rag_store, StreamId, Cmd, ?MODULE).
