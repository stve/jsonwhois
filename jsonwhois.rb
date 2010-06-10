require 'rubygems'
require 'sinatra'
require 'whois'
require 'json'
require 'core_ext/struct'
require 'erb'

set :views, File.dirname(__FILE__) + '/templates'
set :env, :production

get '/' do
  erb :index
end

get '/:domain' do
  if request.accept.include?('application/json')
    content_type :json
  else
    content_type :text
  end

  begin
    response.headers['Cache-Control'] = 'public, max-age=300'
    domain = Whois.query(params[:domain])
    domain.properties.to_json
  rescue => e
    { :error => "Error: #{e.message}" }.to_json
  rescue TimeoutError => te
    { :error => "Error: #{te.message}" }.to_json
  end
end
