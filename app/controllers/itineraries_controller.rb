class ItinerariesController < ApplicationController
  def new
    @itinerary = Itinerary.new
  end

  def create
    @itinerary = Itinerary.new(itinerary_params)
    @itinerary.interests.reject!(&:blank?)
    if @itinerary.save
      redirect_to itinerary_path(@itinerary)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @itinerary = Itinerary.find(params[:id])
    api = GooglePlacesApi.new(@itinerary)
    @places = api.get_places
    @events = @itinerary.events
  end

  private

  def itinerary_params
    params.require(:itinerary).permit(:address, :date, :start_time, :end_time, :budget, interests: []).merge(interests: params[:itinerary][:interests] || [])
  end
end
