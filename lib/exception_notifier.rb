require 'rest-client'

class ExceptionNotifier
  def initialize(exception)
    @exception = exception
    @api_key = ENV.fetch('MAILGUN_API_KEY')
    @domain_name = ENV.fetch('MAILGUN_DOMAIN_NAME')
    @receiever_email = ENV.fetch('EXCEPTION_NOTIFIER_RECEIVER')
  end

  def notify
    RestClient.post(
      "https://api:#{@api_key}@api.mailgun.net/v3/#{@domain_name}/messages",
      from: "Ololo Deleter Bot <mailgun@#{@domain_name}>",
      to: "#{@receiever_email}",
      subject: 'Exception occured',
      text: @exception.message
      # 'o:testmode' => 'true'
    )
  end
end
