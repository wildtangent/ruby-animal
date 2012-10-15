#!/usr/bin/env ruby
require "rubygems"
require './movie_player'

# Set RSS feed source to :yahoo or :google
FeedAggregator.feed_source = :yahoo

# HQ video stream
movie_url = "http://media4.lsops.net/live/aljazeer2_en_ultrahigh.sdp/playlist.m3u8"

# No options
options = {}

# Different streaming formats
# movie_url = "http://media11.lsops.net/live/bbcnews_en_high.sdp/playlist.m3u8"
# movie_url = "rtsp://media7.lsops.net:80/live/aljazeer_en_high.sdp"
# movie_url = "rtmp://media8.lsops.net/live/aljazeer_en_high.sdp"

# Options with different ImageProcessor class
# options = {image_processor: QueuedImageProcessor.new}

# Initialize with movie url and options as defined
mp = MoviePlayer.new(movie_url, options)

# Run the movie player
mp.run