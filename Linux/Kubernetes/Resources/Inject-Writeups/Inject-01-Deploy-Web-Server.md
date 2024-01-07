# Inject 01 Deploy Web Server

## Task

You have been tasked with getting a basic web server operational for the company. You are simply working on getting the infastructure set up, so you do not need to worry about what the web server contains as the frontend team will take that over. For this task, it is assumed you already have a deployed cluster with at least 2 worker nodes. Your requirements are the following,

1. If one of the worker nodes goes offline, the website should still be accessible even if it was running on that node.
2. The website will end up serving outside clients, so it must be accessible with an external IP address.
3. At this time, you do not have to worry about keeping any data the website stores, it will simply be providing static content.


---

**Below should not be included when giving this inject out**

## What this inject requires

- CNI (Container Network Interface, probaly Calico)
- Deployment with Replicas set to atleast 2
- Loadbalancer (probably metalLB)