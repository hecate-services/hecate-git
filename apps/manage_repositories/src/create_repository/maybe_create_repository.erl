%%% @doc Handler for `create_repository_v1`. Validates the command and produces
%%% `repository_created_v1` as its outcome. Wire into evoq via
%%% `evoq:register_handler(create_repository_v1, ?MODULE)` once business rules
%%% land here.
-module(maybe_create_repository).

-export([handle/1, handle/2, dispatch/1]).

-spec handle(create_repository_v1:t()) ->
    {ok, [repository_created_v1:t()]} | {error, term()}.
handle(Cmd) -> handle(Cmd, undefined).

-spec handle(create_repository_v1:t(), term()) ->
    {ok, [repository_created_v1:t()]} | {error, term()}.
handle(Cmd, _State) ->
    case create_repository_v1:validate(Cmd) of
        ok ->
            {ok, Event} = repository_created_v1:new(#{
                repository_id => create_repository_v1:get_repository_id(Cmd)
                %% TODO: copy relevant fields from Cmd into Event
            }),
            {ok, [Event]};
        {error, R} ->
            {error, R}
    end.

%% @doc Dispatch via evoq — persists the produced event(s).
-spec dispatch(create_repository_v1:t()) -> ok | {error, term()}.
dispatch(Cmd) ->
    StreamId = create_repository_v1:stream_id(Cmd),
    evoq:dispatch(rag_store, StreamId, Cmd, ?MODULE).
