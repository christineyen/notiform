class AddTokenFieldIdToWufooForms < ActiveRecord::Migration
  def self.up
  	add_column :wufoo_forms, :token_field_id, :string, :default => ''
  end

  def self.down
  	drop_column :wufoo_forms, :token_field_id
  end
end
