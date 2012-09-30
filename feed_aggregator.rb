class FeedAggregator
  
  @@feed_source = :yahoo
  
  require './logger'
  include Logger
  
  attr_accessor :feed, :url, :options, :visited_links
  
  def initialize(url=nil, options={})
    case @@feed_source 
    when :google
      set_google_feed!(url, options)
    when :yahoo
      set_yahoo_feed!(url, options)
    end
    @visited_links = []
    
    @feed = Feed.new(@url, @options)
  end
  
  def set_google_feed!(url, options)
    @url = url || "https://news.google.com/news/feeds"
    @options = {
      hl: "en",
      gl: "uk",
      um: 1,
      ie: "UTF-8",
      output: "rss"
    }
    @param_key = :q
  end
  
  def set_yahoo_feed!(url, options)
    @url = url || "http://news.search.yahoo.com/rss"
    @options = {
      fr: "news-us-ss",
      ei: "UTF-8"
    }
    @param_key = :p
  end
  
  #
  def show(keywords)
    @feed.params[@param_key] = keywords[0..2].join(" ")
    log "Searching for keywords: #{@feed.params[@param_key]}"
    @feed.read
    @items = @feed.items
    if @items.any?
      item = @items.first
      unless @visited_links.include?(item.link)
        #Launchy.open(link)
        @notifier = Notifier::PusherNotifier.new(item.title, item.link)
        @notifier.notify!
        @visited_links << item.link
      end
      @items.each do |item|
        log item.title
        log item.link
      end
    else
      log "No articles matching from aggregators"
    end
  end
  
  def self.feed_source=(source)
    @@feed_source = source
  end
  
  # # Might override this in subclass this for behaviours for different feeds
  # def query=(value)
  #   puts @param_key
  #   puts value
  #   @feed.params[@param_key] = value
  # end
  # 
  # def query
  #   @feed.params[@param_key]
  # end
  
end