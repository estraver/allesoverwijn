class CreateSettingContents < ActiveRecord::Migration
  def change
    create_table :setting_contents do |t|
      t.string :value, null: false
      t.string :locale, limit: 2, null: false
      t.references :setting, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
