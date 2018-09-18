require 'rails_helper'

RSpec.describe CamerasController, type: :controller do

  describe "GET #index" do
    it "shoudl return http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do

    before(:each) do
      @camera = FactoryBot.create(:camera)
    end

    it "should return http success" do
      get :show, params: { id: @camera }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do

    before(:each) do
      @attr = { :pinhole_diameter => 1.0 }
    end

    it "should return http success" do
      post :create, params: { :camera => @attr }
      expect(response).to have_http_status(:success)
    end

    describe "failure" do
      it "should fail on non-numeric pinhole_diameter" do
        @attr[:pinhole_diameter] = ""
        expect(
          lambda do
            post :create, params: { :camera => @attr }
          end
        ).to_not change(Camera, :count)
      end

      it "should fail on negative pinhole_diameter" do
        @attr[:pinhole_diameter] = -0.3
        expect(
          lambda do
            post :create, params: { :camera => @attr }
          end
        ).to_not change(Camera, :count)
      end
    end

    describe "success" do
      it "should succeed" do
        expect(
          lambda do
            post :create, params: { :camera => @attr }
          end
        ).to change(Camera, :count).by(1)
      end
    end
  end

end
