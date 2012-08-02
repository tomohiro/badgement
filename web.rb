# enoding: utf-8

require 'sinatra'

error 404 do
  'Status not found'
end

get '/' do; end

get '/ci/:job' do |job|
  begin
    response.headers['Cache-Control'] = 'no-store'
    status = ENV["#{job.upcase}_STATUS"]
    raise NameError unless status
    content_type 'image/png'
    send_file "public/images/#{status}.png"
  rescue
    404
  end
end

post '/ci/:job' do |job|
  ENV["#{job.upcase}_STATUS"] = params[:status]
end
