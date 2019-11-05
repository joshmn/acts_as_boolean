module ActsAsBoolean
  class Railtie < ::Rails::Railtie
    initializer 'acts_as_boolean' do
      ActiveSupport.on_load :active_record do
        extend ActsAsBoolean::Extension
      end
    end
  end
end
