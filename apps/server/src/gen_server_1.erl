%% @author: Dima
%% @date: 23.11.2019
-module(gen_server_1).

-behaviour(gen_server).

-define(QUEUE_KEY,"QueueKey").
-define(RESULT_SET_KEY, "ResultSetKey").
-define(DELAY_MILLISEC, 200).
-define(doif(FunBoolResult, OtherResult), if FunBoolResult -> OtherResult; true -> ignore end).

%% Include files


%% Exported Functions

-export([
    start_link/0,
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3,
    is_prime/1
]).

-record(state, {
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
    {ok, #state{connection = Connection}}.

handle_call({send_messages, Messages, SSL_Options}, _From, State) ->
    {Reply, State3} = erlang:send_messages(Messages, SSL_Options, State),
    {reply, Reply, State3}.

handle_cast({do_something, _A, _B}, State) ->
    {noreply, State}.

handle_info(random_number_msg, #state{connection = Connection} = State) ->
    Random_number = rand:uniform(server_config:max_n()-1) + 1, 
    {ok, _ElemCnt} = eredis:q(Connection, ["LPUSH", ?QUEUE_KEY, integer_to_list(Random_number)]),
    {ok, RandNumber} = eredis:q(Connection, ["RPOP", ?QUEUE_KEY]),
    IsPrime = is_prime(list_to_integer(binary_to_list(RandNumber))),
    ?doif(IsPrime, eredis:q(Connection, ["SADD", ?RESULT_SET_KEY, RandNumber])),
    erlang:send_after(?DELAY_MILLISEC, self(), random_number_msg),
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

is_prime(Number) when  Number < 4 -> true;
is_prime (Number) when Number rem 2 == 0 -> false;
is_prime(Number) -> is_prime1(Number, 3, erlang:trunc(math:sqrt(Number))).
is_prime1(_Number, Divisor, TheBiggestDivisor) when Divisor > TheBiggestDivisor -> true;
is_prime1(Number, Divisor, _TheBiggestDivisor) when Number rem Divisor == 0 -> false;
is_prime1(Number, Divisor, TheBiggestDivisor) -> is_prime1(Number, Divisor + 2, TheBiggestDivisor).



