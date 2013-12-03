require "ostruct"
require "yaml"

config = OpenStruct.new(YAML.load_file("#{Rails.root}/config/notification.yml"))

::NotificationConfig = OpenStruct.new(config.send(Rails.env))