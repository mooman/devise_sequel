require 'devise/orm/sequel/schema'
require 'devise/orm/sequel/compatibility'

module Devise
  module Orm
    module Sequel
      module Hook
        def devise_modules_hook!
          extend Schema
          include Compatibility
          yield
        end
      end
    end
  end
end

if defined?(Sequel) then
    # extend Sequel Model
    # uncomment the following lines to have ALL sequel models compatible with Devise

    # Sequel::Model.extend(Devise::Models)
    # Sequel::Model.extend(Devise::Orm::Sequel::Hook)
    # Sequel::Model.plugin :active_model
    # Sequel::Model.plugin :validation_class_methods

    # probably just need the apply_schema method
    Sequel::Schema::Generator.send(:include, Devise::Orm::Sequel::Schema)
end
