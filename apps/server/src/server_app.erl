%% @author: Dima
%% @date: 07.08.2019

-module(server_app).

-behaviour(application).

%% Application callbacks
-export([
    start/2, 
    stop/1
]).

%%%===================================================================
%%% Application callbacks
%%%===================================================================

start(_StartType, _StartArgs) ->
    server_sup:start_link().

stop(_State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================




