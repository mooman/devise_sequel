Sequel.extension :migration
Sequel::Migrator.apply(Sequel::Model.db, "#{File.dirname(__FILE__)}/../rails_app/db/migrate")
puts 'db migrated'

class ActiveSupport::TestCase
  setup do
    User.delete
    Admin.delete
  end
end
