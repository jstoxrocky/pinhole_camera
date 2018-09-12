FactoryBot.define do
  pinhole_diameter = 1.0
  factory :camera, class: Camera do
    initialize_with { new(pinhole_diameter) }
  end
end