require 'rails_helper'

RSpec.describe CamerasController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do

    before(:each) do
      @camera = FactoryBot.create(:camera)
    end

    it "returns http success" do
      get :show, params: { id: @camera }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    before(:each) do
      @attr = { :pinhole_diameter => 1.0 }
    end

    it "returns http success" do
      post :create, params: { :camera => @attr }
      expect(response).to have_http_status(:success)
    end
  end

end
