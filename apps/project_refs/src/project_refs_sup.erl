-module(project_refs_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, {
        #{strategy => one_for_one, intensity => 10, period => 10},
        [#{id => ref_advanced_v1_to_refs, start => {ref_advanced_v1_to_refs, start_link, []}, restart => permanent, shutdown => 5000, type => worker, modules => [ref_advanced_v1_to_refs]},
        #{id => ref_retired_v1_to_refs, start => {ref_retired_v1_to_refs, start_link, []}, restart => permanent, shutdown => 5000, type => worker, modules => [ref_retired_v1_to_refs]}]
    }}.
