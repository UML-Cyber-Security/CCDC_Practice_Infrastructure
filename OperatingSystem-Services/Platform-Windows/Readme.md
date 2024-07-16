# Windows

Originally I was trying to make all of the documentation textbook style, in Latex. However this is hard to quickly search, edit, and improve on. I think it makes more sense to have many small markdown documents than one large latex PDF.

> [!NOTE]
> Be careful with this documentation, make sure you know what you are doing before making changes as some may affect the services on the machine. Additionally we need to be mindful of the Black Team infrastructure which may use SSH tunnels.

## Organization
This folder will contain documentations relating to any services that will be ran solely on a *Windows* system, mainly focusing on popular windows services such as Active Directory, Domain Controllers and Certificate Authorities. This will also contain documentation focusing on the hardening of Windows systems.  The organization may vary, but generally services will each be in their own directory, and if there are multiple services capable of doing the same thing they will be contained in a directory named after their category of service.

We will push any Powershell scripts into the [0-Scripts](./0-Scripts/) directory and any Ansible playbooks into the [1-Ansible](./1-Ansible/) directory.