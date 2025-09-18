# Define the database connection to be used for this model.
connection: "austin_bikeshare"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: Austin_Bikeshare_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: Austin_Bikeshare_default_datagroup

include: "/views/**/*.view.lkml" # Assuming your views are in a 'views' subfolder

explore: bikeshare_trips {
  view_label: "Bikeshare 🚵"
  label: "Bikeshare Trips & Stations 🚲"
  description: "Explore bikeshare trip data, including details about the start and end stations."

# You are taking the bikeshare_trips table and bolting on the bikeshare_stations table twice.

# The first time, you link using the trip's start_station_id to get details about where the trip began.
# The second time, you link using the trip's end_station_id to get details about where the trip ended.
# This setup allows users exploring the data to select fields like "Trip Duration", "Start Station Name", and "End Station Council District" all in the same query.

  join: start_station {
    view_label: "Start Station"
    from: bikeshare_stations
    type: left_outer
    sql_on: ${bikeshare_trips.start_station_id} = ${start_station.station_id} ;;
    relationship: many_to_one
  }

  join: end_station {
    view_label: "End Station"
    from: bikeshare_stations
    type: left_outer
    # Note: bikeshare_trips.end_station_id is a string, bikeshare_stations.station_id is a number.
    # Casting end_station_id to an INTEGER for the join. Ensure this is safe for your data.
    sql_on: SAFE_CAST(${bikeshare_trips.end_station_id} AS INT64) = ${end_station.station_id} ;;
    relationship: many_to_one
  }
}
