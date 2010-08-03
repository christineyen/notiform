class CreateWufooForms < ActiveRecord::Migration
  def self.up
    create_table :wufoo_forms do |t|
      t.integer :id
      t.string :subdomain
      t.string :form_name
      t.string :api_key
      t.timestamps
    end
  end

  def self.down
    drop_table :wufoo_forms
  end
end
