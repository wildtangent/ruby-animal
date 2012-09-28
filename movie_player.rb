require "opencv"
require './ocr'

class MoviePlayer

  include OpenCV
  
  def initialize(movie_url, options={})
    @show_video = true
    @show_processing = true
    @movie_url = movie_url
    @frequency = 16
    @tesseract_command = ""
    @ocr = Ocr.new
  end

  # Run capture
  def run
    @capture = CvCapture.open(@movie_url)
    tick = 0
    loop do
      image = @capture.query
      Thread.new do 
        window.show(image) if @show_video
      end
      if process_now?(tick)
        Thread.new do
          @ocr.process!(image)
          log(@ocr.text)
        end
        # Other stuff... (should be able to yield a block here?)
      end
      tick += 1
      break if GUI::wait_key(100)
    end
    @ocr.cleanup!
  end

  # Interval constraint
  def process_now?(tick)
    tick % @frequency == 0  
  end
  
  # Preset GUI window
  def window
    @window ||= GUI::Window.new("movie") if @show_video
  end
  
  def log(message)
    puts message << "\n"
  end

end