web: bundle exec unicorn -p $PORT -c config/unicorn.rb
scheduler: bundle exec rails runner bin/schedule.rb
worker: bundle exec rake jobs:work
# twitter: bundle exec rails runner bin/twitter_stream.rb
