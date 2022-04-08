# Running a cluster software stack on Windows with EESSI

Yes, it is possible to run a typical HPC cluster stack on Windows in a
WSL Linux virtual machine. There is a freely available software stack
made available by [the EESSI project](https://www.eessi-hpc.org/) which
at the time of writing this part of this text (March 2021) is still in
pilot phase with very limited program support.

The goal of EESSI is to make a full software stack available via the
so-called CernVM-FS file system which implements a read-only network
file system based on web technology that is ideal to distribute
software. The downside is that it is pretty hard to set up and that it
does require some manual intervention on Windows to start each time
Windows is rebooted or the WSL virtual machine is killed for any other
reason as WSL does not yet provide the necessary support to auto-start
the needed services. However, you need to install very little software
locally while a new software stack will become available automatically
and periodically.

TODO: Instructions.

