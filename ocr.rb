require 'tesseract'
require 'opencv'
require 'thread'
require './window_manager'

class Ocr

  include OpenCV
  include WindowManagerHelper
   
  attr_accessor :image, :raw_text, :text

  def initialize(tempfile_name="frame.tif")
    @show_window = true
    @tempfile_name = tempfile_name
    @tempfile = Tesseract::FileHandler.create_temp_file("#{@tempfile_name}_#{Time.now.to_i}")
    @raw_text = ""
    @text = ""
    
    @show_window = true
    @window_name = "ocr"
    @windows = WindowManager.new
  end

  # Perform OCR on the image
  def process!(image)
    
    @windows.create(@window_name, [0,320], @show_window)
    
    img = image.BGR2GRAY
   # img = img.threshold(150, 230, CV_THRESH_BINARY)
   img = img.threshold(150, 70, CV_THRESH_BINARY)
    
    window.show(img)
    img.save_image(@tempfile.to_s)
    
    tesseract = Tesseract::Process.new(@tempfile)
    @raw_text = tesseract.process!
  end
  
  # Try to clean up the text 
  def text
    @text = @raw_text.downcase.gsub(/[\W_]+/i," ").split(" ")
    @text.select{|t| t.size > 3}.uniq
  end
  
  # Remove old temp files
  def cleanup!
    Tesseract::FileHandler.cleanup!
  end

end