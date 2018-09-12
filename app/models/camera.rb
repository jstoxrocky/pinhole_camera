require 'minimization'

class Camera < ApplicationRecord
  attr_accessor :pinhole_diameter

  def initialize(pinhole_diameter)
    @pinhole_diameter = pinhole_diameter
  end

  def calc_petzval_focal_length
    wavelength_light = 0.00055 #550 nm
    (1 / wavelength_light) * ((@pinhole_diameter / 2.0) ** 2)
  end

  def calc_young_focal_length
    wavelength_light = 0.00055 #550 nm
    (@pinhole_diameter ** 2) / wavelength_light
  end

  def calc_pinhole_to_image_angle(image_width, focal_length)
    image_halved_width = image_width / 2.0
    ratio = image_halved_width / focal_length
    Math.atan(ratio) # Radians
  end

  def calc_arc_length(focal_length, angle_in_radians)
    focal_length * angle_in_radians
  end

  def calc_distortion(image_width, focal_length)
    (image_width / 2.0) - focal_length * Math.atan((image_width / 2.0) / focal_length)
  end

  def solve_for_image_width(focal_length)
    distortion_maximum = 0.5
    f = proc {|image_width| (calc_distortion(image_width, focal_length) - distortion_maximum).abs}
    d = Minimization::Brent.new(0, 500 , f)
    d.iterate
    d.x_minimum
  end

  def specs
    focal_length = calc_petzval_focal_length
    image_width = solve_for_image_width(focal_length)
    angle = calc_pinhole_to_image_angle(image_width, focal_length) * 180 / Math::PI
    distortion = calc_distortion(image_width, focal_length)
    puts ""
    puts "Petzval Focal Length:"
    puts "--------------------------------------"
    puts "Pinhole diameter: #{@pinhole_diameter}"
    puts "Focal length: #{focal_length}"
    puts "Image width: #{image_width}"
    puts "Distortion: #{distortion}"
    puts "Pinhole to image angle: #{angle}"
  end

end
