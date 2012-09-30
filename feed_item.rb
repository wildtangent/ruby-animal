class FeedItem
  
  attr_accessor :title, :link, :description
  
  def initialize(title, link, description)
    @title = title
    @link = link
    @description = description
    #@thumbnail = thumbnail
  end
  
end