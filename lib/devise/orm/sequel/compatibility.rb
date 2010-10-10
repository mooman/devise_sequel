module Devise
  module Orm
    module Sequel

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

          def create!(*args)
            o = new(*args)
            raise unless o.save
            o
          end

          # Hooks for confirmable
          def before_create(*args)
            wrap_hook(:before_create, *args)
          end

          def after_create(*args)
            wrap_hook(:after_create, *args)
          end

          def wrap_hook(action, *args)
            options = args.extract_options!
            callbacks = []

            args.each do |callback|
              callbacks << new_callback = :"#{callback}_devise_hook"

              class_eval <<-METHOD, __FILE__, __LINE__ + 1
                def #{new_callback}
                  #{callback} if #{options[:if] || true}
                end
              METHOD
            end

            class_eval <<-METHOD, __FILE__, __LINE__ + 1
              alias_method :orig_#{action}, :#{action}

              def #{action}
                #{callbacks.join(';')}

                # original method can still call super
                orig_#{action}
              end
            METHOD
          end
        end # ClassMethods
      
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


      end # Compatibility

    end # Sequel

  end
end
