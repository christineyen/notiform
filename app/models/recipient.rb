class Recipient < ActiveRecord::Base
  belongs_to :wufoo_form
  before_create :generate_token

 private
  def generate_token
    self.token = rand(36**8).to_s(36) if self.new_record? and self.token.nil?
  end
end
