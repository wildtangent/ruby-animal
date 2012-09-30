require 'launchy'

require './ocr'
require './feed'
require './keyword_strategy'
require './feed_aggregator'
require './window_manager'
require './notifier'

class MoviePlayer

  require "opencv"
  include OpenCV
  include WindowManagerHelper
  
  attr_accessor :movie_url, :options
  
  def initialize(movie_url, options={})
    @movie_url = movie_url
    @options = options
    @process_frequency = options[:process_frequency] || 16
    @query_frequency = options[:query_frequency] || 32

    @ocr = Ocr.new
    @text = []
    
    @feed_aggregator = FeedAggregator.new

    @show_window = true
    @window_name = "movie"
    @windows = WindowManager.new

  end

  # Run capture
  def run
    create_window!
    capture!  
    
    tick = 0
    loop do
      
      image = @capture.query
      
      window.show(image)
      
      if process_now?(tick)
        @ocr.process!(image)
        t = @ocr.text
        @text << t if t.any?
        # Other stuff... (should be able to yield a block here?)
      end
      
      if get_articles?(tick)
        puts @text.join(", ")
        keywords = KeywordStrategy.most_frequent(@text)
        if keywords.length >= 2
          @feed_aggregator.show(keywords)
          reset_keywords!
        end
      end
      
      tick += 1
      break if GUI::wait_key(100)
    end
    @ocr.cleanup!
  end
  
  # Start capture of movie
  def capture!
    @capture = CvCapture.open(@movie_url)
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