require 'shared_user'

class User < Sequel::Model
  include Shim
  include SharedUser
end
