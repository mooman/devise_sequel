require 'shared_admin'

class Admin < Sequel::Model(:admins)
  include Shim
  include SharedAdmin
end
