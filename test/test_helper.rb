ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::JUnitReporter.new

class ActiveSupport::TestCase
  fixtures :all

  setup do
    User.create!( email: 'test@gmail.com', password: 'password', password_confirmation: 'password', campaign_id: campaigns(:one).id )
    User.create!( email: 'test2@gmail.com', password: 'password', password_confirmation: 'password' )
  end

  def authenticate_test
    authenticate('test@gmail.com', 'password')
  end
  
  def authenticate(email, password)
    post '/auth/sign_in', :params => { email: email, password: password }

    { user: @response.parsed_body['data'], headers: { uid: @response.headers['uid'], client: @response.headers['client'], 'access-token': @response.headers['access-token'] } }
  end
end
