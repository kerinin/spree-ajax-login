ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require 'test_help'
require "authlogic/test_case"

require 'rubygems'
require 'active_record'
require 'test/unit'
require 'logger'

#unless defined? SPREE_ROOT
#  ENV["RAILS_ENV"] = "test"
#  require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/config/boot"
#end

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end

I18n.locale = "en-US"
Spree::Config.set(:default_country_id => Country.first.id) if Country.first


class ActionController::TestCase
    setup :activate_authlogic
end

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::INFO

require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/test/test_helper"

require "#{File.dirname(__FILE__)}/factories"

