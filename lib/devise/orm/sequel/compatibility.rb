module Devise
  module Orm
    module Sequel

      module Compatibility
        extend ActiveSupport::Concern

        module ClassMethods
          # Add ActiveRecord like finder
          def find (*args)
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

          def method_missing (method, *args)
            m = method.to_s.match(/^find_by_(.*)/)
            super unless m
            first(m[1].to_sym => args)
          end


          def create! (*args)
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

          def wrap_hook (action, *args)
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
