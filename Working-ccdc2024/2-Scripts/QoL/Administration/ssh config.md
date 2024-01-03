# SSH Config Shortcut file

This works for both Linux and Windows. During normal administration, you'll likely want to get an SSH connection into a machine. Luckily there's an easy way to do this.

All you have to do is make a file named `config` under your SSH folder for the current user. No file extension needed.

## Making basic config file

The basic idea is that you have some _alias_ (denoted by `Host` in the config file) that you can refer to that contains specific details that you 
want to specify when connecting to a certain machine via SSH. 

The details contained can be simple or complex. But the common case is that you just SSH directly into a machine.

And so, some keywords that are typically used refer to: 
1) `HostName` - The target machine 
2) `User` - The _user_ of the target machine 

A sample is given:
```
Host j-server
  HostName 192.168.0.110
  User user
```

This means that I can run `ssh j-server` and it will automatically be translated to `ssh user@192.168.0.110`. 

It's even more handy when you use it for public key authentication. For the sample, I'll use `sample.pub` as the public key.

```
Host j-server
  HostName 192.168.0.110
  User user
  IdentityFile /some/path/.ssh/sample.pub
```
This would then be translated to `ssh -i /some/path/sample.pub user@192.168.0.110`
