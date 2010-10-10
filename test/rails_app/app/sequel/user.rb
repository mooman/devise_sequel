require 'shared_user'

class User < Sequel::Model(:users)
  include Shim
  include SharedUser
end
