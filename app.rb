require 'sinatra'

configure do
  # [Redis To Go | Heroku Dev Center](https://devcenter.heroku.com/articles/redistogo)
  require 'redis'
  uri = URI.parse(ENV['REDISTOGO_URL'])
  REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
end

get '/:repository/:branch' do |repository, branch|
  branch = REDIS.hget(repository, 'branch')
  label  = REDIS.hget(repository, 'label')
  status = REDIS.hget(repository, 'status')
  color  = REDIS.hget(repository, 'color')

  if branch && label && status
    redirect "http://img.shields.io/#{label}/#{status}.png?color=#{color}"
  else
    redirect "http://img.shields.io/#{label}/undefined.png?color=red"
  end
end

post '/:repository/:branch' do |repository, branch|
  REDIS.hset(repository, 'branch', branch)
  REDIS.hset(repository, 'label', params[:label])
  REDIS.hset(repository, 'status', params[:status])
  REDIS.hset(repository, 'color', params[:color])

  "It was saved #{branch} on #{repository}."
end
