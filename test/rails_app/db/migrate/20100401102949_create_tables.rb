Class.new(Sequel::Migration) do
  def up
    create_table :users do
      primary_key :id
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
      primary_key :id
      database_authenticatable :null => true
      encryptable
      rememberable :use_salt => false
      recoverable
      lockable

      DateTime :created_at
      DateTime :updated_at
    end
  end

  def down
    drop_table :users
    drop_table :admins
  end
end
