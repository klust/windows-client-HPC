# Upgrading Linux in WSL

## Ubuntu

-   It is best to first make sure that your current Ubuntu is up-to-date:

    ```bash
    sudo apt update
    sudo apt full-upgrade
    ```

    You can optionally add the `-y` command line flag to the last command to automatically
    assume the answer "yes" to all questions asked during the process.

    The `apt update` command downloads package information from all configured sources that is 
    used by other `apt` commands. The `apt full-upgrade` command install available upgrades of 
    all packages currently installed on the system, installs new ones as required but also
    removes currently installed packages if this is needed to upgrade the system as a whole.

-   It may be a good moment for some clean-up:

    ```bash
    sudo apt --purge autoremove
    ```

    This command will remove packages that were automatically installed to satisfy
    dependencies for other packages and are now no longer needed as dependencies changed
    or the package(s) needing them were removed in the meantime.

    It may remove more than you like though as some software that came in as a dependency
    of explicitly installed packages may still be used by itself. See the 
    [manual pages of the `apt` command](https://manpages.ubuntu.com/manpages/xenial/man8/apt.8.html)
    on how to deal with this.

-   The actual release policy is set in `/etc/update-manager/release-upgrades`.
    Edit this file (using an editor via the `sudo` command) to change the policy
    if desired. If Ubuntu was installed via the Windows store, this should be set
    to only installing LTS versions, but you can change this at your own risk.

-   To initiate the actual upgrade, run

    ```bash
    sudo do-release-upgrade -d
    ```

    The `-d` option (which tells to use the latest development release) 
    turned out to be essential though many sources don't mention it.
    Without it the `do-release-upgrade` command failed to recognise that there was a
    new version of Ubuntu available when I tested the procedure. It might be because I tested too 
    early. The new release of Ubuntu was already available in the Windows store but 
    it might not have been marked yet for general distribution via the upgrade
    mechanism.
    (See also [the `do-release-upgrade` manual page](http://manpages.ubuntu.com/manpages/bionic/man8/do-release-upgrade.8.html))

    You will be asked a few questions during the process about how to proceed. 
    `y` is most of the time a suitable answer.

    Note that on WSL2 (and I guess WSL also) you will see an error message when 
    Ubuntu tries to restart at the end of the process as the Linux infrastructure that
    is used for that is not supported on WSL/WSL2. You'll have to leave all Ubuntu sessions
    and it may even be a good idea to simply restart Windows.
