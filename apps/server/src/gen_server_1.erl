%% @author: Dima
%% @date: 23.11.2019
-module(gen_server_1).

-behaviour(gen_server).

%% Include files


%% Exported Functions

-export([
    start_link/0,
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-record(state, {
    name :: string(),
    number :: number(),
    connection :: pid()
}).

%%%===================================================================
%%% API
%%%===================================================================
    
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    {ok, Connection} = eredis:start_link(server_config:redis_host(), server_config:redis_port(), server_config:redis_db()),
    eredis:q(Connection, ["FLUSHDB"]),
    self() ! random_number_msg,
    {ok, #state{name = "Player", number = 789, connection = Connection}}.

handle_call({send_messages, Messages, SSL_Options}, _From, State) ->
    {Reply, State3} = erlang:send_messages(Messages, SSL_Options, State),
    {reply, Reply, State3}.

handle_cast({do_something, _A, _B}, State) ->
    {noreply, State}.

handle_info(random_number_msg, #state{connection = Connection} = State) ->
    Random_number = rand:uniform(server_config:max_n()-1) + 1, 
    {ok, _ElemCnt} = eredis:q(Connection, ["LPUSH", "QueueKey", integer_to_list(Random_number)]),
    {ok, RandNumber} = eredis:q(Connection, ["RPOP", "QueueKey"]),
    IsPrime = is_prime(list_to_integer(binary_to_list(RandNumber))),
    if 
        IsPrime -> eredis:q(Connection, ["SADD", "ResultSetKey", RandNumber]);
        true -> false
    end,
    erlang:send_after(200, self(), random_number_msg),
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

is_prime(Number) when Number < 4 -> true;
is_prime(Number) ->
    Num = Number div 2, 
    List = lists:seq(2, Num),
    case lists:search(fun(Elem) -> Number rem Elem == 0 end, List) of
      false -> true;
      _ -> false
    end.   





