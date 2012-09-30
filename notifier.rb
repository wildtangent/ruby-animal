require 'pusher'

class Notifier
  
  class PusherNotifier
    
    require './logger'
    include Logger
  
    @@app_id = "28685"
    @@key = "ea07c05121b1307db556"
    @@secret = "c57d3b52e5bad0c67bb4"
  
    def initialize(title, url, channel="default")
      @title = title
      @url = url
      @channel = channel
      Pusher.app_id = @@app_id
      Pusher.key = @@key
      Pusher.secret = @@secret
    end
  
    def notify!
      Pusher[@channel].trigger("alert", {:title => @title, :url => @url})
      log "Notification sent!  "
    rescue Pusher::Error => e
      #Boom
      log "Error sending notification: #{e}"
    end
  
  end

end