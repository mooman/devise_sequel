module Devise
  module Orm
    module Sequel

      module Compatibility
        extend ActiveSupport::Concern

        module ClassMethods

          # for some reason devise tests still use create! from the model itself
          def create! (*args)
#            to_adapter.create!(*args)
            o = new(*args)
            raise unless o.save
            o
          end

          # Hooks for confirmable
          def before_create (*args)
            wrap_hook(:before_create, *args)
          end

          def after_create (*args)
            wrap_hook(:after_create, *args)
          end

          def before_save (*args)
            wrap_hook(:before_save, *args)
          end

          def before_validation (*args)
            wrap_hook(:before_validation, *args)
          end

          def wrap_hook (action, *args)
            options = args.extract_options!
            callbacks = []

            # basically creates a new callback method with _devise_hook suffix
            # so that the if option can be supported
            # and then rewrite the original hook method to run the new callbacks
            # and continue with original hook (it's not pretty)
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

        def save!
          save(:raise_on_failure => true)
        end

        def update_attributes (*args)
          update(*args)
        end

        def attributes= (hash, guarded=true)
          (guarded) ? set(hash) : set_all(hash)
        end

      end # Compatibility

    end # Sequel

  end
end
