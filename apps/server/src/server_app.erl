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
%    case serversup:start_link() of
%        {ok, Pid} ->
%            {ok, Pid};
%        Error ->
%            Error
%    end.
%{ok, C} = eredis:start_link(),
%{ok, _ElemCnt} = eredis:q(C, ["LPUSH", "mylist", "bar"]),
%{ok, <<"bar">>} = eredis:q(C, ["RPOP", "mylist"]),
%X = 777,
%erlang:display(X),
Pid = spawn(server_sup, start_link, []),
{ok, Pid}.


stop(_State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================




