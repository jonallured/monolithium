class Killswitch < ApplicationRecord
  def self.instance
    @instance ||= load_instance
  end

  def self.load_instance
    killswitch = first || create
    path = Rails.root.join("config/initializers/killswitch.yml")
    attrs = YAML.safe_load_file(path)
    killswitch.update(attrs)
    killswitch
  end
end
