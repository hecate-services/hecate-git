%%% @doc Service-level root supervisor for hecate-git.
-module(hecate_git_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    SupFlags = #{strategy => one_for_one, intensity => 10, period => 10},
    Children = [
        cowboy_child(),
        #{id => hecate_git_mesh_rpc,
          start => {hecate_git_mesh_rpc, start_link, []},
          restart => permanent, shutdown => 5000,
          type => worker, modules => [hecate_git_mesh_rpc]}
    ],
    {ok, {SupFlags, Children}}.

cowboy_child() ->
    Port = application:get_env(hecate_git, http_port, 8470),
    Dispatch = cowboy_router:compile(routes()),
    #{id => cowboy_listener,
      start => {cowboy, start_clear, [hecate_git_http_listener,
                                       [{port, Port}],
                                       #{env => #{dispatch => Dispatch}}]},
      restart => permanent, shutdown => 5000,
      type => worker, modules => [cowboy]}.

routes() ->
    HealthRoutes = hecate_om_health_handler:routes(),
    ApiRoutes    = hecate_git_api_routes:discover_routes(),
    [{'_', HealthRoutes ++ ApiRoutes}].
