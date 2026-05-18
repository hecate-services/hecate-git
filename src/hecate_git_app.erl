%%% @doc hecate-git OTP application entry.
-module(hecate_git_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    hecate_om:boot(hecate_git_service).

stop(_State) ->
    ok.
