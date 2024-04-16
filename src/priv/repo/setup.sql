CREATE TABLE queries (
  id          integer primary key,
  ts          timestamp,
  interface   text,
  host        text,
  query       text,
  user_agent  text,
  success     boolean,
  artist      string,
  title       string,
);
CREATE INDEX ix_queries_ts on queries (ts);