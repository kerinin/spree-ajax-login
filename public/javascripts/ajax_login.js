$user_session = new Object()

function ajax_login_init() {
  // show the form in its base state
  $user_session.setup = function() {
    $('body').addClass('ajax-login');
    jQuery('#ajax-login').show();
    jQuery('#ajax-login-form').hide();
    jQuery('#ajax-signup-form').hide();
    jQuery('#ajax-forgot-form').hide();  
    return this
  };
  
  $user_session.teardown = function() {
    this.callbacks({});
    this.setup()
    jQuery('#ajax-login').hide();
    $('body').removeClass('ajax-login');
  }

  // set the callbacks
  // this allows you to define callbacks on the link_to_function tag 
  // which shows the login window.  This means you can pass different
  // callback responses based on where the login was called from without
  // inserting markup for multiple login forms 
  $user_session.callbacks = function( opts ) {
    if( !( opts==null ) ) {
      var defaults = {
        'cancel'        : function(){ this.teardown(); },
        'loading'       : function(){},
        'loaded'        : function(){},
        'interactive'   : function(){},
        'success'       : function(){ this.session = true; this.teardown(); },
        'failure'       : function(){},
        'complete'      : function(){},
        'confirm'       : function(){},
        'condition'     : function(){},
        'before'        : function(){},
        'after'         : function(){},
        'submit'        : function(){}
      }
      for( callback in defaults ) {
        eval( 'this.'+callback+' = ( ( callback in opts ) ? opts[callback] : defaults[callback] );');
      }  
    }
    return this
  };
  
  // set default callbacks
  $user_session.callbacks({});

  $user_session.exists = function() {
    if(this.session == true) return true;
    else {
     this.login();
     return false;
    }
  };
  
  // state changes and callback initialization
  $user_session.login = function( opts ) { this.callbacks(opts).setup(); jQuery('#ajax-login-form').show(); };
  $user_session.signup = function( opts ) { this.callbacks(opts).setup(); jQuery('#ajax-signup-form').show(); };
  $user_session.forgot = function( opts ) { this.callbacks(opts).setup(); jQuery('#ajax-forgot-form').show(); };
}

jQuery(document).ready( ajax_login_init ); 

