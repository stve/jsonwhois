require 'jsonwhois'
require 'test/unit'
require 'rack/test'
require 'yajl'

set :environment, :test

class JSONWhoisTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_valid_domain
    get '/google.com'
    info = Yajl::Parser.parse(last_response.body)
    assert info.keys.include?('domain')
    assert info.keys.include?('status')
    assert info.keys.include?('nameservers')
  end

  def test_bad_domain
    get '/iamnotadomain'
    assert Yajl::Parser.parse(last_response.body).keys.include?('error')
  end
end
