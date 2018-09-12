class CreateCameras < ActiveRecord::Migration[5.2]
  def change
    create_table :cameras do |t|
      t.float :pinhole_diameter
      t.float :focal_length
      t.float :image_width
      t.float :distortion
      t.float :pinhole_to_image_angle

      t.timestamps
    end
  end
end
