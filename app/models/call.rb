class Call < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  validates_presence_of :caller_number, :target_number
  after_create :connect_to_caller

  def self.default_url_options
    { :host => ENV['PUBLIC_HOST'], :port => ENV['PUBLIC_PORT'] || 80 }
  end

  def connect_to_caller
    Twilio::Call.make('5127891121', caller_number, connected_to_caller_call_url(self))
  end

  def connect_to_target
    puts "Connecting to target @ #{target_number} with #{Twilio.default_options.inspect}"
    Twilio::Call.make(
        '5127891121',
        target_number,
        connected_to_target_call_url(self),
        :StatusCallback => connection_to_target_failed_call_url(self),
        :Timeout => 10
    )
  end
end
