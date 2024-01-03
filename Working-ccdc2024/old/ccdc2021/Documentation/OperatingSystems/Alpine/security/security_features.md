# Alpine Linux security features

## Security Analysis

vocab:
- `C standard library`: Library of functions. From OS services and memory management to string manipulation. Used across many computer systems.
- `glibc`: GNU Project's implementation of C standard library. Most commonly used.
- `musl`: Lightweight and security oriented implementation of the C standard library
- `undefined behaviour`: Result of compiling code which has no meaning in C. Resulting code generation is up to the implementation of the compiler. This is dangerous and is where most attackers are able to gain leverage against a victim.
- `Position-independent-executable (PIE)`: Machine code that can operate correctly despite of absolute address


### Using `musl` in place of `glibc`

Aside from being more lightweight, `musl` does some important things better than `glibc`.
- Reports failure or prevents failure altogether on case of resource exhaustion, as opposed to `glibc` which will abort/crash and crash on some scenarios. Less failures are less leverage for attackers .
- uses `malloc` less often to reduce possibility of memory exhaustion
- Is built to avoid as much undefined behaviour as much as possible
- safe `UTF-8` decoder, so malicious characters aren't passed around
- heap corruption detection

### Init system
- Uses `OpenRC` instead of `systemd`.
    - systemd is extremely bloated, therefore has a larger attack surface

### Package manager
- userspace binaries are compiled as PIE with stack smashing protection. 

### Hardened kernel

- kernel used to include grsecurity and PaX patchsets when they were publically available.
- Apline Linux currently provides three kernels optimized for different use cases:
  - linux-vanilla: 	for most use cases
  - linux-virt:		optimized to run as a gues
  - linux-rpi:		optimized to run on a Raspberry Pi
  - [info source](https://wiki.alpinelinux.org/wiki/Kernels) | [kernel source](https://git.alpinelinux.org/aports/tree/main/linux-vanilla)
- The kernel package relies on the longterm releases of kernel 4.x, as evidenced by their [git log](https://git.alpinelinux.org/aports/log/main/linux-vanilla)

### Known Vulnerabilities

- certain versions of the Alpine Linux Docker image are subject to privilege escalation attacks:
  - v3.5
  - v3.4
  - v3.3
- See below link for fix, or better yet, use a different version of the Docker image.

[Source from aplinelinux.org](https://alpinelinux.org/posts/Docker-image-vulnerability-CVE-2019-5021.html) | [CVE-2019-5021](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-5021)

- The cause of this vulnerability was the default inclusion of a passwordless root login without regard for the use of linux-pam and other non-default authentication mechanisms that rely on `/etc/shadow`

### Resources:
https://wiki.musl-libc.org/functional-differences-from-glibc.html

https://www.etalabs.net/compare_libcs.html

https://alpinelinux.org/about/


### Todo:

Find details about how kernel is hardened
