# SSH key management

Windows does come with a ssh key agent service. However, in recent
versions of Windows 10, it is disabled by default. To enable it,

1.  Open the "Services" app in administrator mode

2.  Look for "OpenSSH Authentication Agent" in the list of services and
    right-click to open the "Properties" dialog box.

3.  Make sure the startup-type is set to "automatic" which will ensure
    that the service will start the next time Windows is booted.

4.  It should also be possible to start the service now from the same
    dialog box.

Keys can then be added from PowerShell using the regular
"ssh-add"-command.

There is a caveat however. The ssh agent service is not found from WSL.
Solutions:

-   WSL 1: A piece of software called
    "[wsl-ssh-agent](https://github.com/rupor-github/wsl-ssh-agent)" can
    be used to connect WSL 1 sessions to the ssh agent service in
    Windows.

-   WSL 2: Here a different approach has to be taken, using socat (which
    you may need to install in your Linux distribution) and a Windows
    program, [npiperelay.exe](https://github.com/jstarks/npiperelay),
    that needs to be installed on a Windows file system (as Windows must
    be able to run the program).\
    This should be set up in your .bash_profile or .bashrc (I do so in
    .bash_profile as that is the typical place to set environment
    variables):

+-----------------------------------------------------------------------+
| export SSH_AUTH_SOCK=/home/\$USER/agent.sock.\$WSL_DISTRO_NAME        |
|                                                                       |
| ss -a \| grep -q \$SSH_AUTH_SOCK                                      |
|                                                                       |
| if \[ \$? -ne 0 \]; then                                              |
|                                                                       |
| rm -f \$SSH_AUTH_SOCK                                                 |
|                                                                       |
| ( setsid socat UNIX-LISTEN:\$SSH_AUTH_SOCK,fork                       |
| EXEC:\"\$HOME/winhome/.wsl/npiperelay.exe -ei -s                      |
| //./pipe/openssh-ssh-agent\",nofork & ) \>/dev/null 2\>&1             |
|                                                                       |
| fi                                                                    |
+=======================================================================+
+-----------------------------------------------------------------------+

(note that lines 5, 6 and 7 should in fact be a single line in your
.bash_profile). There are a few caveats:

-   SSH_AUTH_SOCK points to the socket that will be used to communicate
    with the ssh agent. In most WSL distributions, this should be on an
    internal Linux file system. So in case you use your Windows home
    directory also as the home directory in your WSL distribution, you
    should not put the socket there. This is why /home/\$USER is used
    rather than \$HOME. Also, if you have multiple Linux distributions
    in WSL, it is important that the socket has a different name for
    each distribution as otherwise one distribution will try to talk to
    a socket in a different distribution. At first this may seem
    possible since all distributions run in the same virtual machine,
    but they have different user spaces so that does not work.

-   The second line tests if there is already an socat process managing
    that socket.

-   The crucial line is the setid socat line:

    -   The Windows ssh agent works with Windows named pipes, and WSL
        programs cannot directly talk to those. This is where
        npiperelay.exe comes in. It acts as the translator between Linux
        sockets and the Windows named pipe.

    -   The socat process listens at the Linux site. Whenever ssh
        contacts the socket, it starts npiperelay.exe to talk to the
        Windows named pipe. The npiperelay.exe process is started with
        options that will terminate it after the command from the ssh
        process.

    -   The path specified for the npiperelay.exe command is the path as
        seen by the Linux distribution.

    -   The setsid command is used to start it in a separate session so
        that it continues running if the current Linux session is
        terminated, to be picked up again when you start a new shell in
        that distribution.

At the moment of writing, this process was tested and works in Fedora
35, OpenSUSE 15 SP3 and Ubuntu 20.4.3 LTS. However, Ubuntu 20.4 has a
different problem that even seems to occur running the regular ssh-agent
as soon as an IdentityFile line with IdentitiesOnly is added to the
.ssh/config file for the host and the key that is used there is a
symbolic link to the actual key. And this in turn seems to be related to
a permissions problem in WSL when using a Windows file system: It is not
possible to set the permissions on the links themselves to 700 while
that seems to be needed for the Ubuntu ssh client (according to a web
search on possible causes). In general, the mapping between users and
groups on the WSL side and on the Windows side seems to differ between
distributions and can be the cause of problems.

Some good sources of information on this procedure:

-   [The wsl-ssh-agent
    github](https://github.com/rupor-github/wsl-ssh-agent) mentions it
    as the alternative for WSL2.

-   ["Forwarding SSH agent requests from WSL to Windows" on
    stuartleeks.com](https://stuartleeks.com/posts/wsl-ssh-key-forward-to-windows/)
    is a slightly more complicated version of this procedure that
    prevents accidentally starting more socat processes than needed.

-   ["Using SSH on Windows 10 and WSL 2" on
    markramige.com](https://markramige.com/posts/using-ssh-on-windows-10-and-wsl-2/)
    is a page that explains the whole process of setting up the Windows
    OpenSSH implementation and integrating it with WSL.
