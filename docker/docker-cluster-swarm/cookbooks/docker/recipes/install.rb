# +==========================================
#   BASIC PACKAGES INSTALATION
# +==========================================
package "Install base packages" do
    package_name "yum-utils"
end


# +==========================================
#   YUM REPOSITORIES CONFIGURATION
# +==========================================
yum_repository "docker-main" do
    description "Docker Repository"
    baseurl "https://yum.dockerproject.org/repo/main/centos/7/"
    enabled true
    gpgcheck true
    gpgkey "https://yum.dockerproject.org/gpg"
    action :create
end

yum_repository "docker-testing" do
    description "Docker Repository for Testing"
    baseurl "https://yum.dockerproject.org/repo/testing/centos/$releasever/"
    enabled false
    gpgcheck true
    gpgkey "https://yum.dockerproject.org/gpg"
    action :create
end

yum_repository "docker-beta" do
    description "Docker Repository for Beta Test"
    baseurl "https://yum.dockerproject.org/repo/beta/centos/7/"
    enabled false
    gpgcheck true
    gpgkey "https://yum.dockerproject.org/gpg"
end

yum_repository "docker-nightly" do
    description "Docker Repository Nightly"
    baseurl "https://yum.dockerproject.org/repo/nightly/centos/7/"
    enabled false
    gpgcheck false
    gpgkey "https://yum.dockerproject.org/gpg"
end


# +==========================================
#   INSTALL DOCKER ENGINE
# +==========================================
package "Installing Docker Engine" do
    package_name "docker-engine"
    action :install
end


# +==========================================
#   HANDLE THE SERVICES INSTALATION 
# +==========================================
service "docker" do
    action [ :enable, :start ]
end
