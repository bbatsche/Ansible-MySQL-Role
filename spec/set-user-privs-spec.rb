require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/install.yml", ENV["TARGET_HOST"], {
      env_name:      "dev",
      install_mysql: true,
      new_db_name:   "test_db",
      new_db_user:   "test_db_owner",
      new_db_pass:   "password123",
      new_db_priv:   "*.*:SELECT"
    })
  end
end

describe "New DB user" do
  let(:subject) { command('mysql -Nqs -utest_db_owner -ppassword123 -e "CREATE TABLE test_db.test_table (id INTEGER PRIMARY KEY)"') }
  
  it "should not be able to create tables" do
    expect(subject.stderr).to match /CREATE command denied to user 'test_db_owner'@'localhost'/
    
    expect(subject.exit_status).not_to eq 0
  end
end
