require File.dirname(__FILE__) + '/../test_helper'

class UserSessionsControllerTest < ActionController::IntegrationTest
  #setup :activate_authlogic
  
  context "given data" do
    setup do
      @admin = Factory :admin_user
      @user = User.new(:email => 'someone@example.com', :password => 'Password123', :password_confirmation => 'Password123')
      @user.save!
    end

    teardown do
      User.delete_all
    end

    context "on successful ajax POST to :create" do
      setup do
        xhr :post, '/user_session', {:return_to => '/', :user_session => { :login => @user.email, :password => @user.password }}
      end
      should_respond_with :redirect
      should_redirect_to(':return_to') {'/'}
    end
    
    context "on failed ajax POST to :create" do
      setup do
        xhr :post, '/user_session', {:return_to => '/', :user_session => { :login => @user.email, :password => 'wrong password' }}
      end
      should_respond_with :redirect
      should_redirect_to(':return_to') {'/'}
    end
  end
end

