# Permission Denied Docker
*Author: Chris Morales*

**Summary:** This is a running list of solutions to the problem that occurs when trying to build a pipeline that uses Docker but then you get a permission denied when connecting to the socket error.


## Running Solutions

1. The simplest solution is that you just have to add the **jenkins** user to the **docker** group. *Note: This applies to the user who you're using to run a docker command under from the pipeline. In this case, my node registration had logged into a host under the jenkins user via SSH.*

```
    $ sudo usermod -aG docker <user>
```


2. If you already have agents connected and have made the above change **without** reconnecting to your agents from *Manage Jenkins*, then it will still give you the error. Why? It's because the connection is under one SSH session, when a user gets added to a group, there needs to be a **reload** to apply the groups. So, you can disconnect and relaunch the agent (reconnect) and the problem should be solved.


