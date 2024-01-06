# OSCAP setup for Alpine Linux

Currently, openscap is only available in the testing branch for apk. We need to enable it.

**oscap might not be stable enough to build on Alpine yet.

`setup-apkrepos`
select `e` in the CLI menu to edit the repositories with a text editor

Uncomment the following lines:
- `testing`
- `/edge/community`
- `/edge/main`

Update the repos:

`apk update`

`apk add openscap`


## Current issues:

Once installed, attempting to run `oscap` results in the following errors: 

`Error relocating /usr/lib/librpm.so.9: secure_getenv: symbol not found`

`Error relocating /usr/lib/librpmio.so.9: secure_getenv: symbol not found`