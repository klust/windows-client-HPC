# Introduction

Windows 10/11 rather than Linux as a client for a Linux-based HPC cluster? Yes, this is perfectly possible. 
It can even be done using mostly free software (besides of course Windows itself). Windows 10, especially
in the editions launched in October 2019 and later, and Windows 11 contain many of the tools that you might need,
though they are often hidden as additional components in the Windows installation or as apps in the
Microsoft store.

In fact, it is even perfectly possible to create a Linux or Linux-like environment on your Windows machine,
which will give you the best of both worlds in a single machine and an easy environment to test your code, 
whether it is in an interpreted language such as Python or R, or a compiled language such as C, C++ or Fortran,
on your PC on smaller problems before moving it to the HPC cluster. 

There are also tools that allow you to edit files on the cluster from your PC with an editor running on your PC.
This is often preferable over the ancient text based editors on most clusters, or GUI programs that run very slowly
over networks. 

Disclaimer: This is unofficial documentation and work-in-progress. It is the result of my work at the 
[CalcUA service](https://hpc.uantwerpen.be)
of the [University of Antwerp](https://www.uantwerpen.be/) for the 
[Vlaams Supercomputer Centrum](https://vscentrum.be/). However, as my main machine for work is macOS-based,
this documentation is mostly written when I am working from home.

