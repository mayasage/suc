# Readme

## Vagrant Commands

1. `vagrant box add jasonc/centos7`
2. `vagrant init jsonc/centos7`
3. `vagrant up`
4. `vagrant status`
5. `vagrant ssh`
6. `exit`
7. `vagrant halt`
8. `vagrant reload`
9. `vagrant destroy`
   
## HyperV Vagrant File Configuration

1. Action → Virtual Switch Manager → Create a new switch as `Internal Network` (don't use `Private Network` or you'll get network timeout during `vagrant up`).
2. Add `VAGRANT_DEFAULT_PROVIDER` to system variable with value `hyperv` (otherwise you'll have to add `--hyperv` in command).
3. Make some folder and cd into it. This is a vagrant `project`.
4. Run `vagrant init centos/7 --box-version 2004.01`
5. It will create a Vagrantfile

6. Below is my working Vagrantfile.

   ```
        Vagrant.configure("2") do |config|
            config.vm.box = "centos/7"
            config.vm.box_version = "2004.01"
        
            config.vm.provider "hyperv" do |h|
                h.memory = 256
            end

            config.vm.define "test1" do |test1|
                test1.vm.hostname = "test1"
                test1.vm.network "private_network", bridge: "Maya Default Network Switch Copy", ip: "10.9.8.5"
            end
        
            config.vm.define "test2" do |test2|
                test2.vm.hostname = "test2"
                test2.vm.network "private_network", bridge: "Maya Default Network Switch Copy", ip: "10.9.8.6"
            end
        end
    ```
    
    Ip doesn't work.  
    It'll generate some random IP, you should be able to ping it from your host terminal.

## Vagrant Commands Illegal Glossary

1. `box` means virtual box
2. Default vagrant account and password is "vagrant" itself.