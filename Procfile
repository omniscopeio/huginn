web: bundle exec unicorn -p $PORT -c config/unicorn.rb
scheduler_plus_worker: bundle exec rails runner bin/threaded.rb
worker: bundle exec rake jobs:work
# twitter: bundle exec rails runner bin/twitter_stream.rb
