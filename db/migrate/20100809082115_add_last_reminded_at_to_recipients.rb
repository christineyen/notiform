class AddLastRemindedAtToRecipients < ActiveRecord::Migration
  def self.up
    add_column :recipients, :last_reminded_at, :datetime
  end

  def self.down
    drop_column :recipients, :last_reminded_at
  end
end
