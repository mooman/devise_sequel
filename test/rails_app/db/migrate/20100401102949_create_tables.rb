Sequel.migration do
  up do
    create_table :users do
      String :username
      String :facebook_token

      database_authenticatable :null => false
      confirmable
      recoverable
      rememberable
      trackable
      lockable
      token_authenticatable

      DateTime :created_at
      DateTime :updated_at
    end

    create_table :admins do
      database_authenticatable :null => true
      encryptable
      rememberable :use_salt => false
      recoverable
      lockable

      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :users
    drop_table :admins
  end
end
