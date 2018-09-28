require 'rails_helper'

describe Camera, type: :model do
  before(:each) do
    @attr = {
      pinhole_diameter: 1.0
    }
  end

  describe 'Camera' do
    it 'should have all attributes on instatiation' do
      camera = Camera.new(@attr)
      expect(camera.pinhole_diameter).to_not be_blank
      expect(camera.focal_length).to_not be_blank
      expect(camera.image_width).to_not be_blank
      expect(camera.image_width).to_not be_blank
      expect(camera.pinhole_to_image_angle).to_not be_blank
      expect(camera.distortion).to_not be_blank
    end

    it 'should calculate correct Prober-Wellman focal length' do
      expected = 745.1564828614008
      camera = Camera.new(@attr)
      value = camera.calc_pw_focal_length
      expect(value).to be == expected
    end

    it 'should calculate correct pinhole to image angle in radians' do
      expected = 0.14844180716321173
      image_width = 135.94709742110132
      focal_length = 454.5454545454545
      camera = Camera.new(@attr)
      value = camera.calc_pinhole_to_image_angle(image_width, focal_length)
      expect(value).to be == expected
    end

    it 'should calculate correct arc length' do
      expected = 74.33028128214151
      angle_in_radians = 0.16352661883660494
      focal_length = 454.545454501276
      camera = Camera.new(@attr)
      value = camera.calc_arc_length(focal_length, angle_in_radians)
      expect(value).to be == expected
    end

    it 'should calculate for correct film distortion' do
      expected = 0.6697187178584869
      focal_length = 454.545454501276
      image_width = 150.0
      camera = Camera.new(@attr)
      value = camera.calc_distortion(image_width, focal_length)
      expect(value).to be == expected
    end

    it 'should solve for the correct image width' do
      expected = 135.9470973201974
      focal_length = 454.545454501276
      camera = Camera.new(@attr)
      value = camera.solve_for_image_width(focal_length)
      expect(value).to be == expected
    end
  end
end
