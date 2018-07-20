require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/install.yml", ENV["TARGET_HOST"], {install_mariadb: true})
  end
end

describe "MariaDB" do
  include_examples "mysql server"
  include_examples("mysql client", "10.3")
end

describe "User Access" do
  include_examples "mysql security"
end
