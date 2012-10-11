class OcrWorker
  
  require './ocr'
  require 'sidekiq'
  
  include Sidekiq::Worker
  
  def perform(image, tick)
    puts "Working OCR"
    puts tick.inspect
    @ocr = Ocr.new
    @ocr.process!(image)
    @ocr.cleanup!
  end
    
end