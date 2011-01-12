Sequel mapping to Devise
========================

**At least version 1.2.rc of Devise is required**

Please report any issues.

Installation
------------

    # bundler
    gem 'devise_sequel'

Also, at the moment (0.0.2) please use the orm_adapter-sequel from my repository: https://github.com/mooman/orm_adapter-sequel
This should be very temporary.

Set-up
------

I like to extend only the models I need for Devise:

    class User < Sequel::Model
      extend Devise::Models
      extend Devise::Orm::Sequel::Hook

      # usually active_model is included already in any Sequel Rails 3 connectors
      # plugin :active_model

      devise ... 
    end

But if you want them to be globally available for all your Sequal models, then uncomment the lines at the bottom of the sequel.rb file in the plugin. Hopefully this can be more elegant in the future where you can set an option somewhere.

Let us know if you have any suggestions and/or questions by creating a new issue.

Credits / Contributors
======================

Rachot Moragraan       
Daniel Lyons      

A lot of testing designs are from dm-devise.

