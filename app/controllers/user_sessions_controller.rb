class UserSessionsController < Spree::BaseController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  ssl_required :new, :create, :destroy, :update
  ssl_allowed :login_bar
    
  def new
    @user_session = UserSession.new
  end

  def create
    not_need_user_auto_creation = 
        user_without_openid(params[:user_session]) ||
        user_with_openid_exists?(:openid_identifier => params['openid.identity']) ||
        user_with_openid_exists?(params[:user_session]) 

    if not_need_user_auto_creation
      create_user_session(params[:user_session], params[:update_remote])   
    else
      create_user(params[:user_session])
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = t("logged_out")
    redirect_to products_path
  end
  
  def nav_bar
    render :partial => "shared/nav_bar"
  end
  
  private
  
  def user_with_openid_exists?(data)
    data && !data[:openid_identifier].blank? &&
      !!User.find(:first, :conditions => ["openid_identifier LIKE ?", "%#{data[:openid_identifier]}%"])
  end
  
  def user_without_openid(data)
    data && data[:openid_identifier].blank?
  end
  
  def create_user_session(data, update_remote)
    @user_session = UserSession.new(data)
    @user_session.save do |result|
      if result
        respond_to do |format|
          format.html {
            flash[:notice] = t("logged_in_succesfully") unless session[:return_to]
            redirect_back_or_default products_path
          }
          format.js {
            user = @user_session.record
            if update_remote
              render update_remote
            else
              render :json => {:ship_address => user.ship_address, :bill_address => user.bill_address}.to_json
            end
          }
        end
      else
        respond_to do |format|
          format.html {
            flash.now[:error] = t("login_failed")
            render :action => :new
          }
          format.js { 
            if update_remote
              flash.now[:error] = t("login_failed")
              render "#{update_remote}_fails"
            else
              render :json => false 
            end
          }
        end
      end
    end
    redirect_back_or_default(products_path) unless performed?
  end
  
  def create_user(data, update_remote)
    @user = User.new(data)

    @user.save do |result|
      if result
        respond_to do |format|
          format.html {
            flash[:notice] = t(:user_created_successfully) unless session[:return_to]
            redirect_back_or_default products_url
          }
          format.js { render update_remote }
        end
      else
        respond_to do |format|
          format.html {
            flash[:notice] = t(:missing_required_information)
            redirect_to :controller => :users, :action => :new, :user => {:openid_identifier => @user.openid_identifier}
          }
          format.js { render "#{update_remote}_fails"}
        end
      end
    end
  end

  def accurate_title
    I18n.t(:log_in)
  end
  
end
