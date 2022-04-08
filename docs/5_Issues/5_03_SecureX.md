# Securing an X server in the Windows process space

The best way of course if you only want access to the X server from
programs running on your PC, is to limit access to the X server via
firewall software. How this should be done depends on the firewall that
you are using. One problem is that if you are using WSL2, you need to
ensure access from the virtual interface of the WSL2 virtual machine,
which is in the 172.16.0.0/12 range (or maybe even always in the
172.31.0.0/16 range).

An easy way to limit the access is via the xhost command, which you
would need to install in your Linux distribution. On the machine on
which we tested we found the following to work from CygWin and three
different Linux distributions (Fedora, openSUSE and Ubuntu):

  -----------------------------------------------------------------------
  xhost +\$HOSTNAME.mshome.net +localhost -
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------

The "+\$HOSTNAME.mshome.net" grants access to the virtual interface of
the WSL2 virtual machine (and is not needed on WSL 1), the "+localhost"
grants access to local X11 programs (important for CygWin and WSL1) and
the "-" denies access to everyone else.
