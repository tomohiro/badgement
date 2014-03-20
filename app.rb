require 'sinatra'

configure do
  # [Redis To Go | Heroku Dev Center](https://devcenter.heroku.com/articles/redistogo)
  require 'redis'
  uri = URI.parse(ENV['REDISTOGO_URL'])
  REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
end

get '/:repository/:branch/:label' do |repository, branch, label|
  key = "#{repository}:#{branch}:#{label}"
  status = REDIS.hget(key, 'status')
  color  = REDIS.hget(key, 'color')

  if status && color
    redirect "http://img.shields.io/#{label}/#{status}.png?color=#{color}"
  else
    redirect "http://img.shields.io/#{label}/undefined.png?color=red"
  end
end

post '/:repository/:branch/:label' do |repository, branch, label|
  key = "#{repository}:#{branch}:#{label}"
  REDIS.hset(key, 'status', params[:status])
  REDIS.hset(key, 'color', params[:color])

  "It was saved #{branch} on #{repository}."
end
