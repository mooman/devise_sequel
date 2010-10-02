module Shim
  extend ::ActiveSupport::Concern

  included do
    extend ::Devise::Models
    extend ::Devise::Orm::Sequel::Hook

    plugin :validation_class_methods
  end
end
