# enoding: utf-8

require 'sinatra'

get '/' do; end

get '/ci/:job' do |job|
  headers['Cache-Control'] = 'no-cache'
  begin
    status = ENV["#{job.upcase}_STATUS"]
    raise NameError unless status
    content_type 'image/png'
    send_file "public/images/#{status}.png"
  rescue
    "Status not found: #{job}"
  end
end

post '/ci/:job' do |job|
  ENV["#{job.upcase}_STATUS"] = params[:status]
end
