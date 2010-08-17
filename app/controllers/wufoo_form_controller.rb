require 'json'
require 'net/http'

class WufooFormController < ApplicationController

  def index
  end

  def create
    if request.post?
      recipient_emails = params[:wufoo_form].delete('recipient_emails') || []

      @wf = WufooForm.new(params[:wufoo_form])

       begin
        json = get_json_for(@wf, 'fields')
       rescue  => e
         return render :action => 'failure'
       end

      token_fields = json.select {|field| field['Title'].downcase == 'notiform token'}

      @wf.token_field_id = token_fields.first['ID']
      @wf.save!

      recipient_emails.split(',').each do |email|
        Recipient.create(:wufoo_form_id => @wf.id, :email => email.strip)
      end

      respond_to do |format|
        format.json { render :json => {
            :html => render_to_string(:partial => 'view_form_iframe') },
            :status => :ok }
      end
    end

    # else, return the empty form
  end

  def view
    token = params[:token] || params[:id]

    if @wf = WufooForm.find_by_id(params[:id])

    elsif @recipient = Recipient.find_by_token(token)
      @wf = @recipient.wufoo_form
    else
      render :action => 'failure'
    end
  end

  def report
    unless @wf = WufooForm.find_by_id(params[:id])
      render :action => 'failure'
    end

    @recipients = @wf.recipients

    # set 'confirmed' for each recipient for whom we've recieved an entry
    recipient_map = @recipients.index_by(&:token)
    json = get_json_for(@wf, 'entries')

    json.each do |entry|
			if received = recipient_map[entry[@wf.token_field_id]]
				received.confirmed = true
			end
    end
  end

  def failure
  end

 private

	def get_json_for(wufoo_form, api_string)
    http = Net::HTTP.new("#{wufoo_form.subdomain}.wufoo.com", 443)
    http.use_ssl = true
    http.start() {|http|
          req = Net::HTTP::Get.new("/api/v3/forms/#{wufoo_form.form_name}/#{api_string}.json?system=true")
          req.basic_auth wufoo_form.api_key, 'password'
          response = http.request(req)
          json = JSON.parse(response.body)
          return json[api_string.camelcase]
        }
	end

end
