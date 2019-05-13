json.extract! history, :id, :console, :action, :date, :in_station_line, :in_station, :out_station_line, :out_station, :balance, :created_at, :updated_at
json.url history_url(history, format: :json)
