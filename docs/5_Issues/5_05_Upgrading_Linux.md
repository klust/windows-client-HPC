# Upgrading Linux in WSL

## Ubuntu

-   It is best to first make sure that your current Ubuntu is up-to-date:

    ```bash
    sudo apt update
    sudo apt dist-upgrade
    ```

    Some sources tell to use `sudo apt upgrade -y`, CHECK!

-   It may be a good moment for some clean-up:

    ```bash
    sudo apt --purge autoremove
    ```

-   The actual release policy is set in `/etc//update-manager/release-upgrades`.
    Edit this file (using an editor via the `sudo` command) to change the policy
    if desired.

-   To initiate the actual upgrade, run

    ```bash
    sudo do-release-upgrade -d
    ```

    The `-d` option turned out to be essential though many sources don't mention it.
    Without it the `do-release-upgrade` command failed to recognise that there was a
    new version of Ubuntu available on my system.

    You will be asked a few questions during the process about how to proceed. 
    `y` is most of the time a suitable answer.

    Note that on WSL2 (and I guess WSL also) you will see an error message when 
    Ubuntu tries to restart at the end of the process as the Linux infrastructure that
    is used for that is not supported on WSL/WSL2. You'll have to leave all Ubuntu sessions
    and it may even be a good idea to simply restart Windows.
