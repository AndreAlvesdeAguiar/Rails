class ClimatesController < ApplicationController
  before_action :set_climate, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  # GET /climates
  # GET /climates.json
  def index
    @climates = Climate.order(created_at: :desc)
  end

  # GET /climates/1
  # GET /climates/1.json
  def show
  end

  # GET /climates/new
  def new
    @climate = Climate.new
  end

  # GET /climates/1/edit
  def edit
  end

  # POST /climates
  # POST /climates.json
  def create
    @climate = Climate.new(climate_params)

    respond_to do |format|
      if @climate.save
        format.html { redirect_to @climate, notice: 'Climate was successfully created.' }
        format.json { render :show, status: :created, location: @climate }
      else
        format.html { render :new }
        format.json { render json: @climate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /climates/1
  # PATCH/PUT /climates/1.json
  def update
    respond_to do |format|
      if @climate.update(climate_params)
        format.html { redirect_to @climate, notice: 'Climate was successfully updated.' }
        format.json { render :show, status: :ok, location: @climate }
      else
        format.html { render :edit }
        format.json { render json: @climate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /climates/1
  # DELETE /climates/1.json
  def destroy
    @climate.destroy
    respond_to do |format|
      format.html { redirect_to climates_url, notice: 'Climate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #send GET request to ESP8266 and to turn fan up
  def ledOn
    #sends a GET request to the ESP8266 route dedicated to turning on the LED
    @response = HTTParty.get("http://192.168.15.21/LED/on/")
    puts @response

    #updates the flash alert if the JSON received says the LED is on
    if @response["Rec"] == "LEDon"
        flash.alert = "LED is turned on"
    end

    redirect_to climates_path

end

#send GET request to ESP8266 and updates flash alert
def ledOff
    #sends a GET request to the ESP8266 route dedicated to turning off the LED
    @response = HTTParty.get("http://192.168.15.21/LED/off/")
    puts @response

    #updates the flash alert if the JSON received says the LED is off
    if @response["Rec"] == "LEDoff"
        flash.alert = "LED is turned off"
    end

    redirect_to climates_path
end

def led2On
  #sends a GET request to the ESP8266 route dedicated to turning on the LED
  @response = HTTParty.get("http://192.168.15.21/LED2/on/")
  puts @response

  #updates the flash alert if the JSON received says the LED is on
  if @response["Rec"] == "LED2on"
      flash.alert = "LED2 is turned on"
  end

  redirect_to climates_path

end

#send GET request to ESP8266 and updates flash alert
def led2Off
  #sends a GET request to the ESP8266 route dedicated to turning off the LED
  @response = HTTParty.get("http://192.168.15.21/LED2/off/")
  puts @response

  #updates the flash alert if the JSON received says the LED is off
  if @response["Rec"] == "LED2off"
      flash.alert = "LED2 is turned off"
  end

  redirect_to climates_path
end

def led3On
  #sends a GET request to the ESP8266 route dedicated to turning on the LED
  @response = HTTParty.get("http://192.168.15.21/LED3/on/")
  puts @response

  #updates the flash alert if the JSON received says the LED is on
  if @response["Rec"] == "LED3on"
      flash.alert = "LED3 is turned on"
  end

  redirect_to climates_path

end

#send GET request to ESP8266 and updates flash alert
def led3Off
  #sends a GET request to the ESP8266 route dedicated to turning off the LED
  @response = HTTParty.get("http://192.168.15.21/LED3/off/")
  puts @response

  #updates the flash alert if the JSON received says the LED is off
  if @response["Rec"] == "LED3off"
      flash.alert = "LED3 is turned off"
  end

  redirect_to climates_path
end

#send GET request to ESP8266 to poll for new temperature data and adjust fan accordingly
def getData
  #sends a GET request to the ESP8266 route dedicated to turning off the LED
  @updateResponse = HTTParty.get("http://192.168.15.21/update/")
  puts @updateResponse

  @response = HTTParty.get("http://192.168.15.21/get_data/")
  puts @response
  render json: @response
end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_climate
    @climate = Climate.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def climate_params
    params.require(:climate).permit(:log_message, :temperature, :fan_position)
  end

end
