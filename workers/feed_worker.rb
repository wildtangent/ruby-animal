require './keyword_strategy'
require './persistance'
require 'sidekiq'

class FeedWorker
  
  include Sidekiq::Worker
  
  def perform(text, feed_aggregator)
    puts "Working feed"
    puts text.join(", ")
    keywords = KeywordStrategy.most_frequent(text)
    if keywords.length >= 2
      feed_aggregator.show(keywords)
      reset_keywords!
    end
  end
  
end