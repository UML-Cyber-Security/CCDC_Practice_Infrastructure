# Installation and setup of Sysinternals Suite

## Package manager
1.	To view all commands associated with package management:<br/>
```Get-Command -Module PackageManagement```

2.	Install the Chocolatey package manager to enable sysinternals install from command line:<br/>
```Register-PackageSource -name chocolatey -ProviderName Chocolatey -location http://chocolatey.org/api/v2/```

3.	Confirm that you can find Sysinternals package:<br/>
```Find-Package -Name Sysinternals```

4.	Install Sysinternals:<br/>
```Install-Package -Name Sysinternals```

Installation automatically places Sysinternals into ```C:\Chocolately\lib``` folder.

Unfortunately, you have to manually add the PATH environment variable in order to use it from command line:
- Click `Environment Variables`
- Find the variable `Path`, highlight it and click `Edit...`
- Create a new entry with the absolute path of the directory sysinternals is saved in.
- Click `OK`

## Manual
1. Download the suite from: `https://download.sysinternals.com/files/SysinternalsSuite.zip`
2. Extract the file to a directory, like `C:\Program Files\SysinternalsSuite`
3. Add the path to your PATH environment variable
    - Windows button + search "View Advanced System Settings" to bring up `System Properties`
    - Click `Environment Variables`
    - Find the variable `Path`, highlight it and click `Edit...`
    - Create a new entry with the absolute path of the directory sysinternals is saved in.
    - Click `OK`

# To do
- Learn how to use more specific tools like Sysmon, Process Monitor (registry keys), and AD Explorer for monitoring and debugging purposes

# Resources
- [Package Manager Installation](https://www.thomasmaurer.ch/2015/09/how-to-install-sysinternals-using-powershell-package-management/)
- [Process Monitor](https://www.howtogeek.com/school/sysinternals-pro/lesson5/)
