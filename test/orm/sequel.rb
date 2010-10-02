Sequel.extension :migration
Sequel::Migrator.apply(Sequel::Model.db, "#{DEVISE_PATH}/test/rails_app/db/migrate")
puts 'db migrated'

class ActiveSupport::TestCase
  setup do
    puts 'im supposed to be doing something'
  end
end
