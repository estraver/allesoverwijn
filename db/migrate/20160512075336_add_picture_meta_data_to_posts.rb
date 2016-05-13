class AddPictureMetaDataToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :picture_meta_data, :binary
  end
end
