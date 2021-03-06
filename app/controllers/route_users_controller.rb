class RouteUsersController < ApplicationController

  before_action :set_route_user, only:[:edit, :update, :destroy]

  def new
    @route_user = RouteUser.new(user_id:(current_user.id unless current_user.nil?))
    authorize @route_user
    @route_user.route_id = params[:route_id]
    @route = @route_user.route
    if @route
      @routes = [@route]
      @airports = Gmaps4rails.build_markers(@route.airports) do |airport, marker|
        marker.lat airport.latitude
        marker.lng airport.longitude
        marker.picture({
          url:"/assets/airplane21.png",
          width:"32",
          height:"32",
          anchor:["12", "12"]
          })
          marker.infowindow render_to_string(partial:'shared/mapinfo',
          locals:{airport:airport}).gsub(/\n/, '').gsub(/"/,'\"')
      end
      @polylines = [@route.map_line]
    end
  end

  def create
    @route_user = RouteUser.new(route_user_params)
    authorize @route_user
    if @route_user.save
      flash[:notice] = "Flight successfully logged."
      redirect_to @route_user.user
    else
      flash[:alert] = "Failed to Log Flight"
      render :new
    end
  end

  def destroy
    authorize @route_user
    @route_user.destroy
    redirect_to @route_user.user
  end

  def edit
    authorize @route_user
  end

  def update
    authorize @route_user
    if @route_user.update(route_user_params) && @route_user.date
      flash[:notice] = "Flight successfully updated."
      redirect_to @route_user.user
    else
      flash[:alert] = "Failed to update flight"
      render :edit, id:@route_user
    end
  end

  private

    def set_route_user
      @route_user = RouteUser.find(params[:id])
    end

    def route_user_params
      params.require(:route_user).permit(:user_id, :route_id, :date)
    end

end
