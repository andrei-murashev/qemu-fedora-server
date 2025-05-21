<div style="display: flex; justify-content: space-between; align-items: center;">
  <h1 style="margin: 0;">QEMU Fedora Server (x86_64)</h1>
  <span style="vertical-align: middle;">
    <img src="https://img.shields.io/github/stars/andrei-murashev/qemu-fedora-server?style=flat&color=yellow&label=Stars" alt="GitHub Stars" width="100"/>
  </span>
</div>


<br>


A collection of scripts, which are small, simple, and configurable, for setting
up and running a Fedora Linux Server x86_64 virtual machine using QEMU.

## Usage
### Scripts
- Run `make-new.sh` to get the latest Fedora Server QCOW image.

- Run (and edit to your liking) `configure.sh` to apply pre-first-boot options 
to the image.

- Run (and edit to your liking) `launch.sh` to launch a configured QEMU virtual 
machine of Fedora Server.

<br>

### Additional required programs (non-GNU/Linux and non-POSIX)
| Programs                      | Link                                         |
| :---------------------------- | :------------------------------------------- |
| `chromium-browser` (headless) | https://www.chromium.org/Home/
| `curl`                        | https://curl.se/
| `mkpasswd`                    | https://fossies.org/linux/whois/mkpasswd.c
| `openssl`                     | https://openssl-library.org
| `qemu-system-x86-64`          | https://www.qemu.org/docs/master/system/target-i386.html
| `qemu-img`                    | https://qemu-project.gitlab.io/qemu/tools/qemu-img.html
| `virt-customize`              | https://libguestfs.org/virt-customize.1.html