%%% @doc Discovers Cowboy routes from umbrella apps.
-module(hecate_git_api_routes).

-export([discover_routes/0]).

-define(GIT_APPS, [
    git,
    manage_repositories,
    manage_refs,
    query_repositories,
    query_refs
]).

discover_routes() ->
    lists:flatmap(fun routes_for_app/1, ?GIT_APPS).

routes_for_app(App) ->
    case application:get_key(App, modules) of
        {ok, Modules} -> lists:flatmap(fun routes_for_module/1, Modules);
        undefined     -> []
    end.

routes_for_module(Mod) ->
    case erlang:function_exported(Mod, routes, 0) of
        true  -> try Mod:routes() catch _:_ -> [] end;
        false -> []
    end.
