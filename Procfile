aljazeera_english: bundle exec bin/readme -P tmp/readme.pid --movie_url=http://media4.lsops.net/live/aljazeer2_en_ultrahigh.sdp/playlist.m3u8 -i ImageProcessor
cnni: bundle exec bin/readme -P tmp/readme.pid --movie_url=http://media4.lsops.net/live/cnn_en.smil/chunklist-b320000.m3u8 -i ImageProcessor
bbc_world: bundle exec bin/readme -P tmp/readme.pid --movie_url=http://media7.lsops.net/live/bbcworld1_en_ultrahigh.sdp/playlist.m3u8 -i ImageProcessor


web: start nginx
resque: bundle exec rake resque:work RAILS_ENV=production


