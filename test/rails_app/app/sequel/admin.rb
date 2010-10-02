require 'shared_admin'

class Admin < Sequel::Model
  include Shim
  include SharedAdmin
end
