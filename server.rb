# server.rb
require 'sinatra'
require 'redis'
require 'json'

# set :public_folder, File.dirname(__FILE__) + '/public'
set :bind, '0.0.0.0'
set :show_exceptions, true
set :raise_errors, true
set :dump_errors, true

redis_host = ENV['REDIS_HOST']
redis_host ||= '127.0.0.1'

#redis_port = ENV['REDIS_PORT'].to_i
#redis_port ||= 6379

#redis = Redis.new(host: redis_host, port: redis_port)
redis = Redis.new(host: redis_host)
#redis.set('todos', '{}')

redis.set('todos', '[{"id":0,"title":"todo","completed":true}]') if redis.get('todos').nil?

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/todos' do
  content_type :json
  todos = redis.get('todos')
  logger.info "get #{todos}"
  return todos
end

post '/todos' do
  data = request.body.read
  logger.info "post #{data}"
  if data.empty?
    return redis.get('todos')
  end

  #payload = JSON.parse(data)
  payload = data
  logger.info "post #{payload}"
  redis.set('todos',payload)
  puts redis.get('todos')
  return redis.get('todos')

end
