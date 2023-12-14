# Running a cluster software stack on Windows

Codes that only use standard C/C++ or Fortran will likely compile
directly on Windows. the most popular commercial compiler on 
Windows for C and C++ does however offer very little support for,
e.g., OpenMP, an often used technology for shared memory computing.
The Intel compilers may offer a solution here.

One step up is using CygWin. You can then use the GNU compilers
and a large fraction of the POSIX system calls will also be 
supported. This will already support a larger range of applications.

However, as WSL 2 is free this is the better technology to create
a cluster-like environment on Linux. As this technology even enables
running practically any Linux binary, many options are available
to install scientific software. However, as the cores are shared with
Windows, just don't expect that it will be a very noise-free 
platform to also benchmark software, and some software may suffer.

System managers on HPC clusters often prefer to install software 
from sources to extract all performance out of a specific CPU, rather
than using binaries compiled for a generic processor. Systems
as Conda are less suited for that (though conda does offer some 
critical libraries with multiple code paths for different CPUs).
We will describe three options.

-   [EESSI](4_01_EESSI.md) is an effort to build a software stack that is served via
    a web based file system. It provides binaries for several 
    platforms. Though the most optimal binary for your PC may
    not be there (as in particular Intel disables features in 
    cores of the PC variants of processors compared to the ones 
    they sell for HPC systems), it will often be able to offer a
    binary that is close to optimal.

-   [EasyBuild](4_02_EasyBuild.md) is a software framework for installations of scientific
    software and is also used in the EESSI project. It can help you to
    do optimised installs from source for a lot of software.

-   [Spack](4_03_Spack.md) is another such framework with a very different filosophy
    but it also installs most software from sources and is probably the
    most used of such frameworks.

Content:

-   [EESSI](4_01_EESSI.md)

-   [EasyBuild](4_02_EasyBuild.md)

-   [Spack](4_03_Spack.md)



