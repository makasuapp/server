class AddVolumeWeightRatio < ActiveRecord::Migration[5.2]
  def change
    add_column :ingredients, :volume_weight_ratio, :float
    add_column :recipes, :output_volume_weight_ratio, :float
  end
end
