class CamerasController < ApplicationController
  def index
    cameras = Camera.all
    render json: cameras
  end

  def show
    camera = Camera.find(params[:id])
    render json: [camera]
  end

  def create
    camera = Camera.new(camera_params)
    camera.save
    render json: [camera]
  end

  private

  def camera_params
    params.require(:camera).permit(:pinhole_diameter)
  end
end
