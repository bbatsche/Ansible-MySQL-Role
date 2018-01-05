require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/install.yml", ENV["TARGET_HOST"], {
      env_name:                      "dev",
      install_mysql:                 true,
      mysql_mem_percent:             80,
      innodb_buffer_pool_percent:    60,
      innodb_buffer_pool_chunk_size: "1M",
      mysql_key_buffer_percent:      20,
      mysql_enable_network:          true,
      mysql_sql_mode:                "ANSI,STRICT_TRANS_TABLES,STRICT_ALL_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
    })
  end
end

context "MySQL variables" do
  let(:mysql_password) { "vagrant" }
  
  totalMem = host_inventory["memory"]["total"].to_i
  
  describe "InnoDB buffer pool size" do
    output = command(%Q{mysql -uvagrant -pvagrant -e "SHOW VARIABLES LIKE 'innodb_buffer_pool_size'"}).stdout
    
    let(:subject) { output.split("\n")[1].gsub(/innodb_buffer_pool_size\s+(.+)$/, '\1') }
    
    it "is set based on total memory" do
      expect(subject.to_i / 1024).to be_within(1024).of((totalMem * 0.8 * 0.6).to_i)
    end
  end
  
  describe "Key buffer size" do
    output = command(%Q{mysql -uvagrant -pvagrant -e "SHOW VARIABLES LIKE 'key_buffer_size'"}).stdout
    
    let(:subject) { output.split("\n")[1].gsub(/key_buffer_size\s+(.+)$/, '\1') }
    
    it "is set based on total memory" do
      expect(subject.to_i / 1024).to be_within(1024).of((totalMem * 0.8 * 0.2).to_i)
    end
  end
  
  describe "SQL mode" do
    output = command(%Q{mysql -uvagrant -pvagrant -e "SHOW VARIABLES LIKE 'sql_mode'"}).stdout
    
    let(:subject) { output.split("\n")[1].gsub(/sql_mode\s+(.+)$/, '\1') }
    
    it "is set in config" do
      expect(subject).to match /PIPES_AS_CONCAT/
      expect(subject).to match /ANSI_QUOTES/
      # expect(subject).not_to match /NO_ZERO_DATE/
      expect(subject).not_to match /NO_ZERO_IN_DATE/
    end
  end
  
  describe "bind address" do
    include_examples("mysql variable", "bind_address", "*")
  end
end
