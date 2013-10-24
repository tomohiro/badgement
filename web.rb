# enoding: utf-8

require 'sinatra'

# [Redis To Go | Heroku Dev Center](https://devcenter.heroku.com/articles/redistogo)
configure do
  require 'redis'
  uri = URI.parse(ENV['REDISTOGO_URL'])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get '/' do; end

get '/name/:label' do |label|
  begin
    status = REDIS.get(label)
    raise NameError unless status
    redirect "http://img.shields.io/#{label}/#{status}.png"
  rescue NameError
    redirect "http://img.shields.io/label/error.png?color=red"
  end
end

post '/name/:label' do |label|
  REDIS.set(label, params[:status])
end
