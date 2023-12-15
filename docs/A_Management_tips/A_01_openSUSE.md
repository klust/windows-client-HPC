# Some openSUSE management tips

These tips are based on my personal setup. I hope the example may be inspiring.

Basically I use openSUSE in WSL2 and have enabled systemd so that the automounter can be used,
which makes it easier to also use [EESSI](https://EESSI.io). I use the same userid in WSL2
as in Windows and have changed my home directory to my Windows user directory. This does come
with a performance penalty. However, the personal directory that is created in `/home` still 
exists and is used for some files that are different between distributions anyway
(and for [setting up a connection to the Windows ssh agent](../../5_Issues/5_01_SSH_key_management/#using-the-windows-ssh-agent)).
I do store most files that cannot be easily regenerated in the Windows user diretories
though as that makes experimenting with WSL, which may destroy my setup, easier.

I've also set up the distribution to use WSLg so that GUI software can also run.

Using systemd and WSLg also implies that you need at least a recent version of Windows
10 or higher, with the Microsoft Store version of WSL2.

[Installation instructions for WSL are available on the Microsoft web pages](https://learn.microsoft.com/en-us/windows/wsl/install).


## Installation scripts

I have had to re-install my openSUSE distribution a few times already, also because I 
experiment a lot (also to write this documentation) or want to execute the instructions
again to make sure that no steps are forgotten in these notes. Hence I collect much of the
work in scripts to speed up rebuilding.

The instructions are also inspired by the
[openSUSE:WSL page in the opensuse.org wiki](https://en.opensuse.org/openSUSE%3AWSL),
[CernVM-FS (cvmfs) documentation](https://cvmfs.readthedocs.io/en/stable/cpt-quickstart.html)
and [EESSI documentation](https://www.eessi.io/docs/).

Basically I took the following steps when installing openSUSE:

-   In the setup program, I create a userid that is the same as my Windows userid,
    and I also use the same password to avoid confusion. 

    The option : Use this password for system administrator" is also left checked.

-   I run two install scripts that execute a lot of commands via `sudo`. This process is
    split in two steps as in between the openSUSE distribution has to be restarted to
    enable systemd.

    There are ways to enable systemd globally for all distributions but that option turned
    out to be rather dangerous as some distributions, including openSUSE Leap 15.4 which I
    used for the tests for this section, do not have the necessary setup right away to use
    systemd, leading to hanging distros.

    The first script does some updates, enabling systemd and autofs, and sets the home directory
    for the account calling the script to the corresponding Windows user directory:

    ``` bash
    #! /usr/bin/bash

    # Make the next one an empty variable if instead you prefer to run
    # the whole script in sudo mode. You then however also need to
    # change set the userid that should be edited in edituser
    SUDO='sudo'
    edituser="$USER"

    # Upgrade the already installed packages
    $SUDO zypper -n update

    # Some patterns that should be installed or are interesting to install
    # according to https://en.opensuse.org/openSUSE%3AWSL
    # These scripts try to make their own wsl.conf but as a symbolic link
    # to one they include and they don't play nice with each other.
    # Which is why we will regenerate our own in the next step.
    $SUDO zypper -n install -t pattern wsl_systemd
    $SUDO /bin/rm /etc/wsl.conf
    $SUDO zypper -n install -t pattern wsl_base
    $SUDO /bin/rm /etc/wsl.conf
    $SUDO zypper -n install -t pattern wsl_gui
    $SUDO /bin/rm /etc/wsl.conf

    # Enable systemd (will only work after a reboot)
    $SUDO bash -c "echo -e '[boot]\nsystemd=true' >/etc/wsl.conf"

    # Enable autofs.service
    $SUDO systemctl enable autofs.service

    # Set the home directory of my account to the one on Windows
    $SUDO sed -i -e "s|/home/$edituser|/mnt/c/Users/$edituser|" /etc/passwd

    # Give a message about the needed restart
    echo -e "Now reboot WSL2 or at least this distribution to enable systemd, e.g.," \
            "\nwsl.exe --shutdown" \
            "\nor more selectively" \
            "\nwsl.exe --terminate $WSL_DISTRO_NAME"

    ```

    After this, the second script installs a few more packages (you may have a very different
    choice) and also installs and configures CernVM-FS so that EESSI becomes available in
    `/cvmfs/software.eessi.io`. As the automounter is used, the `cvmfs_config wsl2_start`
    command mentioned in the CernVM-FS manual is not needed.

    ``` bash
    #! /usr/bin/bash
    #
    # Note that this script assumes systemd is running.
    #

    # Make the next one an empty variable if instead you prefer to run
    # the whole script in sudo mode. 
    SUDO='sudo'

    # socat to get access to the SSH agent of Windows
    $SUDO zypper --non-interactive install -n socat

    # Git
    $SUDO zypper --non-interactive install git

    # VIM colorschemes
    $SUDO zypper --non-interactive install vim-plugin-colorschemes

    # Newer Python. For OpenSUSE 15 SP4 this is Python 3.9 or Python 3.11
    $SUDO zypper --non-interactive install python311

    # Something to test if the X server is recognised
    $SUDO zypper --non-interactive install xdpyinfo

    #
    # Setting up EESSI
    #
    cvmfs_version='2.11.2'
    config_version='2.1-1'
    $SUDO zypper --no-gpg-checks --non-interactive install \
        https://ecsft.cern.ch/dist/cvmfs/cvmfs-config/cvmfs-config-default-$config_version.noarch.rpm \
        https://ecsft.cern.ch/dist/cvmfs/cvmfs-$cvmfs_version/cvmfs-$cvmfs_version-1.sle15.x86_64.rpm \
        https://ecsft.cern.ch/dist/cvmfs/cvmfs-$cvmfs_version/cvmfs-libs-$cvmfs_version-1.sle15.x86_64.rpm

    # Create /etc/cvmfs/default.local
    $SUDO bash -c "echo 'CVMFS_CLIENT_PROFILE="single"'  > /etc/cvmfs/default.local"
    $SUDO bash -c "echo 'CVMFS_HTTP_PROXY="DIRECT"'     >> /etc/cvmfs/default.local"
    $SUDO bash -c "echo 'CVMFS_QUOTA_LIMIT=2500'        >> /etc/cvmfs/default.local"

    # Run the setup
    $SUDO cvmfs_config setup

    # Not sure if the next one is already needed on OpenSUSE on WSL2:
    # Uncomment the line #+dir:/etc/auto.master.d/ in the file /etc/auto.master
    $SUDO sed -i 's%#+dir:/etc/auto.master.d%+dir:/etc/auto.master.d%' /etc/auto.master
    $SUDO systemctl restart autofs

    # Already create /opt/eessi for EESSI even though we do not yet use it
    $SUDO mkdir -p /opt/eessi
    ```

??? Note "SUSE patterns"
    The patterns are supposed to install necessary software for some additional functionality and
    set up links, configuration files, etc. 

    Some information about the WSL patterns used in the above scripts:

    -   [On build.opensuse.org](https://build.opensuse.org/package/view_file/openSUSE:Factory/patterns-wsl/patterns-wsl.spec)

    -   [In a GitHub repository](https://github.com/sbradnick/patterns/blob/wsl/SPECS/patterns-wsl.spec)

    It looks like the `wsl_systemd` pattern tries to remove a command from the commands that
    automatically execute at startup, but it doesn't do so in a robust way as it would be added
    again if one of the other patterns is installed later, and as there are some troubles with
    `wsl.conf` being linked to the actual file rather than a copy, which is why we chose to
    create `/etc/wsl.conf` by hand.
