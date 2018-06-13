require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/install.yml", ENV["TARGET_HOST"], {
      env_name:      "dev",
      install_mysql: true,
      new_db_user:   "test_user",
      new_db_pass:   "password123"
    })
  end
end

describe "New DB user" do
  let(:subject) { command(%Q{mysql -Nqs -utest_user -ppassword123 -e "SELECT count(*) FROM mysql.user WHERE User = 'test_user'"}) }
  
  it "should exist" do
    expect(subject.stdout).to match /^3$/ # localhost, 127.0.0.1, ::1
    
    expect(subject.exit_status).to eq 0
  end
end
