require 'pusher'

class Notifier
  
  class Pusher
  
  @@app_id = "28685"
  @@key = "ea07c05121b1307db556"
  @@secret = "c57d3b52e5bad0c67bb4"
  
  def initialize(url, channel="default")
    @url = url
    @channel = channel
    Pusher.app_id = @@app_id
    Pusher.key = @@key
    Pusher.secret = @@secret
  end
  
  def notify!
    Pusher[@channel].trigger("alert", {:url => @url})
  rescue Pusher::Error => e
    #Boom
  end
  
end

end