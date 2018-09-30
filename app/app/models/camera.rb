require 'minimization'

class Camera < ApplicationRecord
  after_initialize :init
  validates :pinhole_diameter,
            presence: true,
            numericality: {
              only_float: true,
              greater_than: 0
            }

  def init
    @wavelength_light = 0.00055 # nm
    calc_specs
  end

  def calc_pw_focal_length
    # 0: infinity (object distance so large compared to image distance)
    # 1: object distance is equal to image distance
    m = 0
    ((pinhole_diameter**2.0) * (1 + m)) / (2.44 * @wavelength_light)
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
    flat_surface = image_width / 2.0
    curve_surface = focal_length * Math.atan((image_width / 2.0) / focal_length)
    flat_surface - curve_surface
  end

  def solve_for_image_width(focal_length)
    distortion_maximum = 0.5
    f = lambda do |image_width|
      (calc_distortion(image_width, focal_length) - distortion_maximum).abs
    end
    lower_bound = 0
    upper_bound = 500
    d = Minimization::Brent.new(lower_bound, upper_bound, f)
    d.iterate
    d.x_minimum
  end

  def calc_specs
    self.focal_length = calc_pw_focal_length
    self.image_width = solve_for_image_width(focal_length)
    angle_in_radians = calc_pinhole_to_image_angle(image_width, focal_length)
    self.pinhole_to_image_angle = angle_in_radians * 180 / Math::PI
    self.distortion = calc_distortion(image_width, focal_length)
  end
end
