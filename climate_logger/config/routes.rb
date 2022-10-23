Rails.application.routes.draw do
  resources :climates
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Send get request to ESP8266 to turn LED on and off
  get "/get_data", to: "climates#getData", as: "get_data"
  # get "/update", to: "climates#update", as: "update"

  get "/led/on", to: "climates#ledOn", as: "led_on"
  get "/led/off", to: "climates#ledOff", as: "led_off"
  get "/led2/on", to: "climates#led2On", as: "led2_on"
  get "/led2/off", to: "climates#led2Off", as: "led2_off"
  get "/led3/on", to: "climates#led3On", as: "led3_on"
  get "/led3/off", to: "climates#led3Off", as: "led3_off"

end
