# CygWin

[CygWin](https://cygwin.com/) uses a completely different approach 
to offer a level of Linux compatibility on Windows.
It is basically a library that emulates offers a large subset of the POSIX APIs, 
and much Linux software can be rebuild against this library. The resulting
binaries are regular Windows binaries and not Linux binaries, which also implies that the
Windows shared library approach is used rather than the Linux one.

CygWin also comes with a large range of recompiled GNU and other Open Source tools.

Since the binaries are regular Windows binaries, they can be started directly from any
Windows shell (cmd.exe or PowerShell) and can be mixed with regular Windows executables
easily.

As CygWin programs are really Windows programs, they also see the same file systems
as any other Windows program, though the CygWin translation layer will convert the
paths into a more UNIX-like one, e.g., using the forward slash instead of the backslash
and a different way of showing drive letters.

The downside is that even source-level compatibility with Linux is certainly not as good
as in WSL 1 or 2, and that certain Linux functionality which is not well supported by the 
Windows kernel may come with a performance hit. Also, it cannot run native Linux 
x86 binaries, neither 32-bit nor 64-bit ones.

CygWin is also used internally by some of the software packages that we will mention
in the [Software chapter](../3_Software/index.md).

There are other commercial products that use a similar approach, 
e.g., the [PTC MKS Toolkit](https://www.mkssoftware.com/).
