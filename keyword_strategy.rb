class KeywordStrategy
  
  require './logger'
  include Readme::Logger
  
  @@sample_frequency = 5
  @@word_frequency = 2
  
  # Group the words by frequncy, then sort and return only those with more than the minimum frequency
  def self.most_frequent(keywords)
    return [] if keywords.length <= @@sample_frequency
    word_groups(keywords).sort{|a,b| 
      b[1].size <=> a[1].size
    }.collect{|k,v| 
      k if v.size > @@word_frequency
    }.compact
  end
  
  # Group words
  def self.word_groups(keywords)
    keywords.flatten.compact.group_by{|word| word }
  end
  
  def self.breaking_news(keywords)
    keywords.flatten.compact.include?("obama")
  end
  
  def self.any(keywords)
    !keywords.blank?
  end
  
  # def intersection
  #   @intersection = []
  #   if @text.length > @sample_frequency
  #     log "Got samples:\n#{@text.dup.join(',')}"
  #     @intersection = @text.reduce(&:&)
  #     if @intersection.length >= @word_frequency
  #       log "Got enough matches"
  #     else
  #       log "Not enough matches #{@intersection.length}"
  #     end
  #   end
  #   log @intersection
  #   @intersection
  # end  
  
end