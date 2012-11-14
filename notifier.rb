module Notifier
  
  class PusherNotifier
    
    require 'pusher'
    require './logger'
    include Readme::Logger
  
    @@app_id = "28685"
    @@key = "ea07c05121b1307db556"
    @@secret = "c57d3b52e5bad0c67bb4"
      
    # @@app_id = "29440"
    # @@key = "2818f347fa3480e0354a"
    # @@secret = "6b052573e629bf707a17"
  
    def initialize(payload, channel="default", event="alert")
      @payload = payload
      @channel = channel
      @event = event
      Pusher.app_id = @@app_id
      Pusher.key = @@key
      Pusher.secret = @@secret
    end
  
    def notify!
      Pusher[@channel].trigger(@event, @payload.to_hash)
      log "Notification sent!"
    rescue Pusher::Error => e
      #Boom
      log "Error sending notification: #{e}"
    end
  
  end
  
  class EmailNotifier 
    
    require 'pony'
    require './logger'
    include Readme::Logger
    
    def initialize(payload)
      @payload = payload
    end
    
    def notify!
      Pony.mail({
        :to => 'joe.connor@livestation.com',
        :from => "alerter@livestation.com",
        :subject => "Alert from OCR. We've found em",
        :via => :smtp,
        :via_options => {
          :user_name            => 'livestation',
          :password             => 'splitstream',
          :domain               => "mail.livestation.com",
          :address              => 'smtp.sendgrid.net',
          :port                 => '587',
          :authentication       => :plain,
          :enable_starttls_auto => true
        },
        :body => @payload[:message],
        :attachments => {"screenshot.jpg" => @payload[:image]}
      })
      log("sent mail!")
    end
    
  end

end
