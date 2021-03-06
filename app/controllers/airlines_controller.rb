class AirlinesController < ApplicationController

  helper_method :sort_column, :sort_direction
  autocomplete :airline, :name

  def show
    @airline = Airline.find(params[:id])
  end

  def index
    @airlines = Airline.where("routes_count > 0").
        order(sort_column.to_s + " " + sort_direction.to_s).
        page params[:page]
  end

end
