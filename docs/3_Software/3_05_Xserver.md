# X servers

!!! note "Relevance"
    This section is only relevant if you want to use an X server outside
    of the WSL environment, e.g., on a system where you only use CygWin
    as a Unix/Linux emulation layer and want to avoid the use of WSL. 

    Since late November 2022 the Microsoft store version of WSL is available.
    This is a version of WSL2 that contains built-in support for WSL
    (dubbed WSLg). Windows 11 will render the
    image in the Linux server and push the image to the Windows screen via
    the Remote Display Protocol, but also include features to support OpenGL
    acceleration on the graphics card if a compatible Windows display driver
    is used. 

    Also check the [WSLg documentation](https://github.com/microsoft/wslg)
    on GitHub!

In the past, there were several commercial X servers that offered much
better performance than the freely available ones. These however have
lost popularity, especially when the server running the X applications
is not on the same very fast network, as the limited network bandwidth
and higher latency of longer network connections obliterate any speed
advantage over the free alternatives (though some might still offer more
functionality).

There are several X servers that are all derived from the X.org code
base. Packaging those to run on Windows does require some effort from
the developers of these packages, so some of the options below request a
minor fee or donation to compensate for that effort.

-   [Cygwin/X](https://x.cygwin.com/). Cygwin is a technology that
    offers a lot of Linux-functionality on top of Windows. This
    technology is discussed elsewhere. It also comes with an X server
    derived from the X.org code base. However, as one also needs to
    install the Cygwin system before being able to install the X server,
    it does require some more effort from the user than the other
    options given below. It is however entirely free.

-   MobaTek [MobaXterm](https://mobaxterm.mobatek.net/): This product
    was already discussed before. It's X-server is also based on the
    X.org sources and in fact relies on the built-in Cygwin. However,
    due to the integration in MobaXterm the interface is a bit more
    polished. The MobaXterm does support the GLX extension, but it is
    not clear if it is hardware accelerated or just a software OpenGL
    emulation. Recent versions integrate nicely with WSL also (tested
    with WSL2) and set the DISPLAY environment variable correctly so
    that you can start X programs in your WSL sessions started from
    MobaXterm. TODO: TEST ON A CLEAN MACHINE AS IT MAY PICK UP A
    VARIABLE SET BY GWSL.

-   [GWSL](https://opticos.github.io/gwsl/): This free X server installs
    from the Microsoft Store which makes it extremely easy to install
    and gives you automatic updates. It is based on VcXsrv, the next one
    in this list, but installs from the Windows store. It has a feature
    to ensure that each WSL session starts with the display variable set
    properly and a simple tool to create shortcuts to WSL graphical apps
    to start them at the click of a button. GWSL does support the GLX
    1.4 extension, but it is not clear if it is hardware accelerated or
    just a software OpenGL emulation. Like all X servers further down in
    the list, it is basically the work of a single person so there is no
    guarantee that the work will continue and limited support.

    A big disadvantage of this X server is that it runs with access
    control disabled, allowing all computers on the network to access
    the X server unless the firewall on your machine stops the
    applications from doing so. But tuning the firewall to only let
    traffic from the WSL virtual machine pass is no easy feat, also
    because the feature that sets the DISPLAY variable doesn't use the
    internal virtual connection. It may be a good enough X server to use
    at home but it should not be used in public spaces or on, e.g., a
    university network.

-   [VcXsrv](https://sourceforge.net/projects/vcxsrv/): This X server
    runs independently from the Cygwin libraries. It relies on an older
    version of the Microsoft compilers and some included libraries that
    make Cygwin unnecessary. It is installed through a regular Windows
    installer.

-   [Xming X Server](http://www.straightrunning.com/XmingNotes/): This
    is another server that can run independently from Cygwin. While
    VcXsrv uses the Microsoft compilers, the author of Xming relies on a
    port of the GNU compiler collection (though of course you don't need
    to have those compilers installed). It consists of two components:
    the actual X server and a package with additional fonts. The server
    is donationware (a minimum of 10 GBP will give you access to new
    versions for a year), though an older version is available entirely
    free. The donationware version does support the GLX extension. For
    the free versions, there is a download with (the -mesa version) and
    without GLX, but the GLX support is very outdated (GLX 1.2) given
    that the free version is essentially the 2007 version of Xming. It
    is installed through a regular Windows installer. Xming works nicely
    with WSL1 as you can simply set the DISPLAY variable to localhost
    but is a bit more tricky to use with WSL2, which runs in a virtual
    machine and hence doesn't share localhost with Windows. You'll have
    to start Xming with access control disabled (using the -ac command
    line option) and set the DISPLAY environment variable in your WSL2
    session with 
    
    ```
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print \$2; exit;}'):0 
    ```

    which is a trick that
    works with the other X servers also.

-   [X410](https://x410.dev/): This is a port of the X.org X-server
    solely for Windows 10 and packaged as a Windows Store app, making it
    extremely easy to install and uninstall. It has a free time-limited
    test version but afterwards it costs around 10 or 15 EURO (well, the
    store claims it costs 49.99 EURO, but I've always seen the reduced
    price of 14.99 EURO and at one point even 9.99 EURO). It is also
    fully independent of the Cygwin libraries, which may make it an
    excellent partner to use with Windows Terminal which is also a
    Microsoft Store app.

Other free or nearly free X-servers:

-   [MicroImages
    MI/X](https://www.microfocus.com/en-us/products/reflection-desktop-for-x/overview):
    Previously a commercial offering offered as part of their GIS
    software, but now made freely available. However, as this is based
    on a very old version of X we advise against its use. It is likely
    incompatible with many recent X packages.

In case you really want to go for a commercial offering, these are some
of the options:

-   Micro-Focus [Reflection Desktop for
    X](https://www.microfocus.com/en-us/products/reflection-desktop-for-x/overview)
    and Reflection Desktop Pro

-   OpenText
    [Exceed](https://www.opentext.com/products-and-solutions/products/specialty-technologies/connectivity/exceed)
    and [Exceed
    3D](https://www.opentext.com/products-and-solutions/products/specialty-technologies/connectivity/exceed-3d)
    (formerly Hummingbird Exceed):

-   StarNet [X-Win32](https://www.starnet.com/xwin32/)

-   PTC
    [X/Server](https://www.microfocus.com/en-us/products/reflection-desktop-for-x/overview).
    This vendor also makes a Linux interoperability software layer
    (similar to Cygwin) for Windows.

Many of the commercial offerings include the GLX extension for OpenGL
software (or offer it for an additional fee) which is a feature not
offered by all free servers, but it is not clear if their implementation
is better than in the free servers that support the extension (e.g., by
offering full hardware acceleration).

Note that we have no recent experience with any of these commercial
products.
