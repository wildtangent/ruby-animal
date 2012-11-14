class ImageProcessor

  require './ocr'
  require './keyword_strategy'
  require './feed_aggregator'
  require './logger'
  
  include Readme::Logger
  
  
  attr_accessor :text
  
  def initialize(options={})
    @ocr = Ocr.new
    @text = []
    @process_frequency = options[:process_frequency] || 16
    @query_frequency = options[:query_frequency] || 32
    @url = options[:url]
    @feed_aggregator = FeedAggregator.new(nil, options)
    @strategy = options[:strategy].to_sym || :any
  end
  
  def process(image, tick)
    if process_now?(tick)
      @ocr.process!(image)
      t = @ocr.text
      @text << t if t.any?
      # Other stuff... (should be able to yield a block here?)
    end
    
    if get_articles?(tick)
      case @strategy
      when :most_frequent
        keywords = KeywordStrategy.most_frequent(@text)
        if keywords.length >= 2
          @feed_aggregator.show(keywords)
          notify_email(text, image)
          reset_keywords!
        end
      when :any
       
        keywords = KeywordStrategy.any(@text)
        if keywords == true
          notifier = Notifier::PusherNotifier.new({
            message: "Breaking news alert",
            url: @url,
            timeout: 10000
          }, "breaking_news")
          notifier.notify!
          
          notify_email!(text, image)
          reset_keywords!
        end
      when :breaking_news
        keywords = KeywordStrategy.breaking_news(@text)
        if keywords == true
          notifier = Notifier::PusherNotifier.new({
            message: "Breaking news alert",
            url: @url,
            timeout: 10000
          }, "breaking_news")
          notify_email(text, image)
          notifier.notify!
          reset_keywords!
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
  
  def notify_email!(text, image)
    Thread.new do
      frame = "foundframe_#{Time.now.to_i}.jpg"
      image.save_image(frame)
      email = Notifier::EmailNotifier.new({
        image: File.read(frame),
        message: "OCR found the terms #{text} in the attached image"
      })
    
      email.notify!
      File.delete(frame)
    end
  end
   
end
