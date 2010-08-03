require 'json'
require 'net/http'

class WufooFormController < ApplicationController

  def index
  end

  def create
    if request.post?
      recipient_emails = params[:wufoo_form].delete('recipient_emails') || []

      wf = WufooForm.create(params[:wufoo_form])
      recipient_emails.split(',').each do |email|
        Recipient.create(:wufoo_form_id => wf.id, :email => email.strip)
      end
      redirect_to :action => 'view', :id => wf.id
    end

    # else, return the empty form
  end

  def view
    if @wf = WufooForm.find_by_id(params[:id])

    elsif @recipient = Recipient.find_by_token(params[:id])
      @wf = @recipient.wufoo_form
    else
      render :action => 'failure'
    end
  end

  def report
    unless @wf = WufooForm.find_by_id(params[:id])
      render :action => 'failure'
    end

    http = Net::HTTP.new("#{@wf.subdomain}.wufoo.com", 443)
    http.use_ssl = true

    http.start() {|http|
          req = Net::HTTP::Get.new("/api/v3/forms/#{@wf.form_name}/entries.json?system=true")
          req.basic_auth @wf.api_key, 'password'
          @response = http.request(req)
          @json = JSON.parse(@response.body)
        }
  end

  def failure
  end

end
