# All-in-one

These are packages that provide terminal emulator functionality with
support for ssh, support for file transfer over sftp, and an X server or
other ways to run remote graphics.

-   [MobaXTerm](https://mobaxterm.mobatek.net/) is maybe the most
    popular package of this kind at the moment. It has a free version
    with some restrictions on the number of connections (and a big
    restriction in the license on support you can get from even just
    your local system managers) and a commercial version based on a
    subscription model. The package is so large and rich in
    functionality that it becomes confusing. E.g., ssh is support both
    via a built-in PuTTY (see below) and OpenSSH in the built-in CygWin
    Linux emulation layer (which also offers a built-in bash shell), but
    both use different key formats. However, it is very rich in
    supported protocols. E.g., it also supports remote display
    connections via VNC or RDP. Recent versions can also be used as a
    terminal emulator to run WSL (Windows Subsystem for Linux) sessions.

-   [WinSSHTerm](https://winsshterm.blogspot.com/): This package is far
    less complete as MobaXTerm and requires external packages to work.
    It essentially combines the PuTTY/KiTTY ssh/terminal emulator,
    WinSCP file transfer tool and VcXsrv X server.
