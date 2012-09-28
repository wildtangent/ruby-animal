#!/usr/bin/env ruby
require "rubygems"
require './movie_player'
mp = MoviePlayer.new("http://media4.lsops.net/live/aljazeer2_en_ultrahigh.sdp/playlist.m3u8")
mp.run