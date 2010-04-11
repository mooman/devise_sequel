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

      module Compatibility
        extend ActiveSupport::Concern

        module ClassMethods
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
            conds = (options[:conditions].to_hash.symbolize_keys rescue true)

            case args.first
              when :first
                first(conds)
              when :all
                filter(conds).all
              else
                primary_key_lookup(args.first)
            end
          end
        end

        def changed?
          modified?
        end

        def save(flag=nil)
          if flag == false
            raise unless save
          else
            super
          end
        end

        def update_attributes(*args)
          update(*args)
        end
      end

      module Schema
        include Devise::Schema

        SCHEMA_OPTIONS = { 
          :limit => :size
          # there's also precision and scale
        }

        def apply_schema(name, type, options={})
          SCHEMA_OPTIONS.each do |old_key, new_key|
            next unless options.key?(old_key)
            options[new_key] = options.delete(old_key)
          end

          cname = name.to_s.to_sym
          if cname == :email then
            # special case for "authenticable" method to also add 
            # auto incrementing id, since sequel doesn't do this automatically
            primary_key(:id)
          end

          column(cname, type, options)
        end
      end

    end
  end
end

if defined?(Sequel) then
    # extend Sequel Model
    Sequel::Model.extend(Devise::Models)
    Sequel::Model.extend(Devise::Orm::Sequel::Hook)
    # probably just need the apply_schema method
    Sequel::Schema::Generator.send(:include, Devise::Orm::Sequel::Schema)
end
