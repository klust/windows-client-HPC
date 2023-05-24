# Windows as a client system for HPC clusters

This work-in-progress repository contains a lot of information on how Windows 10 can be used as an ideal client for HPC clusters.

## Setting up the mkdocs environment

Set up your environment by creating a python virtual environment and to activate it.
Therefore, in the directory where you want to put your virtual environment(s) execute:

```
python3 -m venv hpcwin
source hpcwin/bin/activate
```

Which would create and initialise the virtual environment `hpcwin`. 
Once the virtual environment is ready, you can install the needed dependencies.
Go to this directory in the cloned repository and run

```
pip install -r requirements.txt
```