require 'rails_helper'

RSpec.describe Camera, type: :model do
  describe "Camera" do

    let(:camera) { FactoryBot.build(:camera) }

    it "should calculate correct Petzval focal length from a given pinhole diameter" do
      expected = 454.5454545454545
      value = camera.calc_petzval_focal_length
      expect(value).to be == expected
    end

    it "should calculate correct Young focal length from a given pinhole diameter" do
      expected = 1818.181818181818
      value = camera.calc_young_focal_length
      expect(value).to be == expected
    end

    it "should calculate correct pinhole to image angle in radians" do
      expected = 0.14844180716321173
      image_width = 135.94709742110132
      focal_length = 454.5454545454545
      value = camera.calc_pinhole_to_image_angle(image_width, focal_length)
      expect(value).to be == expected
    end

    it "should calculate correct arc length" do
      expected = 74.33028128214151
      angle_in_radians = 0.16352661883660494
      focal_length = 454.545454501276
      value = camera.calc_arc_length(focal_length, angle_in_radians)
      expect(value).to be == expected
    end

    it "should calculate for correct film distortion" do
      expected = 0.6697187178584869
      focal_length = 454.545454501276
      image_width = 150.0
      value = camera.calc_distortion(image_width, focal_length)
      expect(value).to be == expected
    end

    it "should solve for the correct image width" do
      expected = 135.9470973201974
      focal_length = 454.545454501276
      value = camera.solve_for_image_width(focal_length)
      expect(value).to be == expected
    end

    it "should return the correct camera specs" do
      camera.specs
    end

  end
end