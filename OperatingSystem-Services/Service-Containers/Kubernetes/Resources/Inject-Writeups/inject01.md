# Service
Simple Static Web server hosted on Kubernetes [Easy]

(If you know what you are doing)
**Time**: 15 minutes

(If you do not know what you are doing)
**Time**: 1-2 Hours

## Expectations 

- A Deployment with Replicas set to atleast 2 for an apache or nginx image.
- A Loadbalancer (probably metalLB) that has been properly set up so the webserver is accessible outside.
- They should provide the IP to reach the website at.

## Dependencies

- You could delete one of the following peices and see if they notice,
  - Deployment itself
    - kubectl get deployments
    - kubectl delete deployment
  - Service associated with it
    - kubectl get services
    - kubectl delete <service>
  - Change the label associated with the service and deployment so they do not properly match
  - Anything further would be toxic at this stage

## Inject

You have been tasked with getting a basic web server operational for the company. You are simply working on getting the infastructure set up, so you do not need to worry about what the web server contains as the frontend team will take that over. For this task, it is assumed you already have a deployed cluster with at least 2 worker nodes. Your requirements are the following,

1. If one of the machines hosting the website went offline, the website should still be accessible even if it was running on that machine.
2. The website will end up serving outside clients, so it must be accessible with an external IP address.
3. At this time, you do not have to worry about keeping any data the website stores, it will simply be providing static content.