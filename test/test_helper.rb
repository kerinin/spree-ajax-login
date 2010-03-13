ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require 'test_help'
require 'will_paginate'
require "authlogic/test_case"
require 'rubygems'
require 'active_record'
require 'test/unit'
require 'logger'

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::INFO

require "#{File.dirname(__FILE__)}/factories"

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end

I18n.locale = "en-US"
Spree::Config.set(:default_country_id => Country.first.id) if Country.first

class ActionController::TestCase
    setup :activate_authlogic
end

ActionController::TestCase.class_eval do
  # special overload methods for "global"/nested params
  [ :get, :post, :put, :delete ].each do |overloaded_method|
    define_method overloaded_method do |*args|
      action,params,extras = *args
      super action, params || {}, *extras unless @params
      super action, @params.merge( params || {} ), *extras if @params
    end
  end
end

def setup
  super
  @params = {}
end

# useful method for functional tests that require an authenticated user
def set_current_user
  @user = Factory(:user)
  @controller.stub!(:current_user, :return => @user)
end

# test_helper.rb
class Test::Unit::TestCase # or class ActiveSupport::TestCase in Rails 2.3.x
  def without_timestamping_of(*klasses)
    if block_given?
      klasses.delete_if { |klass| !klass.record_timestamps }
      klasses.each { |klass| klass.record_timestamps = false }
      begin
        yield
      ensure
        klasses.each { |klass| klass.record_timestamps = true }
      end
    end
  end
end
