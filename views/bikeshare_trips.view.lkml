view: bikeshare_trips {
  sql_table_name: `bigquery-public-data.austin_bikeshare.bikeshare_trips` ;;

  dimension: bike_id {
    type: string
    description: "ID of bike used"
    sql: ${TABLE}.bike_id ;;
  }
  dimension: bike_type {
    type: string
    description: "Type of bike used (e.g., electric, classic)"
    sql: ${TABLE}.bike_type ;;
  }
  dimension: duration_minutes {
    type: number
    description: "Time of trip in minutes"
    sql: ${TABLE}.duration_minutes ;;
    value_format_name: "decimal_0"
  }
  dimension: end_station_id {
    type: string  # Keep as string to match source column
    description: "Numeric reference for end station"
    sql: ${TABLE}.end_station_id ;;
  }
  dimension: end_station_name {
    type: string
    description: "Station name for end station"
    sql: ${TABLE}.end_station_name ;;
  }
  dimension: start_station_id {
    type: number # Matching the type in bikeshare_stations
    description: "Numeric reference for start station"
    sql: ${TABLE}.start_station_id ;;
  }
  dimension: start_station_name {
    type: string
    description: "Station name for start station"
    sql: ${TABLE}.start_station_name ;;
  }
  dimension_group: start {
    type: time
    description: "Start timestamp of trip"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.start_time ;;
  }
  dimension: subscriber_type {
    type: string
    description: "Type of the Subscriber (e.g., Member, Single Trip)."
    sql: ${TABLE}.subscriber_type ;;
  }
  dimension: trip_id {
    primary_key: yes
    type: string
    description: "Numeric ID of bike trip"
    sql: ${TABLE}.trip_id ;;
  }
# Parameter for Dynamic Analysis
  parameter: trip_grouping {
    type: unquoted
    description: "Choose a category to group trips by."
    default_value: "bike_type"
    allowed_value: { label: "Bike Type" value: "bike_type" }
    allowed_value: { label: "Subscriber Type" value: "subscriber_type" }
  }
  dimension: dynamic_trip_group {
    type: string
    description: "Trips grouped by the selected category."
    sql:
      CASE
        WHEN {% parameter trip_grouping %} = 'bike_type' THEN ${bike_type}
        WHEN {% parameter trip_grouping %} = 'subscriber_type' THEN ${subscriber_type}
        ELSE 'Unknown'
      END ;;
  }
  measure: count {
    type: count
    drill_fields: [trip_id, bike_id, start.date]
    description: "Total number of trips."
  }
  measure: average_duration {
    type: average
    sql: ${duration_minutes} ;;
    value_format_name: "decimal_1"
    description: "Average trip duration in minutes."
    drill_fields: [trip_id, bike_id, duration_minutes, start.date]
  }
  measure: total_duration_minutes {
    type: sum
    sql: ${duration_minutes} ;;
    value_format_name: "decimal_0"
    description: "Total trip minutes."
  }

  measure: unique_bikes_used {
    type: count_distinct
    sql: ${bike_id} ;;
    description: "Number of unique bikes used."
  }
}
