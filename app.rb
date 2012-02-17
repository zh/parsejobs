# encoding: utf-8

%w[json sinatra sinatra/synchrony faraday].map {|lib| require lib}
Faraday.default_adapter = :em_synchrony

ENV['RACK_ENV'] ||= "production"
APP_ROOT = File.expand_path(File.dirname(__FILE__))

class ParseJobs < Sinatra::Base
  register Sinatra::Synchrony

  configure do
    disable :sessions
    enable :logging
    set :environment, ENV['RACK_ENV']
    set :public_folder, File.join(APP_ROOT, "public")
  end

  get '/' do
    erb :index
  end

  get '/apply' do
    erb :apply
  end

  post '/apply' do
    halt 404, "Invalid data" unless params[:name] and params[:email]
    halt 404, "Why Parse?" unless params[:about] and not params[:about].empty?
    halt 404, "Provide some links" unless params[:links] and not params[:links].empty?
    payload = {:name=>params[:name], :email=>params[:email], :about=>params[:about]}
    links = []
    params[:links].each_line { |line| links << line.chomp }
    payload[:urls] = links.compact.delete_if {|x| x.empty? }
    api = Faraday.new(:url => 'https://www.parse.com')
    response = api.post do |req|
      req.url '/jobs/apply'
      req.headers['Content-Type'] = 'application/json'
      req.body = payload.to_json
    end
    puts response.inspect
    redirect '/'
  end

  run! if app_file == $0
end
