#Getting the Code

The Ruby OCR sample is available for experimentation and development at:
git@livestation.beanstalkapp.com:/ruby-animal.git

#Dependencies
You will need a working copy of Tesseract 3.0.x and OpenCV installed with header files etc in your path
 
#Running the Code
The basic app can be run by executing:
```ruby
bundle install
bundle exec ruby ./readme.rb
```

In this file you can set the stream URL you want to capture and process

The EXPERIMENTAL FEATURE Sidekiq workers can be initialized by running:
```ruby
bundle exec sidekiq -r ./workers/feed_worker.rb ./workers/ocr_worker.rb
```
To use the queued image processor (required for Sidekiq version) you can pass in a different ImageProcessor class as an option e.g.
```ruby
mp = MoviePlayer.new(movie_url, image_processor: QueuedImageProcessor.new)
```

# Demonising the process
To daemonise the script, start using 

```
./bin/readme -d -P tmp/readme.pid
```

To terminate the 

##Source Code Description

The source code is broken down into a number of discreet functions as follows

###readme.rb
Used to execute the main application. Run using `ruby ./readme.rb`

###movie_player.rb
Movie player connects to a given video stream using OpenCV  
It displays a frame using OpenCV GUI Window library, via a helper class called `WindowManager`  
It captures a frame every n ticks and passes the frame data to an `ImageProcessor` class via the method "process"  
It aborts the running application if any key is pressed while the GUI window has focus.
  
###image_processor.rb
The Image processor class takes the frame passed in and a tick value, and passes the frame to any additional processing which is required to be done.  
In this implementation, the image is passed to the `Ocr` class which performs OCR on the frame and provides an interface to receive the processed text.

###ocr.rb
The OCR class takes a String reference to a file or an `OpenCV::IplImage` object.  
It performs some image processing to remove colour and add a threshold filter to improve character recognition (this could definitely be improved).  
It saves the processed image to a temporary file and then runs Tesseract command line via the "tesseract" gem passing the filename.  
> This could be improved by using a different Tesseract gem which doesn't invoke the command line, so it is not necessary to save the file to disk first.  

It appends the text to a "store" object which is currently a Memcache store (this allows it to be persisted between instances, for example if we want to use a message queue to process the strings. Not sure if this is really a good idea or not, it was just an experiment.  
It stores the raw text and "cleaned" up  text to an instance variable and return the clean text to the caller.

###keyword_strategy.rb
The `KeywordStrategy` class allows different processing to be applied to the array of text generated by the OCR class.  
Depending on the type of strategy it returns either a boolean response (e.g. any, breaking_news), or it returns an array of words (e.g. most_frequent).  
The strategy class should probably be turned into a factory class with subclasses defining the different behaviours to create a common interface.

###feed_aggregator.rb
** WARNING ** Using this script too much will get your IP banned from Google/Yahoo news feeds. Use with caution.  
This takes a `Feed` object source and queries it using the text provided (e.g. by the OCR result). It can read from Google or Yahoo news feeds.  
It returns an array of `FeedItem` objects which are results from the feed lookup.  
The #show method performs several functions, which could be decoupled.
It reads the feed and then converts the results into `FeedItem` objects.  
It then reads the first link and if it has not already been discovered, sends a push notification using Notifier::PusherNotifier class, and then appends the link to the list of previously visited links.  
The push notification takes the title and link from the feed item, but could also accept other properties.  
This push notification is used in conjunction with the "feedme_server" sample project at git@livestation.beanstalkapp.com:/feedme_server.gi

###notifier.rb
The notifier and its subclass PusherNotifier can be used to send push notifications to service endpoints.  
The PusherNotifier class can send messages to connected Websockets clients using the Pusher gem.  
It accepts a payload object (hash which can be turned into JSON), and a channel and alert topic.  
It sets the `app_id, secret` and `key` in the class variables. These will need to be modified if using different credentials.  
See the [Pusher documentation](http://www.pusher.com/docs) for more information.  

###logger.rb
Just a simple logger module to send debug lines to.

####window_manager.rb **EXPERIMENTAL**
This is an attempt to decouple to window viewing from the main application.  
The classes which implement it include the `WindowManagerHelper` module which extends the class to include a create_window! and window method.  
It still needs work to make it more helpful.  
The idea was to create a class which handled all the windows in the app so it could be aware of them and make decisions about positioning, window names, whether to show the window at all (e.g. if in a non GUI environment) etc.  
At the moment it just handles creation of the window and returning the window object by its name.  

####queued_image_processor.rb **EXPERIMENTAL**
The queued image processor is an attempt to move processing of the images out of the main application and into a worker queue, thus speeding up frame viewing and processing.  
It uses Sidekiq gem as the Redis worker. There are currently two workers, and a the `QueuedImageProcessor` class which uses them.  
Working with workers changes the design a fair amount, adding a persistence layer to store the results and changing the passing around of the image from binary data to filename pointer.  
To work with the QueuedImageProcessor, change the class assignment of the @image_processor instance variable in MoviePlayer to QueuedImageProcessor.  
NB: This can now be done by passing.  `{image_processor: QueuedImageProcessor.new}` into the initialization options for the MoviePlayer class.  
Any class passed in here should have the same interface as the ImageProcessor class does.

####persistance.rb **EXPERIMENTAL**
The `Persistance::Memcache` store is working, the `Redis` store is not tested yet.  
It will use the Dalli gem to connect to Memcache and store or retrieve a key/value pair.  
No account is taken for differences in environment e.g. different connections to Memcache.  
The store object is used in the QueuedImageProcessor and Ocr classes to store and retrieve the current array of text values.  

####workers/feed_worker.rb **EXPERIMENTAL**
The `FeedWorker` class uses Sidekiq to perform the KeywordStrategy and Feed Aggregator work.  
It is highly experimental and may not even work yet!

####workers/ocr_worker.rb **EXPERIMENTAL**
The `OcrWorker` class uses Sidekiq to perform the Ocr processing work.  
It is highly experimental and may not fully even work yet!