require 'nokogiri'
require 'open-uri'
require 'active_support/core_ext/object'
require './feed_item'

class Feed
  
  attr_accessor :url, :params
  
  def initialize(url, params={})
    @url = url
    @params = params
    @items = []
  end
  
  def read
    @rss = Nokogiri::XML(open(url_and_params))
    @rss.remove_namespaces!
    @items = @rss.xpath('//item').map do |i|
      FeedItem.new(i.xpath('title').text, i.xpath('link').text, i.xpath('description').text)
    end
  end
  
  def url_and_params
    [@url, @params.to_query].join("")
  end
  
  def items
    @items
  end
  
  
end