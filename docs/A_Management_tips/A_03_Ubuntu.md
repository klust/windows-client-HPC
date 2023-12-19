# Ubuntu

These tips are based on my personal setup. I hope the example may be inspiring.

Ubuntu is the default Linux distribution for WSL2 and certainly the one
recommended by Microsoft. Support in CernVM-FS is certainly better than
for openSUSE or Fedora, and should include automatic updating.
In general though more commands are needed to set up an Ubuntu system
than a Fedora or openSUSE system on WSL2 and I also experience more problems
to get, e.g., access to the Windows ssh agent working.

The setup I have for Ubuntu is similar to the setup I use for openSUSE and Fedora. 
I enabled systemd at all time so that the automounter can be used,
which makes it easier to also use [EESSI](https://EESSI.io). I use the same userid in WSL2
as in Windows and have changed my home directory to my Windows user directory. This does come
with a performance penalty. However, the personal directory that is created in `/home` still 
exists and is used for some files that are different between distributions anyway
(and for [setting up a connection to the Windows ssh agent](../../5_Issues/5_01_SSH_key_management/#using-the-windows-ssh-agent)).
I do store most files that cannot be easily regenerated in the Windows user diretories
though, as that makes experimenting with WSL, which may destroy my setup, easier.

WSLg is also supported. Note that the use of systemd (and WSLg) requires a
recent version of Windows 10 or higher with the Microsoft Store version of WSL2.

[Installation instructions for WSL are available on the Microsoft web pages](https://learn.microsoft.com/en-us/windows/wsl/install).


## Installation scripts

I have had to re-install my Ubuntu distribution a few times already, also because I 
experiment a lot (also to write this documentation) or want to execute the instructions
again to make sure that no steps are forgotten in these notes. Hence I collect much of the
work in scripts to speed up rebuilding.

The instructions are also inspired by the
[CernVM-FS (cvmfs) documentation](https://cvmfs.readthedocs.io/en/stable/cpt-quickstart.html)
and [EESSI documentation](https://www.eessi.io/docs/).

Basically I took the following steps when installing Ubuntu:

-   In the setup program that is run when Ubuntu is started for the first time, 
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

    # Update the package list and then do a full upgrade of the default packages
    $SUDO apt update
    $SUDO apt --assume-yes full-upgrade

    # Ensure systemd is always used, independent of the options chosen
    # when starting the first Ubuntu session.
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

    #
    # Install cfmfs-release-latest_all.deb
    # This will add some cern repos to the list that ap will search.
    #
    pushd /tmp
    wget https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest_all.deb
    $SUDO dpkg -i cvmfs-release-latest_all.deb
    rm -f cvmfs-release-latest_all.deb
    popd

    #
    # Now install cvmfs
    # But don't forget to first pull in data from the repos that we have
    # added in the previous step.
    #
    $SUDO apt update
    $SUDO apt --assume-yes install cvmfs
    # Note: I did get an error while processing openssh-server.
    # This doesn't seem to be needed though.

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
    # I don't want an ssh server running for now
    #
    $SUDO systemctl disable ssh.service

    #
    # Install some other useful tools
    #

    # socat to get access to the SSH agent of Windows
    $SUDO apt --assume-yes install socat

    # Git
    $SUDO apt --assume-yes install git

    # Need Python 3.11 (the distribution I tested on took 3.8 as the default).
    # Wee needed to install it from "deadsnakes PPA"
    $SUDO apt --assume-yes install software-properties-common -y
    $SUDO add-apt-repository --yes --update ppa:deadsnakes/ppa
    $SUDO apt --assume-yes install python3.11

    # Tools for building software
    $SUDO apt --assume-yes install make

    # Some cleanup
    $SUDO apt --assume-yes autoremove

    # Give a message about the needed restart to ensure all settings take
    # effect.
    echo -e "Now reboot WSL2 or at least this distribution to enable systemd, e.g.," \
            "\nwsl.exe --shutdown" \
            "\nor more selectively and from the Ubuntu shell" \
            "\nwsl.exe --terminate $WSL_DISTRO_NAME"
    ```

    There are ways to enable systemd globally for all distributions but that option turned
    out to be rather dangerous as some distributions, including openSUSE Leap 15.4 which I
    used for the tests for this section, do not have the necessary setup right away to use
    systemd, leading to hanging distros.

