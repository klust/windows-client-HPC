# Fedora Remix

These tips are based on my personal setup. I hope the example may be inspiring.

[Fedora Remix](https://www.whitewaterfoundry.com/fedora-remix-for-wsl)
is a Fedora distribution offered through the Microsoft Store by
[Whitewater Foundry](https://www.whitewaterfoundry.com/), a company
specialising in Linux distributions for WSL.

The setup I have for Fedora is similar to the setup I use for openSUSE. 
I enabled systemd at all time so that the automounter can be used,
which makes it easier to also use [EESSI](https://EESSI.io). I use the same userid in WSL2
as in Windows and have changed my home directory to my Windows user directory. This does come
with a performance penalty. However, the personal directory that is created in `/home` still 
exists and is used for some files that are different between distributions anyway
(and for [setting up a connection to the Windows ssh agent](../../5_Issues/5_01_SSH_key_management/#using-the-windows-ssh-agent)).
I do store most files that cannot be easily regenerated in the Windows user diretories
though as that makes experimenting with WSL, which may destroy my setup, easier.

WSLg is also supported. Note that the use of systemd (and WSLg) requires a
recent version of Windows 10 or higher with the Microsoft Store version of WSL2.

[Installation instructions for WSL are available on the Microsoft web pages](https://learn.microsoft.com/en-us/windows/wsl/install).


## Installation scripts

I have had to re-install my Fedora distribution a few times already, also because I 
experiment a lot (also to write this documentation) or want to execute the instructions
again to make sure that no steps are forgotten in these notes. Hence I collect much of the
work in scripts to speed up rebuilding.

The instructions are also inspired by the
[CernVM-FS (cvmfs) documentation](https://cvmfs.readthedocs.io/en/stable/cpt-quickstart.html)
and [EESSI documentation](https://www.eessi.io/docs/).

Basically I took the following steps when installing Fedora Remix:

-   In the setup program that is run when Fedora is started for the first time, 
    I create a userid that is the same as my Windows userid,
    and I also use the same password to avoid confusion. 

-   I run an install script that execute a lot of commands via `sudo`. At the end a restart
    is needed to ensure that changes take effect and a new session with systemd running
    is started. After the reboot the automounter should be working so that you get 
    direct access to, e.g., EESSI.

    ``` bash
    #! /usr/bin/bash

    # Make the next one an empty variable if instead you prefer to run
    # the whole script in sudo mode. You then however also need to
    # change set the userid that should be edited in edituser
    SUDO='sudo'
    edituser="$USER"

    # Upgrade the already installed packages
    $SUDO dnf --assumeyes update

    # Ensure systemd is always used, independent of the options chosen
    # when starting the first Fedora Remix session.
    # If you are running without systemd, you'll have to restart which
    # is done at the end of the script.
    $SUDO bash -c "echo -e '\n[boot]\nsystemd=true' >>/etc/wsl.conf"

    # Set the home directory of my account to the one on Windows
    $SUDO sed -i -e "s|/home/$edituser|/mnt/c/Users/$edituser|" /etc/passwd

    #
    # Setting up EESSI
    #
    # Note that this will actually pull in the autofs service as a dependency
    #
    cvmfs_version='2.11.2'
    fedora_version='38'
    config_version='2.1-1'
    $SUDO dnf --assumeyes install \
        https://ecsft.cern.ch/dist/cvmfs/cvmfs-$cvmfs_version/cvmfs-$cvmfs_version-1.fc$fedora_version.x86_64.rpm \
        https://ecsft.cern.ch/dist/cvmfs/cvmfs-config/cvmfs-config-default-$config_version.noarch.rpm \
        https://ecsft.cern.ch/dist/cvmfs/cvmfs-$cvmfs_version/cvmfs-libs-$cvmfs_version-1.fc$fedora_version.x86_64.rpm

    # Create /etc/cvmfs/default.local
    $SUDO bash -c "echo 'CVMFS_CLIENT_PROFILE="single"'  > /etc/cvmfs/default.local"
    $SUDO bash -c "echo 'CVMFS_HTTP_PROXY="DIRECT"'     >> /etc/cvmfs/default.local"
    $SUDO bash -c "echo 'CVMFS_QUOTA_LIMIT=2500'        >> /etc/cvmfs/default.local"

    # Run the setup
    $SUDO cvmfs_config setup

    # Already create /opt/eessi for EESSI even though we do not yet use it
    $SUDO mkdir -p /opt/eessi

    # Enable autofs.service so that it is started after the next 
    # reboot.
    $SUDO systemctl enable autofs.service

    #
    # End of EESSI setup
    #

    #
    # Install some other useful tools
    #

    # socat to get access to the SSH agent of Windows
    $SUDO dnf --assumeyes install socat

    # Git
    $SUDO dnf --assumeyes install git

    # Need Python 3.11 as not all packages already support 3.12.
    $SUDO dnf --assumeyes install python3.11

    # Something to test if the X server is recognised
    $SUDO dnf --assumeyes install xdpyinfo

    # Give a message about the needed restart to ensure all settings take
    # effect.
    echo -e "Now reboot WSL2 or at least this distribution to enable systemd, e.g.," \
            "\nwsl.exe --shutdown" \
            "\nor more selectively and from the Fedora shell" \
            "\n/mnt/c/Windows/system32/wsl.exe --terminate $WSL_DISTRO_NAME"
    ```
    There are ways to enable systemd globally for all distributions but that option turned
    out to be rather dangerous as some distributions, including openSUSE Leap 15.4 which I
    used for the tests for this section, do not have the necessary setup right away to use
    systemd, leading to hanging distros.

The default `/etc/wsl.conf` file suggests there might be a way to get the automounter
working without systemd, but I haven't found out how yet. That would also enable 
CernVM-FS to work without having to run `cvmfs_config wsl2_start` each time Fedora Remix
is restarted.
