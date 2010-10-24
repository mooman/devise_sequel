require 'devise/orm/sequel/schema'
require 'devise/orm/sequel/compatibility'

module Devise
  module Orm
    module Sequel
      module Hook
        def devise_modules_hook!
          extend Schema
          include Compatibility
          include ActiveModel::Validations

          # obviously this doesn't work yet
          def self.validates_uniqueness_of(*fields)
          end

          yield
        end
      end
    end
  end
end

# this is an issue with anonymous classes being selected too, which #name returns nil
# raises lots of errors with Sequel. suggested fix from
# https://rails.lighthouseapp.com/projects/8994/tickets/5252-activemodel-naming-should-take-care-of-anonymous-classes
module ActiveModel
  module Translation
    def lookup_ancestors
      self.ancestors.select { |x| not x.anonymous? and x.respond_to?(:model_name) }
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
