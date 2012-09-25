require File.expand_path('../helpers', __FILE__)

describe ChefRun.new('jira::default') do
  
  context "on ubuntu 12.04" do
    before(:all) { mock_and_converge('ubuntu', 12.04) }
    
    context "when installing prerequisites" do
      %w{ openjdk-6-jdk apache2 runit mysql-client mysql-server }.each do |pkg|
        it { should install_package pkg }
      end
    end

    context "when installing jira" do
      it "should install binaries to /opt/jira" do 
        subject.cookbook_file('/opt/jira/bin/startup.sh').should_not be_nil
        subject.cookbook_file('/opt/jira/bin/catalina.sh').should_not be_nil
      end 
      it "should have an executable startup.sh" do
        subject.cookbook_file('/opt/jira/bin/startup.sh').mode.should eq(0755)
      end
      it "should create a service for jira" do
        subject.find_resource('service', 'jira').should_not be_nil
      end
      it "should create jira home at /var/jira" do
        subject.should create_directory('/var/jira/')
        subject.should create_file_with_content '/opt/jira/atlassian-jira/WEB-INF/classes/jira-application.properties', 'jira.home = /var/jira/'
      end
    end 

    context "when configuring apache" do
      it "should enable the jira site" do 
        subject.should execute_command "/usr/sbin/a2dissite 000-default"
      end
      it "should disable the default site" do
        subject.should execute_command "/usr/sbin/a2ensite jira.conf"
      end
      it "should run jira on port 80" do
        subject.should create_file_with_content '/etc/apache2/sites-available/jira.conf', '<VirtualHost *:80>'
      end
      it "should serve jira from /opt/jira" do
        subject.should create_file_with_content '/etc/apache2/sites-available/jira.conf', 'DocumentRoot /opt/jira'
        subject.directory('/opt/jira').should be_owned_by('www-data', 'www-data')
      end
    end
  end


  def mock_and_converge(platform, version = 0)
    mock_ohai(platform: platform, platform_version: version)
    subject.converge
  end
end
