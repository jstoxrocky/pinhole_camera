require 'rails_helper'

schema = {
  type: 'object',
  required: %w[
    id
    pinhole_diameter
    focal_length
    image_width
    distortion
    pinhole_to_image_angle
    created_at
    updated_at
  ],
  properties: {
    id: { type: 'integer' },
    pinhole_diameter: { type: 'float' },
    focal_length: { type: 'float' },
    image_width: { type: 'float' },
    distortion: { type: 'float' },
    pinhole_to_image_angle: { type: 'float' },
    created_at: { type: 'string' },
    updated_at: { type: 'string' }
  }
}

describe CamerasController, type: :controller do
  before(:each) do
    Camera.delete_all
  end

  describe 'GET #index' do
    before(:each) do
      Camera.delete_all
      @camera = FactoryBot.build(:camera)
    end

    describe 'no data yet' do
      it 'should return http success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'should return the empty list' do
        get :index
        result = JSON.parse(response.body)
        expect(result.length).to be(0)
      end
    end

    describe 'has data' do
      before(:each) do
        @camera.save
      end

      it 'should validate returned JSON' do
        get :index
        first_result = JSON.parse(response.body)[0]
        validation = JSON::Validator.validate(schema, first_result)
        expect(validation).to be(true)
      end
    end
  end

  describe 'GET #show' do
    before(:each) do
      @camera = FactoryBot.build(:camera)
    end

    describe 'no data yet' do
      it 'should return http success' do
        get :show, params: { id: 1 }
        expect(response).to have_http_status(:success)
      end

      it 'should return the null camera' do
        get :show, params: { id: 1 }
        result = JSON.parse(response.body)
        expect(result.length).to be(0)
      end
    end

    describe 'has data' do
      before(:each) do
        @camera.save
      end

      it 'should validate returned JSON' do
        get :show, params: { id: @camera }
        first_result = JSON.parse(response.body)[0]
        validation = JSON::Validator.validate(schema, first_result)
        expect(validation).to be(true)
      end
    end
  end

  describe 'POST #create' do
    before(:each) do
      @attr = { pinhole_diameter: 1.0 }
    end

    it 'should return http success' do
      post :create, params: { camera: @attr }
      expect(response).to have_http_status(:success)
    end

    it 'should validate returned JSON' do
      post :create, params: { camera: @attr }
      first_result = JSON.parse(response.body)[0]
      validation = JSON::Validator.validate(schema, first_result)
      expect(validation).to be(true)
    end

    describe 'failure' do
      it 'should fail on non-numeric pinhole_diameter' do
        @attr[:pinhole_diameter] = ''
        expect(
          lambda do
            post :create, params: { camera: @attr }
          end
        ).to_not change(Camera, :count)
      end

      it 'should fail on negative pinhole_diameter' do
        @attr[:pinhole_diameter] = -0.3
        expect(
          lambda do
            post :create, params: { camera: @attr }
          end
        ).to_not change(Camera, :count)
      end
    end

    describe 'success' do
      it 'should succeed' do
        expect(
          lambda do
            post :create, params: { camera: @attr }
          end
        ).to change(Camera, :count).by(1)
      end
    end
  end

  describe 'DELETE #clear' do
    before(:each) do
      @camera = FactoryBot.create(:camera)
    end

    it 'should return http success' do
      delete :clear
      expected = 0
      expect(Camera.count).to eq(expected)
    end
  end
end
