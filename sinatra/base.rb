project = ask "Project name?"
run 'mkdir views'
run 'mkdir models'
run 'mkdir tmp'
run 'mkdir public'
file "config.ru" do
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

file "#{project}.rb" do
 %{
require 'rubygems'
require 'sinatra'

get '/'
  'Hello, world'
end
 }.strip
end
