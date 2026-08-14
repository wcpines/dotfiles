#################################
#----------DB Helpers----------#
#################################

# Function to get the current database type
get_db_type() {
  if [[ $(pwd) == *migrations* ]]; then
    echo "sqlite"
  else
    echo "postgres"
  fi
}

# Return success when the current directory is onboarding-services or a child directory.
in_onboarding_services() {
  [[ $PWD == "$HOME/Developer/onboarding-services" || $PWD == "$HOME/Developer/onboarding-services/"* ]]
}

# Pick the Postgres database based on the current project.
get_pg_db() {
  if in_onboarding_services; then
    echo "onboarding_service_dev"
  else
    echo "sched_development"
  fi
}

# Run psql against the database for the current project.
# onboarding-services reaches its Docker Compose database through the host port
# forward (127.0.0.1:5433). sched uses the local macOS Postgres instance.
pg_exec() {
  local pg_db="$1"
  shift

  if in_onboarding_services; then
    PGPASSWORD=postgres psql \
      --no-password \
      --host 127.0.0.1 \
      --port 5433 \
      --username postgres \
      --dbname "$pg_db" \
      "$@"
  else
    psql -d "$pg_db" "$@"
  fi
}

# Open an interactive psql session for the database in the current project.
# This replaces the local_db alias from ~/.env.sh.
unalias local_db 2>/dev/null
local_db() {
  pg_exec "$(get_pg_db)" "$@"
}

# Generic query function
query() {
  local db_type=$(get_db_type)
  case $db_type in
  postgres)
    local pg_db=$(get_pg_db)
    echo "DB: $pg_db"
    printf "RUNNING:\n%s\n" "$*"
    pg_exec "$pg_db" -c "$*"
    ;;
  sqlite)
    echo "DB: $LITEDB"
    sqlite3 -header -column "$LITEDB" "$@"
    ;;
  none)
    echo "No database connection set"
    ;;
  esac
}

column_names() {
  table_name=$1

  query "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '$table_name';"
}

# Show tables
show_tables() {
  local db_type=$(get_db_type)
  case $db_type in
  postgres)
    query '\dt;'
    ;;
  sqlite)
    query ".tables"
    ;;
  esac
}

# Describe table
desc_table() {
  local table_name=$1
  local db_type=$(get_db_type)
  case $db_type in
  postgres)
    query "\d+ $table_name;"
    ;;
  sqlite)
    query "PRAGMA table_info($table_name);"
    ;;
  esac
}

# Find tables
find_tables() {
  local table_name=$1
  local db_type=$(get_db_type)
  case $db_type in
  postgres)
    query "SELECT DISTINCT(table_name) FROM information_schema.columns WHERE table_name LIKE '%$table_name%';"
    ;;
  sqlite)
    query "SELECT name FROM sqlite_master WHERE type='table' AND name LIKE '%$table_name%';"
    ;;
  esac
}

# Find columns
find_columns() {
  local column_name=$1
  local exact_match=$2
  local db_type=$(get_db_type)
  case $db_type in
  postgres)
    if [[ -n $exact_match ]]; then
      query "SELECT column_name, table_name FROM information_schema.columns WHERE column_name = '$column_name' GROUP BY 1, 2 ORDER BY 2 desc;"
    else
      query "SELECT column_name, table_name FROM information_schema.columns WHERE column_name LIKE '%$column_name%' GROUP BY 1, 2 ORDER BY 2 desc;"
    fi
    ;;
  sqlite)
    query "SELECT m.name AS table_name, p.name AS column_name
                   FROM sqlite_master m
                   LEFT OUTER JOIN pragma_table_info((m.name)) p ON m.name <> p.name
                   WHERE p.name LIKE '%$column_name%'
                   ORDER BY m.name, p.cid;"
    ;;
  esac
}

unique_tables() {
  # for use with find_columns

  awk -F '|' '{print $2}' |
    sort -u |
    tail -n +3
}

find_long_query() {
  query "
    SELECT
           pid                      AS process_id,
           substring(query FOR 200) AS truncated_query,
           now() - query_start      AS duration,
           state                    AS state
    FROM pg_stat_activity
    WHERE (now() - query_start) > INTERVAL '2 minutes'
      AND query ilike '%DELETE%';"
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
alias sqlite3="/opt/homebrew/opt/sqlite/bin/sqlite3"

get_business() {
  query 'select id, name from businesses;'
}

get_locs() {
  business_id=$1
  query "SELECT b.id          AS businesss_id,
       b.name        AS business_name,
       l.id          AS location_id,
       l.external_id AS location_external_id,
       l.name        AS location_name
      FROM locations l
         JOIN businesses b ON b.id = l.business_id
      WHERE b.id = '$business_id';"
}
