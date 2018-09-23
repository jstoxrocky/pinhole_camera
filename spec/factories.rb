FactoryBot.define do
  factory :camera, class: Camera do
    initialize_with { new(pinhole_diameter: 0.85) }
  end
end
