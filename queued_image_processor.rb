class QueuedImageProcessor
  require 'tesseract'

  require './feed_aggregator'
  require './workers/ocr_worker'
  require './workers/feed_worker'
  
  attr_accessor :text
  
  def initialize(options={})
    @process_frequency = options[:process_frequency] || 16
    @query_frequency = options[:query_frequency] || 32
    @feed_aggregator = FeedAggregator.new
    @store = Persistance::Memcache.new
  end
  
  def process(image, tick)
   # raise image.inspect
    @tempfile_name = "frame1.tif"
    @tempfile = Tesseract::FileHandler.create_temp_file("#{@tempfile_name}_#{Time.now.to_i}")
    
    image.save_image(@tempfile.to_s)
    
    OcrWorker.perform_async(@tempfile.to_s, tick) if process_now?(tick)
    FeedWorker.perform_async(@store.get("text"), @feed_aggregator) if get_articles?(tick)
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