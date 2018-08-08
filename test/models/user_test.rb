require 'test_helper'
 
class UserTest < ActiveSupport::TestCase
  setup do
    @campaign = campaigns(:one)
  end

  test 'should create user with minimum information' do
    user = User.new( email: 'jake.kinsella@gmail.com', password: 'password', password_confirmation: 'password', campaign_id: @campaign.id )

    assert user.save
  end

  test 'should create user with maximum information' do
    user = User.new( email: 'jake.kinsella@gmail.com', password: 'password', password_confirmation: 'password', campaign_id: @campaign.id, first_name: 'Test', last_name: 'Test', admin: true, superuser: false, position: 'Candidate', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', zipcode: '01867', party: 'Democratic Party', created: true, middle_name: 'Middle', phone_number: '781-315-5580' )

    assert user.save
  end

  test "shouldn't create user with bad phone number" do
    user = User.new( email: 'jake.kinsella@gmail.com', password: 'password', password_confirmation: 'password', campaign_id: @campaign.id, phone_number: 'bad phone number' )

    assert_not user.save
  end

  test "shouldn't create user with position but not enough information" do
    user = User.new( email: 'jake.kinsella@gmail.com', password: 'password', password_confirmation: 'password', campaign_id: @campaign.id, position: 'Candidate' )

    assert_not user.save
  end

  test 'should create user with position and enough information' do
    user = User.new( email: 'jake.kinsella@gmail.com', password: 'password', password_confirmation: 'password', campaign_id: @campaign.id, position: 'Candidate', middle_name: 'Middle', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', zipcode: '01867', phone_number: '781-315-5580', party: 'Democratic Party' )

    assert user.save
  end
end