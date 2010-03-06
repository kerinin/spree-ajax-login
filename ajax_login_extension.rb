# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class AjaxLoginExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/ajax_login"

  # Please use ajax_login/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate
    ActiveRecord::Base.logger.warn "activating"
    # make your helper avaliable in all views
    # Spree::BaseController.class_eval do
    #   helper YourHelper
    # end

=begin
      private
      
      def create_user(data)
        @user = User.new(data)

        @user.save do |result|
          if result
            respond_to do |format|
              format.html {
                flash[:notice] = t(:user_created_successfully) unless session[:return_to]
                redirect_back_or_default products_url
              }
              format.js { create_user_session( @user ) }
            end
          else
            respond_to do |format|
              format.html {
                flash[:notice] = t(:missing_required_information)
                redirect_to :controller => :users, :action => :new, :user => {:openid_identifier => @user.openid_identifier}
              }
              format.js { render :action => :create_user_fails, :locals => {:openid_identifier => @user.openid_identifier} }
            end
          end
        end
      end

    end
=end
  end
end
