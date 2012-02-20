# encoding: utf-8

%w[json sinatra sinatra/synchrony faraday rack-flash].map {|lib| require lib}
Faraday.default_adapter = :em_synchrony

ENV['RACK_ENV'] ||= "production"
APP_ROOT = File.expand_path(File.dirname(__FILE__))

class ParseJobs < Sinatra::Base

  register Sinatra::Synchrony

  use Rack::Session::Cookie, :secret => 'please_change_this'
  use Rack::Flash
  use Rack::CommonLogger

  configure do
    enable :sessions
    enable :logging
    set :environment, ENV['RACK_ENV']
    set :public_folder, File.join(APP_ROOT, "public")
    set :server, %w[thin webrick]
  end

  get '/' do
    erb :index
  end

  get '/apply' do
    erb :apply
  end

  post '/apply' do
    begin
      raise "Invalid data" unless not params[:name].empty? and not params[:email].empty?
      raise "Tell us why Parse?" unless params[:about] and not params[:about].empty?
      raise "Provide us with some links" unless params[:links] and not params[:links].empty?
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
      if response.status.to_i == 200
        flash[:notice] = "Request sent. Relax and wait for answer."
      else
        flash[:error] = response['Status']
      end
    rescue Exception => ex
      flash[:error] = ex.to_s
    end
    redirect '/'
  end

  run! if app_file == $0
end
