class CamerasController < ApplicationController

  def show
    @camera = Camera.find(params[:id])
  end

end
