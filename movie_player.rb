require 'launchy'

require './image_processor'
require './queued_image_processor'
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
    @image_processor = QueuedImageProcessor.new

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
      Thread.new { window.show(image) }
      @image_processor.process(image, tick)
      tick += 1
      break if GUI::wait_key(100)
    end
  end
  
  # Start capture of movie
  def capture!
    @capture = CvCapture.open(@movie_url)
  end

end