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
    @image_processor = @options[:image_processor] || ImageProcessor.new
    
    @save_frames = false # Set to true if you want to capture some frames from the video feed e.g. for character recognition training
    
    @show_window = true # Set to false if you don't want to create a GUI window (experiementatl)
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
        
      # In case you want to capture some frames from the video feed
      if @save_frames && tick % 25 == 0 
        image.save_image("capture/frame_#{tick}.tif")
      end
      
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