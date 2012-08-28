# enoding: utf-8

require 'sinatra'

# [Redis To Go | Heroku Dev Center](https://devcenter.heroku.com/articles/redistogo)
configure do
  require 'redis'
  uri = URI.parse(ENV['REDISTOGO_URL'])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

error 404 do
  'Status not found'
end

get '/' do; end

get '/ci/:job' do |job|
  begin
    status = REDIS.get("#{job.upcase}_STATUS")
    raise NameError unless status

    response.headers['Cache-Control'] = 'no-store'
    content_type 'image/png'
    send_file "public/images/#{status}.png"
  rescue NameError
    404
  end
end

post '/ci/:job' do |job|
  REDIS.set("#{job.upcase}_STATUS", params[:status])
end
