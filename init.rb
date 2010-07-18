$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require File.expand_path("../.bundle/environment", __FILE__)
require "integrity"

# Uncomment as appropriate for the notifier you want to use
# = Email
# require "integrity/notifier/email"
# = IRC
# require "integrity/notifier/irc"
# = Campfire
# require "integrity/notifier/campfire"
# = TCP
# require "integrity/notifier/tcp"
# = HTTP
# require "integrity/notifier/http"
# = Notifo
# require "integrity/notifier/notifo"
# = AMQP
# require "integrity/notifier/amqp"

Integrity.configure do |c|
  c.database     ENV["DATABASE_URL"]
  c.directory    "tmp"
  c.base_url     ENV["URL"]
  c.log          "tmp/integrity.log"
  c.github       ENV["GITHUB_TOKEN"] || "TOKEN"
  c.build_all!
  c.builder      :threaded, 5
end
