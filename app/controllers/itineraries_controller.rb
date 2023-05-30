class ItinerariesController < ApplicationController
  def new
    @itinerary = Itinerary.new
  end

  def create
    @itinerary = Itinerary.new(itinerary_params)
    @itinerary.interests.reject!(&:blank?)
    if @itinerary.save
      api = GooglePlacesApi.new(@itinerary)
      api.get_places
      redirect_to itinerary_path(@itinerary)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @itinerary = Itinerary.find(params[:id])
    @events = @itinerary.events
    @places = Place.where(itinerary_id: @itinerary.id)
  end

  private

  def itinerary_params
    params.require(:itinerary).permit(:address, :date, :start_time, :end_time, :budget, interests: []).merge(interests: params[:itinerary][:interests] || [])
  end
end
