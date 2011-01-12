module Shim
  extend ::ActiveSupport::Concern

  included do |base|
    extend ::Devise::Models
    extend ::Devise::Orm::Sequel::Hook

    base.raise_on_save_failure = false
    base.raise_on_typecast_failure = false

    # these methods are not supported, and probably should not  be supported,
    # only here to pass some tests
    def update_attribute (name, value)
      send(name.to_s + '=', value)
      save
    end

    def == (obj)
      obj.equal?(self) ||
      ((obj.class == model) && (obj.pk == pk) && !obj.new?)
    end

    def base.destroy_all
      delete
    end

    def base.last (ord)
      order(ord[:order].to_sym).last
    end
  end
end
