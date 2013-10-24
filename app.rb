require 'sinatra'

configure do
  # [Redis To Go | Heroku Dev Center](https://devcenter.heroku.com/articles/redistogo)
  require 'redis'
  uri = URI.parse(ENV['REDISTOGO_URL'])
  REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
end

get '/*' do |label|
  status = REDIS.hget(label, 'status')
  color  = REDIS.hget(label, 'color')

  if status
    redirect "http://img.shields.io/#{label}/#{status}.png?color=#{color}"
  else
    redirect "http://img.shields.io/#{label}/undefined.png?color=red"
  end
end

post '/:label' do |label|
  REDIS.hset(label, 'status', params[:status])
  REDIS.hset(label, 'color', params[:color])

  "It was saved #{label} status is #{status} and color is #{color}."
end
