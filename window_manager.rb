class WindowManager
  
  require 'opencv'
  require 'active_support/core_ext/hash'
  include OpenCV
  
  def initialize
    @windows = {}.with_indifferent_access
  end
  
  # Create a new window with the co-ordinates, or return the existing one 
  def create(name, position=[0,0], active=true)
    return @windows[name.to_sym] if @windows[name.to_sym]
    window = GUI::Window.new(name)
    window.move(position[0],position[1])
    @windows[name.to_sym] = window
  end
  
  def [](name)
    @windows[name]
  end
  
end

module WindowManagerHelper
  
  # Create display window
  def create_window!
    @windows.create(@window_name, [0,0], @show_window)
  end
  
  # Access the window
  def window
    @windows[@window_name]
  end
  
end