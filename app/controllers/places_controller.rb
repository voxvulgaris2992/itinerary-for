class PlacesController < ApplicationController
  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)
    if @place.save
      redirect_to place_path(@place)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def place_params
    params.require(:place).permit(:name, :description, :address, :opening_hours, :phone, :map_static, :map_link, :review_count, :review_samples, :rating, :image)
  end
end
