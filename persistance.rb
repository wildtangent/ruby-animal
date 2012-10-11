module Persistance
  
  class Memcache
  
    require 'dalli'
  
    attr_accessor :client
    
    def initialize
      @client = Dalli::Client.new("localhost:11211")
    end

    def set(key, value)
      @client.set(key, value)
    end
  
    def get(key)
      @client.get(key)
    end
  
  end
  
  class Redis
    
    require 'redis'
    
    attr_accessor :client
    
    def initialize
      @client = Redis.new
    end
    
    def set(key,value)
      @client.set(key, value)
    end
    
    def get(key)
      @client.get(key)
    end
    
  end

end