# Command line access via ssh

There are two ways to gain command line access to supercomputers through
ssh:

-   Use terminal software with built-in ssh support

-   Use regular terminal software that gives you a shell on Windows
    (PowerShell, CygWin shell or a Windows Subsystem for Linux shell,
    see also the section on creating a linux-like environment on
    Windows) with a linux-style SSH client. Recent versions of Windows
    bundle a native Windows implementation of the OpenSSH client that
    can be run from PowerShell or any other shell that supports running
    native Windows applications.


## Terminal emulation with built-in SSH support

-   [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/) has
    long been the most popular terminal emulation package of this type.
    The package is showing its age though and isn't really developed
    anymore except for security updates. It also comes with some tools
    for file transfer over sftp, but there is much better software for
    that purpose. The package is free though.\
    PuTTY has seen several forks into packages that extend PuTTY in one
    way or another. The best known one is probably
    [KiTTY](http://kitty.9bis.com/), with many tiny improvements,
    including the option to follow hyperlinks from the terminal.

-   [Bitvise SSH client](https://www.bitvise.com/ssh-client) is another
    SSH client that has some popularity. It also includes support for
    sftp.

-   However, this list and the next one on terminal emulators are far
    from complete. There are several other commercial and free options.

## Terminal emulation without SSH support

Windows supports several environments with OpenSSH clients: its own
PowerShell that can use a Windows native OpenSSH implementation included
in recent versions of Windows 10, CygWin, and Linux-distributions
running in WSL 1 or WSL 2 (Windows Subsystem for Linux).

To work comfortable, you'll still need a proper terminal emulation
program as the ancient console window provided by Windows really isn't
full-featured and doesn't benefit from features introduced in Windows 10
1809 (the ConPTY API).

Some terminal emulators for Windows are:

-   Windows Terminal: This is Microsoft's own terminal program and is
    100% free. It can be found in the Windows Store, and is in fact the
    standard terminal for PowerShell on Windows 11. Initial versions
    were tricky to customize, requiring editing a json file, but from
    April 2020 on the program should also have a GUI for changing most
    settings. It makes full use of the improved support in Windows
    itself for UNIX-style terminals from May 2019 on. While it was
    initially very rough around the edges, with those improvements it is
    probably the terminal emulator to go for to have access to any shell
    on your Windows system and make ssh connections from there. In fact,
    using the built-in OpenSSH client from Windows it is even possible
    to open sessions directly on your favourite cluster by using ssh as
    the command to start a session.

-   [ConEmu](https://conemu.github.io/): A long-time popular terminal,
    though at this writing (early 2021) it doesn't seem as easy to use
    with WSL as the Windows Terminal (which will detect your WSL
    distributions automatically).
