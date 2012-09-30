class LinkAggregator
  
  require './logger'
  include Logger
  
  attr_accessor :feed, :url, :options, :visited_links
  
  def initialize(url=nil, options={})
    @url = url || "https://news.google.com/news/feeds?"
    @options = {
      hl: "en",
      gl: "uk",
      um: 1,
      ie: "UTF-8",
      output: "rss"
    }
    @visited_links = []
    
    @feed = Feed.new(@url, @options)
  end
  
  #
  def show(keywords)
    @feed.params[:q] = keywords.join(" ")
    log @feed.params[:q]
    @feed.read
    @items = @feed.items
    if @items.any?
      link = @items.first.link
      unless @visited_links.include?(link)
        Launchy.open(link)
        @visited_links << link
      end
      @items.each do |item|
        log item.title
        log item.link
      end
    else
      log "No articles matching on Google News"
      @text = []
    end
  end
  
end