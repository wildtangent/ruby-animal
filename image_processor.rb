class ImageProcessor

  require './ocr'
  require './keyword_strategy'
  require './feed_aggregator'

  
  attr_accessor :text
  
  def initialize(options={})
    @ocr = Ocr.new
    @text = []
    @process_frequency = options[:process_frequency] || 16
    @query_frequency = options[:query_frequency] || 32
    @feed_aggregator = FeedAggregator.new
    #@strategy = :most_frequent
    @strategy = :breaking_news
  end
  
  def process(image, tick)
    if process_now?(tick)
      @ocr.process!(image)
      t = @ocr.text
      @text << t if t.any?
      # Other stuff... (should be able to yield a block here?)
    end
    
    if get_articles?(tick)
      puts @text.join(", ")
      case @strategy
      when :most_frequent
        keywords = KeywordStrategy.most_frequent(@text)
        if keywords.length >= 2
          @feed_aggregator.show(keywords)
          reset_keywords!
        end
      when :breaking_news
        #keywords = KeywordStrategy.breaking_news(@text)
        keywords = KeywordStrategy.any(@text)
        if keywords == true
          notifier = Notifier::PusherNotifier.new({
            title: "Breaking News", 
            message: "I think something good is going on: #{@text}",
            url: "http://dev.livestation.com/en/aljazeera-english",
            timeout: 10000
          }, "breaking_news")
          notifier.notify!
        end
        @ocr.clear!
        @text = []
      end
    end
    @ocr.cleanup!
  end
  
  # If the feed didn't return any results, throw away the keywords and let it start again
  def reset_keywords!
    @text = [] if @feed_aggregator.feed.items.empty?
  end
  
  # Interval constraint
  def process_now?(tick)
    tick % @process_frequency == 0  
  end
  
  # Frequency to attempt to get articles
  def get_articles?(tick)
    tick % @query_frequency == 0
  end
  
  
end