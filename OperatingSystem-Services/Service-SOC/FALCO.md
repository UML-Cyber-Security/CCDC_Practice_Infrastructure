FALCO:apt (Debian/Ubuntu)
The following steps are for Debian and Debian-based distributions, such as Ubuntu, which use the apt package manager.
1. Trust the falcosecurity GPG key
    1. curl -fsSL https://falco.org/repo/falcosecurity-packages.asc | \
    2. sudo gpg --dearmor -o /usr/share/keyrings/falco-archive-keyring.gpg

1. Configure the apt repository
    1. echo "deb [signed-by=/usr/share/keyrings/falco-archive-keyring.gpg] https://download.falco.org/packages/deb stable main" | \
        1. sudo tee -a /etc/apt/sources.list.d/falcosecurity.list NOTE:*In older releases of Debian (Debian 9 and older ones), you might need to additionally install the package apt-transport-https to allow access to the Falco repository using the https protocol. The following command will install that package on your system: ‘sudo apt-get install apt-transport-https’*

Install some required dependencies that are needed to build the Kernel Module and the eBPF probe 	NOTE: You don't need to install these dependencies if you want to use the Modern eBPF.  1. sudo apt install -y dkms make linux-headers-$(uname -r)
	# If you use falcoctl driver loader to build the eBPF probe locally you need also clang toolchain
		sudo apt install -y clang llvm
	# You can install also the dialog package if you want it
		sudo apt install -y dialog
2. Install the Falco package
        1. sudo apt-get install -y falco

Upgrade
apt (Debian/Ubuntu)
If you configured the apt repository by having followed the instructions for Falco 0.27.0 or older, you may need to update the repository URL, otherwise, feel free to ignore this message
sed -i 's,https://dl.bintray.com/falcosecurity/deb,https://download.falco.org/packages/deb,' /etc/apt/sources.list.d/falcosecurity.list
apt-get clean
apt-get -y update

Check in the apt-get update log that https://download.falco.org/packages/deb is present.
If you installed Falco by following the provided instructions:
apt-get --only-upgrade install falco


Uninstall
apt (Debian/Ubuntu)
apt-get --purge autoremove falco      Troubleshooting
This section aims to offer further guidance when something doesn't go as expected in the installation of Falco.
Unable to find a prebuilt driver
* ERROR failed: unable to find a prebuilt driver
This error message appears when the falcoctl driver loader tool, which looks for the Falco driver and loads it in memory, is not able to find a pre-built driver, neither as an eBPF probe nor as a kernel module, at the [Falco driver repository] (https://download.falco.org).
You can easily browse and search the supported targets at download.falco.org/driver/site.
This means that there's no prebuilt driver available for the kernel running on the machine where Falco is going to be installed.
However, you can add your kernel release version to the build grid the pipeline refers to building the drivers. Follow this tutorial to contribute the required configuration.
There are a limited set of Linux distributions whose kernels are supported by the current prebuilt driver distribution pipeline.
driverkit is the tool used to build those drivers. Hence, it needs to support the specific Linux distribution. Find whether your Linux distribution is supported here.
