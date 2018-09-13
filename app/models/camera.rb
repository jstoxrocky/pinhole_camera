require 'minimization'

class Camera < ApplicationRecord

  def calc_petzval_focal_length
    wavelength_light = 0.00055 #550 nm
    (1 / wavelength_light) * ((self.pinhole_diameter / 2.0) ** 2)
  end

  def calc_young_focal_length
    wavelength_light = 0.00055 #550 nm
    (self.pinhole_diameter ** 2) / wavelength_light
  end

  def calc_pw_focal_length
    wavelength_light = 0.00055 #550 nm
    m = 0 # 0: infinity (object distance so large compared to image distance)
          # 1: object distance is equal to image distance
    ((self.pinhole_diameter ** 2.0) * (1 + m)) / (2.44 * wavelength_light)
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

  def calc_specs
    self.focal_length = calc_pw_focal_length
    self.image_width = solve_for_image_width(focal_length)
    self.pinhole_to_image_angle = calc_pinhole_to_image_angle(image_width, focal_length) * 180 / Math::PI
    self.distortion = calc_distortion(image_width, focal_length)
  end

end
