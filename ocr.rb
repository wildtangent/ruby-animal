require 'tesseract'
require 'opencv'
require 'thread'

class Ocr

  include OpenCV
  
  attr_accessor :image, :raw_text, :text

  def initialize(tempfile_name="frame.tif")
    @show_window = true
    @tempfile_name = tempfile_name
    @tempfile = Tesseract::FileHandler.create_temp_file("#{@tempfile_name}_#{Time.now.to_i}")
    @raw_text = ""
    @text = ""
  end

  # Perform OCR on the image
  def process!(image)
    img = image.BGR2GRAY
    img = img.threshold(150, 70, 0)
    #img = img.threshold(160,255,CV_THRESH_BINARY)
    Thread.new do
      window.show(img) if @show_window
    end
    img.save_image(@tempfile.to_s)
    tesseract = Tesseract::Process.new(@tempfile)
    @raw_text = tesseract.process!
  end
  
  # Try to clean up the text 
  def text
    @text = @raw_text.downcase.gsub(/\W+/i," ").split(" ")
    @text.select{|t| t.size > 3}
  end
  
  # Render the image to the window
  def window
    @window ||= GUI::Window.new("ocr") if @show_window
  end
  
  # Remove old temp files
  def cleanup!
    Tesseract::FileHandler.cleanup!
  end

end