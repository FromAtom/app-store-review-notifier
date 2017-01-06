require 'awesome_print'
require 'json'
require 'net/http'
require 'redis'

require './rss_parser.rb'
require './filter.rb'
require './slack.rb'
require './review_entry_model.rb'

REDIS_URL = ENV['REDISTOGO_URL'] || 'redis://127.0.0.1:6379'
END_POINT = ENV['APP_STORE_RSS']
SLACK_URL = ENV['SLACK_URL']
REDIS_KEY = ENV['REDIS_KEY'] || 'latestID'

unless REDIS_URL
  puts '[ERROR] `REDIS_URL` is required.'
  exit
end
unless END_POINT
  puts '[ERROR] `APP_STORE_RSS` is required.'
  exit
end
unless SLACK_URL
  puts 'Error: `SLACK_URL` is required.'
  exit
end

# RSSをパースしてモデルにする
rss = RSSParser.new(END_POINT)
reviewEntries = rss.modelize

# すでに通知したものは弾く
filter = Filter.new(REDIS_URL, REDIS_KEY)
filtered_entries = filter.filter(reviewEntries)

# slackに送る
slack = Slack.new(SLACK_URL)
slack.send(filtered_entries)
