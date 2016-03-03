class RenameColumnPhotoInTableProfilesToPhotoMetaData < ActiveRecord::Migration
  def change
    rename_column :profiles, :photo, :photo_meta_data
  end
end
