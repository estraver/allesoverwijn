class RemovePropertyTypeIdFromProperties < ActiveRecord::Migration
  def change
    remove_reference :properties, :property_type, index: true, foreign_key: true
  end
end
