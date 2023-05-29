class ItinerariesController < ApplicationController
  def new
    @itinerary = Itinerary.new
  end

  def create
    @itinerary = Itinerary.new(itinerary_params)
    if @itinerary.save
      redirect_to itinerary_path(@itinerary)
    else
      render :new
    end
  end

  def show
    @itinerary = Itinerary.find(params[:id])
    @events = @itinerary.events
  end

  private

  def itinerary_params
    params.require(:itinerary).permit(:address, :date, :start_time, :end_time, :budget, interests: [])
  end
end
