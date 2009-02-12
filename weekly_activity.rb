#!/usr/bin/env ruby
#
# This script and the basecamp.rb wrapper requires the xml-simple gem. Install by running:
# => gem install xml-simple
#

require 'basecamp'
require 'activesupport'
require 'yaml'

account_config = File.open('account.yml') { |yf| YAML::load(yf) }

Basecamp.establish_connection!(account_config['url'], account_config['username'], account_config['password'])

date_format = '%A %e %h'
day_this_week = (Date.today).strftime(date_format)
day_next_week = (Date.today + 7).strftime(date_format)

today = Date.today

m = Basecamp::Message.new({:project_id => 1687139})

m.category_id = 29137783
m.title = "Post your activities for this week: #{day_this_week} to #{day_next_week}"
m.body = <<END
Please post a comment with a brief bullet pointed list of what you're working on this week in preperation of the next meeting on #{day_next_week}.

It should be in the format of:

<pre>
END

0.upto(7) do |day|
  day_name = (today + day).strftime '%A'
  m.body += "h1. #{day_name}\n\n"
  m.body += "* items..\n\n"
end

m.body += "\n</pre>"

m.notify = account_config['weekly_activity']['notify']
