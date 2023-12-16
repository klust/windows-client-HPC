# Running a cluster software stack on Windows with EESSI

The goal of [the EESSI project](https://www.eessi-hpc.org/) is to 
make a full software stack available with binaries optimised for 
several popular architectures via a read-only web based file
system. So software is served on demand and does not require
installing the complete stack on your PC.

To this end it uses the so-called CernVM-FS file system. This requires
the installation of some additional software in WSL 2 that 
does not come from the standard software libaries. 
WSL 2 also for a long time did not support the mechanisms that are
needed to start the file system daemons automatically so a manual 
intervention may be needed each time you restart WSL 2. 

At the time of writing of the last revision (December 2023), EESI is still
very much in a prototype phase. However, it got some funding through
the EuroHPC Centre of Excellence MultiXScale for further development so the speed
may pick up a little.
The [EESSI documentation](https://www.eessi.io/docs/) was outdated and did not
yet cover the new setup that requires far fewer steps to get CernVM-FS working,
so the instructions below are the result of some experimenting als.

Getting it to work (without using a container, which would also
require installing additional software in most if not all WSL Linux
distributions) does require an initial effort.


## Example: Setup on OpenSUSE in WSL2

*Last update: 16 December 2023*

The ["Getting Started" section of the CernVM-FS manual](https://cvmfs.readthedocs.io/en/stable/cpt-quickstart.html)
unfortunately does not contain instructions for SUSE Linux.
There are relevant files though in the [CVMFS repository @ CERN](https://ecsft.cern.ch/dist/cvmfs/).
In particular, look for the files in the newest `cvmfs-*` subdirectory and the
`cvmfs-config` subdirectory.

This setup is for openSUSE 15 (tested with 15.4) on WSL2 with systemd enabled so
that the automounter can be used and so that it is no longer needed to call
`cvmfs_config wsl2_start` every time the openSUSE distribution in WSL is restarted.

-   Ensure you have a openSUSE WSL2 setup with systemd and autofs enabled and 
    running.

    -   Ensure that the `wsl_systemd` pattern is installed to fully enable systemd:

        ``` bash
        sudo zypper install -n -t pattern wsl_systemd
        ```

        There are [other useful patterns](https://en.opensuse.org/openSUSE:WSL)
        also and they do not always play nice with updating `/etc/wsl.conf`...

    -   Ensure that `/etc/wsl.conf` exists and that the `[boot]` section contains the 
        line `systemd=true`. The minimal such file would be

        ``` text
        [boot]
        systemd=true
        ```

    -   Right now it is time to restart the openSUSE WSL2 distribution, e.g., 
        from a normal bash command line:

        ``` bash
        wsl.exe --terminate $WSL_DISTRO_NAME
        ```

        or from powershell (terminating all WSL2 distros)

        ``` text
        wsl --shutdown
        ```

-   Similarly to what is done on Fedora, install directly from this repository.

    ``` bash
    version='2.11.2'
    sudo zypper --no-gpg-checks install \
        https://ecsft.cern.ch/dist/cvmfs/cvmfs-config/cvmfs-config-default-2.1-1.noarch.rpm \
        https://ecsft.cern.ch/dist/cvmfs/cvmfs-$version/cvmfs-$version-1.sle15.x86_64.rpm \
        https://ecsft.cern.ch/dist/cvmfs/cvmfs-$version/cvmfs-libs-$version-1.sle15.x86_64.rpm
    ```

    (You'll have to check the version of `cvmfs-config-default` also, there is a `-latest` version
    but when checking this was actually a rather old file.)

-   Note that it is no longer needed to install the EESSI configuration file for CernVM-FS
    (`cvmfs-config-eessi-latest.noarch.rpm`) as the new EESSI repository is included in
    the configurations of CVMFS.

-   Create (you'll have to run in a bash shell as root or run the editor using `sudo`) the file
    `/etc/cvmfs/default.local`. If you're experimenting on a workstation with no nearby cache 
    server for CernVM-FS, then the following would be appropriate:

    ``` text
    CVMFS_CLIENT_PROFILE="single"
    CVMFS_HTTP_PROXY="DIRECT"
	CVMFS_QUOTA_LIMIT=10000
    ```

    or with bash commands:

    ``` bash
    sudo bash -c "echo 'CVMFS_CLIENT_PROFILE="single"'  > /etc/cvmfs/default.local"
    sudo bash -c "echo 'CVMFS_HTTP_PROXY="DIRECT"'     >> /etc/cvmfs/default.local"
    sudo bash -c "echo 'CVMFS_QUOTA_LIMIT=10000'       >> /etc/cvmfs/default.local"
    ```

    Ensure everybody has read access to the file.

-   Run the setup of cvmfs:

    ``` bash
    sudo cvmfs_config setup
    ```

-   Now edit `/etc/auto.master` and uncomment the line
    `#+dir:/etc/auto.master.d/`. E.g.,

    ``` bash
    sudo sed -i 's%#+dir:/etc/auto.master.d%+dir:/etc/auto.master.d%' /etc/auto.master
    ```

-   Enable and start the autofs service:

    ``` bash
    sudo systemctl enable autofs.service
    sudo systemctl start autofs
    ```

    Or restart the autofs service if it was alreadyt present so that the above change takes effect:
  
    ``` bash
    sudo systemctl restart autofs
    ```

-   You should now be able to go into the `/cvmfs/software.eessi.io` subdirectory even if it is
    not shown immediately if you do an `ls` in `/cvmfs` as it will only be mounted on access.

-   You can now make EESSI available in a shell with

    ```
    source /cvmfs/software.eessi.io/versions/2023.06/init/bash
    ```


## Useful links

-   [EESSI web page](https://eessi.io)

-   [EESSI documentation](https://www.eessi.io/docs/)

-   [EESSI YouTube channel](https://www.youtube.com/@eessi_community)

-   MultiXscale Center of Excellence:

    -   [Home page](https://www.multixscale.eu/)

    -   [YouTube channel](https://www.youtube.com/@MultiXscale)

