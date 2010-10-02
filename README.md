Sequel mapping to Devise
========================

**A gem plugin is coming soon! (once all the tests passes)**

I like to extend only the models I need for Devise:

    class User < Sequel::Model
      extend Devise::Models
      extend Devise::Orm::Sequel::Hook

      # usually active_model is included already in any Sequel Rails 3 connectors
      # plugin :active_model
      plugin :validation_class_methods

      devise ... 
    end

But if you want them to be globally available for all your Sequal models, then uncomment the lines at the bottom of the sequel.rb file in the plugin. Hopefully this can be more elegant in the future where you can set an option somewhere.

Let us know if you have any suggestions and/or questions by creating a new issue.

Credits / Contributors
======================

Rachot Moragraan
Daniel Lyons

A lot of testing designs are from dm-devise.

