require 'nokogiri'
require 'open-uri'
require 'active_support/core_ext/object'
require './feed_item'
require './logger'

class Feed
  
  include Logger

  attr_accessor :url, :params, :items
  
  def initialize(url, params={})
    @url = url
    @params = params
    @items = []
  end
  
  def read
    log("Getting feed: #{uri}")
    @rss = Nokogiri::XML(open(uri))
    @rss.remove_namespaces!
    @items = @rss.xpath('//item').map do |i|
      FeedItem.new(i.xpath('title').text, i.xpath('link').text, i.xpath('description').text)
    end
  rescue Exception => e
    log("Couldn't retrieve feed: #{e}")
  end
  
  def uri
    [@url, @params.to_query].join("?")
  end
  
  def items
    @items
  end
  
  
end