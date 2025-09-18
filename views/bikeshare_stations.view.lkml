view: bikeshare_stations {
  sql_table_name: `bigquery-public-data.austin_bikeshare.bikeshare_stations` ;;

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
    description: "Street address of the station."
  }
  dimension: alternate_name {
    hidden: yes
    type: string
    sql: ${TABLE}.alternate_name ;;
  }
  dimension: city_asset_number {
    hidden: yes
    type: number
    sql: ${TABLE}.city_asset_number ;;
  }
  dimension: council_district {
    type: number
    sql: ${TABLE}.council_district ;;
    description: "City council district number."
  }
  dimension: footprint_length {
    hidden: yes
    type: number
    sql: ${TABLE}.footprint_length ;;
  }
  dimension: footprint_width {
    hidden: yes
    type: number
    sql: ${TABLE}.footprint_width ;;
  }
  dimension: image {
    hidden: yes
    type: string
    sql: ${TABLE}.image ;;
  }
  dimension: location {
    type: location
    sql_latitude: REGEXP_EXTRACT(${TABLE}.location, r"\((\-?\d+\.\d+),") ;;
    # REGEXP_EXTRACT: This function extracts the first substring in ${TABLE}.location that matches the provided regular expression.
    # r"...": This indicates a raw string literal, making it easier to write the regular expression without excessive backslash escaping.
    # \( : Matches the literal opening parenthesis (.
    # (\-?\d+\.\d+): This is the capturing group. REGEXP_EXTRACT returns the part of the string matched by this group.
    # \-?: Matches an optional minus sign -.
    # \d+: Matches one or more digits.
    # \.: Matches a literal dot . (the decimal point).
    # \d+: Matches one or more digits after the decimal.
    # ,: Matches the comma that follows the latitude value.
    # Result: This expression extracts the numerical latitude value from the string. For "(30.2672, -97.7431)", it would extract 30.2672.
    sql_longitude: REGEXP_EXTRACT(${TABLE}.location, r",\s*(\-?\d+\.\d+)\)") ;;
    # REGEXP_EXTRACT: Similar to the above.
    # ,\s*: Matches the comma, followed by zero or more whitespace characters (\s*).
    # (\-?\d+\.\d+): This is the capturing group for the longitude, using the same number pattern as the latitude.
    # \): Matches the literal closing parenthesis ).
    # Result: This expression extracts the numerical longitude value. For "(30.2672, -97.7431)", it would extract -97.7431.
    description: "Geographic coordinates of the station."
  }

  # Link to Google Maps
  dimension: map_link {
    type: string
    sql: ${TABLE}.location ;; # Base on location data
    html: <a href="https://www.google.com/maps/search/?api=1&query={{ value }}" target="_blank">View on Map</a> ;;
    label: "Map Location"
  }

  dimension_group: modified {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.modified_date ;;
    description: "Date and time the station information was last updated."
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    description: "Public name of the station."
  }
  dimension: notes {
    hidden: yes
    type: string
    sql: ${TABLE}.notes ;;
  }
  dimension: number_of_docks {
    type: number
    sql: ${TABLE}.number_of_docks ;;
    description: "Total number of docks at the station."
  }
  dimension: power_type {
    hidden: yes
    type: string
    sql: ${TABLE}.power_type ;;
  }
  dimension: property_type {
    hidden: yes
    type: string
    sql: ${TABLE}.property_type ;;
  }
  dimension: station_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.station_id ;;
    description: "Unique numeric identifier for the station."
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    description: "Current operational status of the station (e.g., active, inactive)."
  }
  measure: count {
    type: count
    drill_fields: [name, address]
    description: "Total number of stations."
  }
  measure: average_docks {
    type: average
    sql: ${number_of_docks} ;;
    value_format_name: "decimal_1"
    description: "Average number of docks per station."
  }
}
