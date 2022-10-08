json.extract! climate, :id, :log_message, :temperature, :fan_position, :created_at, :updated_at
json.url climate_url(climate, format: :json)
