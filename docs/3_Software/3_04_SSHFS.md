# File access via SSHFS

SSHFS is a way to mount a remote file system over ssh. Under the hood it talks to 
the ssh/sftp daemon on the server and sends commands to download or upload files when
needed.

It is not a true network file system so you have to be careful not to change files
on both sides of the connection simultaneously. It does not offer any protection
against this, e.g., full or partial file locking. Modifying files directly on 
the server and on a mounted volume simultaneously will lead to unpredictable results.

On Linux, where it was first introduced, sshfs is a userspace file system. So one needs
tp first install a piece of software called [FUSE](https://www.kernel.org/doc/html/next/filesystems/fuse.html)
to support user space file systems, and then the software that provides sshfs. 
Implementations on other operating systems often follow a similar approach.

## In Windows (and therefore CygWin)

### SSHFS-Win

[SSHFS-Win](https://github.com/winfsp/sshfs-win) follows the same approach as the Linux implementation.

It first requires the installation of [WinFsp](https://winfsp.dev/)
or Windows File System Proxy, which has the same role as FUSE on Linux. It supports
all recent Windows versions and supports several APIs for implementing user space
file systems or port those from Linux.

After installing WinSfp, SSHFS-Win can be installed. Downloads are also
available from the [WinFsp download section](https://winfsp.dev/rel/) or you
can download from the [ sshfs-win GitHub](https://github.com/winfsp/sshfs-win/releases).

There are also GUI front ends available to help with creating the connections and drive 
mappings. One is [sshfs-win-manager](https://github.com/evsar3/sshfs-win-manager) which is 
a small project on GitHub. The other one is [SiriKali](https://mhogomchungu.github.io/sirikali/)
which supports multiple operating systems and several user space file systems.

**TODO: Check compatibility with keys.**

??? Links
    -   [WinFsp web site](https://winfsp.dev/)
    -   [WinFsp on GitHub](https://github.com/winfsp/winfsp)
    -   [sshfs-win on GitHub](https://github.com/winfsp/sshfs-win)


### Dokan

[Dokan](http://dokan-dev.github.io/) (GitHub: [dokan-dev](https://github.com/dokan-dev)) is a similar
project to SSHFS-Win that offers a FUSE wrapper and several userspace file systems running on top of it.
Installation is again done in two phases. At the time of writing, the dokan-sshfs component is without
maintainer and the installation information is not nearly as good as for SSHFS-Win.
Dokan used to be a popular implementation, but as it died it has been forked into Dokany and
now seems to be dying again.

First the Dokany wrapper is installed [following the installation instructions](https://github.com/dokan-dev/dokany/wiki/Installation).

Next [dokan-sshfs](https://github.com/dokan-dev/dokan-sshfs) can be installed.
At the time of writing there don't seem to be pre-built packages available.


### Commercial implementations

This list by no means aims to be complete.

-   [Mountain Duck](https://mountainduck.io/) is a package from the developers of
    CyberDuck that supports not only the sftp protocol (on which sshfs implementations
    are based) but also several cloud storage technologies, including S3. Contrary to
    CyberDuck it also allows to mount volumes and claims to use smart synchronization
    that also enables offline work. It supports both Windows and macOS.

-   [NetDrive](https://www.netdrive.net/) is a commercial package for Windows and macOS that does not
    only support SSHFS but can also mount several other types of cloud storage as if it is a local file
    system, including, e.g., S3. There is a personal version which is still relatively cheap, but the
    team version which is needed to offer full privacy also on multi-user PCs is rather expensive to
    academic standards.

-   [ExpanDrive](https://www.expandrive.com/) is a similar product that also supports several cloud storage
    solutions and supports not only Windows and macOS but even some Linux versions.

-   [/n software SFTP Drive](https://www.nsoftware.com/sftpdrive/) also supports Windows, macOS and Linux.

-   [CloudMounter](https://cloudmounter.net/mount-cloud-drive-win.html) is another package enabling mounting from an
    sftp server, and it too supports some other cloud storage technologies. It also exists in a version for macOS.


## In WSL

*Note: We only tested with WSL 2.*

As WSL will map all Windows drives into the Linux domain, one approach is to use a Windows client
as discussed in the previous section that maps an sshfs volume onto a drive letter.

However, in WSL 2 it is also possible to install [FUSE](https://www.kernel.org/doc/html/next/filesystems/fuse.html) 
to use userspace file systems and then install and run the regular Linux sshfs client.

Note however that at the time of writing of this text (June 2023) the
[sshfs project](https://github.com/libfuse/sshfs) is without maintainer, though there are
some forks in which further development seems to be happening. If no new maintainer is
found, it is rather likely that sshfs will be abandoned by Linux distributions as security bugs
are no longer fixed.

!!! Example "openSUSE Leap 15.4"
    E.g., in the openSUSE LEAP 15.4 distribution, installing fuse and sshfs was as simple as

    ```
    sudo zypper install sshfs
    ```

    Once installed, a mount point should be created, e.g.,

    ```
    mkdir -p /home/XXX/test_mount
    ```

    and the remote volume can be linked, e.g.,

    ```
    sshfs myuserid@myserver:/home/myuserid /home/XXX/test_mount -o follow_symlinks
    ```

