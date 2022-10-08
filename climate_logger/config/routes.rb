Rails.application.routes.draw do
  resources :climates
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Send get request to ESP8266 to turn LED on and off
  get "/fan/up", to: "climates#fanUp", as: "fan_up"
  get "/fan/down", to: "climates#fanDown", as: "fan_down"
  get "/get_data", to: "climates#getData", as: "get_data"
  # get "/update", to: "climates#update", as: "update"

  get "/led/on", to: "climates#ledOn", as: "led_on"
  get "/led/off", to: "climates#ledOff", as: "led_off"
end
