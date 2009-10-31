project = ask "Project name? "
if ARGV.size < 2
  dir = ask "Directory? "
else
  dir = ARGV[-1]
end
default_domain = "#{project}.andymo.org"
domain = ask "Domain? [#{default_domain}] "
domain = domain.empty? ? default_domain : domain

run "mkdir #{dir}"
run "mkdir #{dir}/views"
run "mkdir #{dir}/models"
run "mkdir #{dir}/tmp"
run "mkdir #{dir}/public"

file "#{dir}/config.ru" do
  %{
require '#{project}'

set :run, false
set :environment, :production
set :views, "views"

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)

run Sinatra::Application
  }
end

file "#{dir}/#{project}.rb" do
 %{
require 'rubygems'
require 'sinatra'

get '/'
  'Hello, world'
end
 }.strip
end


file "#{dir}/#{project}.vhost.conf" do
 %{
server{
  listen 80;
  server_name #{domain} *.#{domain}
  root /var/www/#{dir}/public
  passenger_enabled on;
}
 }.strip
end
