module Devise
  module Orm
    module Sequel
      module InstanceMethods
        def save(flag=nil)
          if flag == false
            raise unless save
          else
            super
          end
        end
      end

      def self.included_modules_hook(klass)
        klass.send :extend,  self
        klass.send :include, InstanceMethods

        yield

        klass.devise_modules.each do |mod|
          klass.send(mod) if klass.respond_to?(mod)
        end
      end

      include Devise::Schema

      # Hooks for confirmable
      def before_create(*args)
        wrap_hook(:before_create, *args)
      end

      def after_create(*args)
        wrap_hook(:after_create, *args)
      end

      def wrap_hook(action, *args)
        options = args.extract_options!

        args.each do |callback|
          class_eval <<-METHOD, __FILE__, __LINE__ + 1
            def #{callback}
              super if #{options[:if] || true}
            end

            alias_method :orig_#{action}, :#{action}

            def #{action}
              orig_#{action}
              #{callback}
            end
          METHOD
        end
      end

      # Add ActiveRecord like finder
      def find(*args)
        options = args.extract_options!
        case args.first
          when :first
            first(options[:conditions].to_hash.symbolize_keys || true)
          when :all
            filter(options[:conditions].to_hash.symbolize_keys || true).all
          else
            primary_key_lookup(args.first)
        end
      end

      # Sequal Schema, does nothing at model lever
      def apply_schema(name, type, options={})
        # return unless Devise.apply_schema
        return
      end

      module Schema
        SCHEMA_OPTIONS = { 
          :limit => :size
          # there's also precision and scale
        }

        def apply_schema(name, type, options={})
          SCHEMA_OPTIONS.each do |old_key, new_key|
            next unless options.key?(old_key)
            options[new_key] = options.delete(old_key)
          end

          column(name.to_s.to_sym, type, options)
        end
      end

    end
  end
end

if defined?(Sequel) then
    # extend Sequel Model
    Sequel::Model.extend(Devise::Models)
    # include devise schema macros
    Sequel::Schema::Generator.send(:include, Devise::Schema)
    # probably just need the apply_schema method
    Sequel::Schema::Generator.send(:include, Devise::Orm::Sequel::Schema)
end
