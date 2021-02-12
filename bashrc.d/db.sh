#################################
#----------DB Helpers----------#
#################################
column_names() {
	table_name=$1

	query "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '$table_name';"
}

show_tables() {
    query '\dt;'
}

desc_table() {
    table_name=$1

    query "\d+ $table_name;"
}

find_tables() {
    table_name=$1

    query "SELECT DISTINCT(table_name) FROM information_schema.columns WHERE table_name LIKE '%$table_name%';"
}

find_columns() {
    column_name=$1
    exact_match=$2

    if [[ -n $exact_match ]]; then
        query "SELECT column_name, table_name FROM information_schema.columns WHERE column_name = '$column_name' GROUP BY 1, 2 ORDER BY 2 desc;"
    else
        query "SELECT column_name, table_name FROM information_schema.columns WHERE column_name LIKE '%$column_name%' GROUP BY 1, 2 ORDER BY 2 desc;"
    fi
}

unique_tables() {
    # for use with find_columns

    awk -F '|' '{print $2}' |
        sort -u |
        tail -n +3
}

find_long_query() {
    query "SELECT
  pid                       AS process_id
  ,substring(query for 200) AS truncated_query
  ,now() - query_start      AS duration
  ,state                    AS state
  FROM pg_stat_activity
  WHERE(now() - query_start) > INTERVAL '5 minutes';"
}

json_sample_table() {
    table_name=$1
    where_condition=$2

    if [[ -z $where_condition ]]; then
        query "SELECT json_agg(t) FROM (
    SELECT * from $table_name ORDER BY created_at desc LIMIT 2
      ) t"
    else
        query "SELECT json_agg(t) FROM (
      SELECT * from $table_name where $where_condition ORDER BY created_at desc LIMIT 2
      ) t"
    fi
}

#-- sqlite3 helpers --#
sqc() {
    query=$1
    sqlite3 -header -column "$LITEDB" "$query"
}

sqdt() {
    sqc ".tables"
}

sqdesc() {
    table=$1
    sqc "PRAGMA table_info($table);"
}

resource_by_id() {
    table=$1
    id=$2
    columns=${@:3}
    if [[ -n $columns ]]; then
        query "select $columns from $table where id = $id"
    else
        query "select * from $table where id = $id"
    fi
}

paste_query() {
    query "$(pbpaste)" | tee >(pbcopy)
}

