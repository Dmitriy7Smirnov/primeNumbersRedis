-define(N, 100).
-define(RedisHost, localhost).
-define(RedisPort, 7654).
-define(RedisDB, myRedisDb).

-record(state, {
  name,
  number,
  connection
}).