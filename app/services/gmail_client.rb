class GmailClient

  def get_body(mail)
    if mail['error'].nil?
      Base64.urlsafe_decode64(mail["payload"]["body"]["data"])
    end
  end

  def initialize(user)
    @client = Google::APIClient.new
    if user.token && user.refresh_token
      @client.authorization.access_token = user.token
      @client.authorization.refresh_token = user.refresh_token
      @client.authorization.client_id = ENV['GOOGLE_APP_ID']
      @client.authorization.client_secret = ENV['GOOGLE_APP_SECRET']
      @client.authorization.refresh!
      @service = @client.discovered_api('gmail')
    else
      raise "User does not have a token !"
    end
  end

  def list_mails()
    result = @client.execute(
      :api_method => @service.users.messages.list,
      :parameters => {'userId' => 'me' },
      :headers => {'Content-Type' => 'application/json'})

    JSON.parse(result.body)
  end

  def get_mail(id)
    result = @client.execute(
      :api_method => @service.users.messages.get,
      :parameters => { 'userId' => 'me', 'id' => id },
      :headers => {'Content-Type' => 'application/json'})

    JSON.parse(result.body)
  end
end
