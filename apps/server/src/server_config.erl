%% @author: Dima
%% @date: 27.11.2019

-module(server_config).

%% Include files

%% Exported Functions

-export([
    max_n/0,
    redis_host/0,
    redis_port/0,
    redis_db/0
]).

%%%===================================================================
%%% API
%%%===================================================================

-spec max_n() -> non_neg_integer().

max_n() ->
    {ok, Max_n} = application:get_env(server, max_n),
    Max_n.

-spec redis_host() -> atom() | string().

redis_host() -> 
    {ok, Redis_host} = application:get_env(server, redis_host),
    Redis_host.

-spec redis_port() -> non_neg_integer().

redis_port() ->
    {ok, Redis_port} = application:get_env(server, redis_port),
    Redis_port.

-spec redis_db() -> non_neg_integer().

redis_db() ->
    {ok, Redis_db} = application:get_env(server, redis_db),
    Redis_db.

%%%===================================================================
%%% Internal functions
%%%===================================================================





