require 'tesseract'
require 'opencv'
require 'thread'
require './window_manager'
require './persistance'

class Ocr

  include OpenCV
  include WindowManagerHelper
   
  attr_accessor :image, :raw_text, :text, :store

  def initialize(tempfile_name="frame.tif")
    @show_window = true
    @tempfile_name = tempfile_name
    @tempfile = Tesseract::FileHandler.create_temp_file("#{@tempfile_name}_#{Time.now.to_i}")
    @raw_text = ""
    @text = ""

    @store = Persistance::Memcache.new
    
    @show_window = true
    @window_name = "ocr"
    @windows = WindowManager.new
    #@windows.create(@window_name, [0,320], @show_window)
  end

  # Perform OCR on the image
  def process!(image)
    case image
    when String
      image = OpenCV::IplImage.load(image)
    end
   
    img = image.BGR2GRAY
    # img = img.threshold(150, 230, CV_THRESH_BINARY)
    img = img.threshold(150, 70, CV_THRESH_BINARY)
    
    Thread.new { window.show(img) } 
    img.save_image(@tempfile.to_s)
    
    tesseract = Tesseract::Process.new(@tempfile)
    @raw_text = tesseract.process!
    
    @store.set("raw_text", @raw_text)
    currtext = @store.get("text") || []
    t = currtext << self.text
    
    @store.set("text", t)
    
    return t
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
  
  def clear!
    @store.set("raw_text", nil)
    @store.set("text", nil)
    @text = ""
  end

end