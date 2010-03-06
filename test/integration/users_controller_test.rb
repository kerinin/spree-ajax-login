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
        xhr :post, '/user_session', {:update_remote => 'default', :user_session => { :login => @user.email, :password => @user.password }}
        puts @response.body
        puts flash
        
      end
      should_assign_to :user_session
      should_respond_with :success
      should_respond_with_content_type 'text/javascript'
      should_render_template 'default'
    end
    
    context "on failed ajax POST to :create" do
      setup do
        xhr :post, '/user_session', {:update_remote => 'default', :user_session => { :login => @user.email, :password => 'wrong password' }}
        puts @response.body
        puts flash
        
      end
      should_assign_to :user_session
      should_respond_with :success
      should_respond_with_content_type 'text/javascript'
      should_render_template 'default_fails'
    end
  end
end

