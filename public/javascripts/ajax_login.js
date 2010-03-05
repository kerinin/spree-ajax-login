var $login
var $login_form
var $signup_form
var $forgot_form

function ajax_login_init() {
  $login = jQuery('#ajax-login');
  $login_form = jQuery('#ajax-login-form');
  $signup_form = jQuery('#ajax-signup-form');
  $forgot_form = jQuery('#ajax-forgot-form');

  // show the form in its base state
  $login.setup = function() {
    $('body').addClass('ajax-login');
    this.show();
    $login_form.hide();
    $signup_form.hide();
    $forgot_form.hide();  
    return this
  };
  
  $login.teardown = function() {
    this.callbacks({});
    this.setup().hide();
    $('body').removeClass('ajax-login');
  }

  // set the callbacks
  // this allows you to define callbacks on the link_to_function tag 
  // which shows the login window.  This means you can pass different
  // callback responses based on where the login was called from without
  // inserting markup for multiple login forms 
  $login.callbacks = function( opts ) {
    if( !( opts==null ) ) {
      var defaults = {
        'cancel'        : function(){ this.teardown(); },
        'loading'       : function(){},
        'loaded'        : function(){},
        'interactive'   : function(){},
        'success'       : function(){ this.teardown(); },
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
  $login.callbacks({})

  // state changes and callback initialization
  $login.login = function( opts ) { this.callbacks(opts).setup(); $login_form.show(); };
  $login.signup = function( opts ) { this.callbacks(opts).setup(); $signup_form.show(); };
  $login.forgot = function( opts ) { this.callbacks(opts).setup(); $forgot_form.show(); };
}

jQuery(document).ready( ajax_login_init ); 

