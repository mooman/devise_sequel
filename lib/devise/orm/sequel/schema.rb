module Devise
  module Orm
    module Sequel

      module Schema
        include Devise::Schema

        SCHEMA_OPTIONS = { 
          :limit => :size
          # there's also precision and scale
        }

        def apply_devise_schema(name, type, options={})
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
