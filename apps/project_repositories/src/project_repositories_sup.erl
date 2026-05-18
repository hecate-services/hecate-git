-module(project_repositories_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, {
        #{strategy => one_for_one, intensity => 10, period => 10},
        [#{id => repository_created_v1_to_repositories, start => {repository_created_v1_to_repositories, start_link, []}, restart => permanent, shutdown => 5000, type => worker, modules => [repository_created_v1_to_repositories]},
        #{id => repository_renamed_v1_to_repositories, start => {repository_renamed_v1_to_repositories, start_link, []}, restart => permanent, shutdown => 5000, type => worker, modules => [repository_renamed_v1_to_repositories]},
        #{id => repository_retired_v1_to_repositories, start => {repository_retired_v1_to_repositories, start_link, []}, restart => permanent, shutdown => 5000, type => worker, modules => [repository_retired_v1_to_repositories]}]
    }}.
