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

At the time of writing of this text  (June 2023), EESI is still
very much in a prototype phase. However, it got some funding through
a EuroHPC Centre of Excellence for further development so the speed
may pick up a little.

Getting it to work (without using a container, which would also
require installing additional software in most if not all WSL Linux
distributions) does require an initial effort.

TODO: Instructions.

