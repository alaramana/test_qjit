require "ostruct"
require "yaml"

config = OpenStruct.new(YAML.load_file("#{Rails.root}/config/smtp.yaml"))

::SMTPConfig = OpenStruct.new(config.send(Rails.env))

