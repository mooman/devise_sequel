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
    # uncomment the following lines to have ALL sequel models compatible with Devise

    # Sequel::Model.extend(Devise::Models)
    # Sequel::Model.extend(Devise::Orm::Sequel::Hook)
    # Sequel::Model.plugin :active_model
    # Sequel::Model.plugin :validation_class_methods
    # Sequel::Model.plugin :hook_class_methods

    # probably just need the apply_schema method
    Sequel::Schema::Generator.send(:include, Devise::Orm::Sequel::Schema)
end
