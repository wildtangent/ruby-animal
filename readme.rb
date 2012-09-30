#!/usr/bin/env ruby
require "rubygems"
require './movie_player'
FeedAggregator.feed_source = :yahoo

mp = MoviePlayer.new("http://media4.lsops.net/live/aljazeer2_en_ultrahigh.sdp/playlist.m3u8")
#mp = MoviePlayer.new("http://media11.lsops.net/live/bbcnews_en_high.sdp/playlist.m3u8")
mp.run


# notifier = Notifier::PusherNotifier.new("Party Conference...", "http://www.bbc.co.uk/news/uk-politics-19646455")
# notifier.notify!