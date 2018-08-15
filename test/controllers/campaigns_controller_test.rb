require 'test_helper'

class CampaignsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @campaign = campaigns(:one)

    user = authenticate_test

    @auth_headers = user[:headers]
    @email = user[:user]['email']
  end

  test "shouldn't get index without superuser authentication" do
    get campaigns_url, :headers => @auth_headers

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get campaign_url(@campaign), :headers => @auth_headers

    assert_response :success
  end

  test "shouldn't get show with different campaign" do
    get campaign_url(campaigns(:two)), :headers => @auth_headers

    assert_response :unauthorized
  end

  test "shouldn't get show without authentication" do
    get campaign_url(@campaign)

    assert_response :unauthorized
  end

  test 'should get show by name with authentication' do
    get "/campaigns/name/#{URI.encode(@campaign.name)}", :headers => @auth_headers

    assert_response :success
  end

  test 'should create with authentication' do
    user = authenticate('test2@gmail.com', 'password')

    assert_difference('Campaign.count', 1) do
      post campaigns_url, params: { name: 'Test', url: '', preliminary_day: DateTime.now - 1.month, election_day: DateTime.now, city: 'Reading', state: 'MA', country: 'United States', office_type: 'Municipal' }, :headers => user[:headers]
    end

    assert_response :success
  end

  test "shouldn't create with previous campaign attached" do
    user = User.where( email: @email ).first
    user.campaign_id = @campaign.id
    user.save

    assert_difference('Campaign.count', 0) do
      post campaigns_url, params: { name: 'Test', url: '', preliminary_day: DateTime.now - 1.month, election_day: DateTime.now, city: 'Reading', state: 'MA', country: 'United States', office_type: 'Municipal' }, :headers => @auth_headers
    end

    assert_response :unauthorized
  end

  test "shouldn't create without authentication" do
    assert_difference('Campaign.count', 0) do
      post campaigns_url, params: { name: 'Test', url: '', preliminary_day: DateTime.now - 1.month, election_day: DateTime.now, city: 'Reading', state: 'MA', country: 'United States', office_type: 'Municipal' }
    end

    assert_response :unauthorized
  end

  test 'should update with authentication and admin' do
    user = User.where( email: @email ).first
    user.admin = true
    user.save

    patch campaign_url(@campaign), params: { name: 'Test2' }, :headers => @auth_headers
    @campaign.reload

    assert_response :success
    assert @campaign.name == 'Test2'
  end

  test "shouldn't update without authentication" do
    patch campaign_url(@campaign), params: { name: 'Test2' }
    @campaign.reload

    assert_response :unauthorized
    assert_not @campaign.name == 'Test2'
  end

  test "shouldn't update without admin" do
    patch campaign_url(@campaign), params: { name: 'Test2' }, :headers => @auth_headers
    @campaign.reload

    assert_response :unauthorized
    assert_not @campaign.name == 'Test2'
  end

  test 'should destroy with authentication and admin' do
    user = User.where( email: @email ).first
    user.admin = true
    user.save

    assert_difference('Campaign.count', -1) do
      delete campaign_url(@campaign), :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't destroy without authentication" do
    assert_difference('Campaign.count', 0) do
      delete campaign_url(@campaign)
    end

    assert_response :unauthorized
  end

  test "shouldn't destroy without admin" do
    assert_difference('Campaign.count', 0) do
      delete campaign_url(@campaign), :headers => @auth_headers
    end

    assert_response :unauthorized
  end
end
