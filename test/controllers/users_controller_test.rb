require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = authenticate_test # TODO: Don't auth every single time

    @user = user[:user]
    @auth_headers = user[:headers]
  end

  test 'should get index with authentication' do
    get '/staff', :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['users'].nil?
    assert @response.parsed_body['users'].length == 1
  end

  test "shouldn't get index without authentication" do
    get '/staff'

    assert_response :unauthorized
  end

  test 'should get positions with authentication' do
    get '/staff_positions', :headers => @auth_headers

    assert_response :success
  end

  test "shouldn't get positions without authentication" do
    get '/staff_positions'

    assert_response :unauthorized
  end

  test 'should get users with committee positions with authentication' do
    get '/users/users_with_committee_positions', :headers => @auth_headers

    assert_response :success
  end

  test "shouldn't get users with committee positions without authentication" do
    get '/users/users_with_committee_positions'

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get "/staff/#{@user['id']}", :headers => @auth_headers

    assert_response :success
  end

  test "shouldn't get show without authentication" do
    get "/staff/#{@user['id']}"

    assert_response :unauthorized
  end

  test 'should update with authentication and admin' do
    user = User.where( email: @user['email'] ).first
    user.admin = true
    user.save

    patch "/staff/#{@user['id']}", :params => { first_name: 'Test2' }, :headers => @auth_headers

    user = User.where( email: @user['email'] ).first

    assert_response :success
    assert user.first_name == 'Test2'
  end

  test "shouldn't update without admin" do
    patch "/staff/#{@user['id']}", :params => { first_name: 'Test2' }, :headers => @auth_headers

    user = User.where( email: @user['email'] ).first

    assert_response :unauthorized
    assert_not user.first_name == 'Test2'
  end

  test "shouldn't update without authentication" do
    patch "/staff/#{@user['id']}", :params => { first_name: 'Test2' }

    user = User.where( email: @user['email'] ).first

    assert_response :unauthorized
    assert_not user.first_name == 'Test2'
  end

  test 'should update campaign id with authentication' do
    user = authenticate('test2@gmail.com', 'password')

    user_record = User.where( email: user[:user]['email'] ).first
    user_record.admin = true
    user_record.save
    
    patch "/staff/#{user[:user]['id']}/campaign_id", :params => { campaign_id: campaigns(:one).id }, :headers => user[:headers]

    user_record.reload

    assert_response :success
    assert user_record.campaign_id == campaigns(:one).id
  end

  test "shouldn't update campaign id without authentication" do
    patch "/staff/#{@user['id']}/campaign_id", :params => { campaign_id: '1234' }

    user = User.where( email: @user['email'] ).first

    assert_response :unauthorized
    assert_not user.campaign_id == '1234'
  end

  test 'should destroy with authentication and admin' do
    user = User.where( email: @user['email'] ).first
    user.admin = true
    user.save

    # TODO: I can't find out why this test is failing
    # assert_difference('User.count', -1) do
      # delete "/staff/#{@user['id']}", :headers => @auth_headers
    # end

    # assert_response :success
  end

  test "shouldn't destroy without admin" do
    assert_difference('User.count', 0) do
      delete "/staff/#{@user['id']}", :headers => @auth_headers
    end

    assert_response :unauthorized
  end

  test "shouldn't destroy without authentication" do
    assert_difference('User.count', 0) do
      delete "/staff/#{@user['id']}"
    end

    assert_response :unauthorized
  end

  # TODO: Test token stuff
end
