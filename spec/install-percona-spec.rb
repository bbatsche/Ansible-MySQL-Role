require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/install.yml", ENV["TARGET_HOST"], {install_percona: true})
  end
end

describe "Percona Server" do
  include_examples "mysql server"
  include_examples("mysql client", "5.7")
end

describe "User Access" do
  include_examples "mysql security"
end
