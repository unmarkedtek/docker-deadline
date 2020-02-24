### Deadline in Docker

A locally running render farm with Deadline.

**Table of contents**

- [Overview](#overview)
- [Motivation](#motivation)
- [Prerequsities](#prerequsities)
- [Usage](#usage)
	- [Step I](#step-i)
	- [Step II](#step-ii)
	- [Step III](#step-iii)
- [Submitting Jobs](#submitting-jobs)
- [Running Arbitrary Commands](#running-arbitrary-commands)
- [Interactive Use](#interactive-use)
- [Windows](windows)
- [Deadline 9](#deadline-9)

<br>

### Overview

This project proivides a locally running render farm with Deadline and is based on the article "*Running Deadline **8** in Docker [Part I](http://deadline.thinkboxsoftware.com/feature-blog/2016/12/02/running-deadline-in-containers-part-1) | [Part II](http://deadline.thinkboxsoftware.com/feature-blog/2016/12/9/running-deadline-in-containers-part-2)*" with the added bonus of encapsulating the entire system, including 2 slaves, via [Docker Compose](https://docs.docker.com/marcompose/overview/).

Tested on [Windows](#windows) and Linux.

<br>

### Motivation

Developing for a distributed mechanism is akin to relying on the weather - you can never be sure what's out there or for how long it'll remain. It complicates life for a fellow developer interested in putting together a pipeline involving something like Deadline.

This project is meant as a local development silo for when you develop against Deadline, with the expectation that once you're finished you'll deploy into production and have things work the same, but without the uncertainty or surrounding infrastructure required to get Deadline off the ground.

<br>

### Prerequisities

The goal of this project is to expose a private render farm for purposes of pipeline development. As such, in order to submit renders to 2 slaves running Autodesk Maya 2016, here's what (all) you need.

- Docker
- Official Deadline installer

**Testing installation**

This process assumes you have access to Docker via your terminal.

```bash
$ docker --version
# Docker version 17.05.0-ce, build 89658be
```

<br>

### Usage

Use consists of (1) cloning this repository, (2) installing a Docker volume for the Deadline Repository, (3) building a Deadline client container and (4) putting it all together via Docker Compose.

Docker Compose is responsible for orchestrating the 5 pieces required for Deadline to function correctly and gluing them together accordingly.

- mongodb
- slave1
- slave2
- webservice
- samba

#### Step I

```bash
$ git clone https://github.com/mottosso/docker-deadline.git
```

Now put the official installers into the `installers/` directory.

**Example**

```bash
docker-deadline/
  installers/
    DeadlineClient-8.0.17.2-linux-x64-installer.run
    DeadlineRepository-8.0.17.2-linux-x64-installer.run
```

> Note that this project requires version 8 of Deadline, I didn't manage to get 9 working. See [below](#deadline-9).

#### Step II

Now we can go ahead and initialise the repository volume

```bash
$ cd docker-deadline
$ ./install.sh
```

This will install the Deadline Repository into a dedicated Docker [volume](https://docs.docker.com/engine/tutorials/dockervolumes/) called `deadline-volume`. Clients are then handed this volume upon startup.

You can check to see whether the volume was created correctly via `docker volume`.

```bash
$ docker volume list
DRIVER              VOLUME NAME
local               deadline-volume
```

#### Step III

Now let's kick things off via two machines with Maya 2016 pre-installed.

```bash
$ ./up
```

> **Pro Tip** Keep in mind that each time you boot up Deadline, it'll produce a new instance of MongoDB which is where jobs are kept. The repository on the other hand is persistent as a [Docker Volume](). You can inspect the contents of this volume by accessing the default Samba share accessible via the IP address to the host of your container; `localhost` on Linux.

#### Step III

At this point, you'd probably want to launch Deadline Monitor.

```bash
$ ./deadlinemonitor.sh
```

And you're done. See [Submitting Jobs](#submitting-jobs) for how to actually submit a job.

<br>

### Submitting Jobs

Now that Deadline and all of its components are up and running, you're able to submit jobs to it via the [RESTful](https://docs.thinkboxsoftware.com/products/deadline/8.0/1_User%20Manual/manual/rest-jobs.html) interface.

```python
import json
import getpass
import requests

url = "http://localhost:8082/api/jobs"
payload = {
    "JobInfo": {
        "Name": "My render",
        "UserName": getpass.getuser(),
        "Plugin": "MayaBatch",
        "Frames": "1000-1003x1",
    },
    "PluginInfo": {
        "SceneFile": "/share/my_file.ma",
        "Version": "2016",
        "OutputFilePath": "/share"
    },
    "AuxFiles": []
}

payload = json.dumps(payload)
requests.post(url, data=payload)
```

> Under Docker Toolbox, you'll need to replace `localhost` with the IP to the virtual machine running your Docker Host.

You'll notice I've included an example Maya file. Once submitted, the Docker slaves will produce an image much like the one below.

![my_file 1000](https://user-images.githubusercontent.com/2152766/28278934-c0d036a0-6b16-11e7-8cac-28c2b32b52b4.png)

<br>

### Contents of Deadline Repository

You can inspect the contents of the Deadline Repository via the provided Samba container.

```bash
$ ls \\<your-ip>\\DeadlineRepository8
```

It will be accessible like any other shared network folder.

> **Pro Tip** If you are running Docker Toolbox, the IP is accessible via a call to `docker-machine ip`.

<br>

### Running Arbitrary Commands

The `run.sh` provides a command-line interface over the internals of the client container. It takes the following syntax.

```bash
$ ./run.sh name-of-container name-of-executable
```

**For example**

```bash
$ ./run.sh slave1 ./deadlinelauncher
```

<br>

### Interactive Use

Gain access to the bash-prompt from within the Client container like so.

```bash
$ ./run.sh interactive bash
```

<br>

### Restarting your farm

The farm typically runs at less than 1% of CPU capacity on my moderate, 5-year old laptop. You can kill it (gracefully) like this.

```bash
$ ./down.sh
```

<br>

### Windows

The above assume a Linux environment. In order to run Deadline Monitor on Windows, you need a X11 server running, such as [VcXsrv][] or [Xming][].

With VcXsrv running, running `deadlinemonitor.sh` should work well with default settings. The container is being passed `$HOSTNAME` from your host to represent the name with which to connect to. If this variable isn't set, you can set it your self, either to your local hostname or IP address.

```bat
$ set HOSTNAME=192.168.0.12
```

[VcXsrv]: https://sourceforge.net/projects/vcxsrv/
[Xming]: https://sourceforge.net/projects/xming/

<br>

### Deadline 9

This project containerises Deadline 8 because of an issue with the client installation under 9.

```bash
Error: An error occurred while trying to set the repository connection settings.
You may have to provide them again when running the client.
```

<br>

### Troubleshooting

##### Could not connect to display

```bash
$ ./deadlinemonitor
QXcbConnection: Could not connect to display my_hostname:0
...
Deadline Monitor will now exit.
```

- Option A) Ensure X11 is running on your computer. Under Windows, see [VcXsrv][] or [Xming][].
- Option B) Trade `$HOSTNAME` for your IP address in `run.sh`, sometimes Docker fails to resolve a hostname to an IP address

##### Connection Refused

Sometimes Deadline Monitor quits when running `docker-compose up` due to Mongo not having had enough time to initialise.

```bash
requests.exceptions.ConnectionError: HTTPConnectionPool(host='192.168.99.100', port=8082): Max retries exceeded with url: /api/jobs
```



One solution to this is to simply bring it down, and back up again.

```My Notes 
```
Have updated to deadline10.25 centos7 and maya2019.

We must first download and add the following to installers folder.
Autodesk_Maya_2019_Linux_64bit.tgz
DeadlineClient-10.0.25.2-linux-x64-installer.run
DeadlineRepository-10.0.25.2-linux-x64-installer.run


in theory should be able to run the following:  install.sh; build.sh, up.sh to get the farm running,

then run deadline-monitor.sh and submit the /share/my_file.ma using deadline's maya submitter.


```Issues
```
Tried to set a smaller docker context for deadline10-client by moving the installer to it's owm subdir within installers.  The context part was faster but then it failed to find the file..


Current Image dependencies

centos7-> centos7-base-> deadline10-client-> deadline10-client-maya2019

****************************
deadline 10.1.3 needs ipv6
****************************

With deadline 10.1.3 needs ipv6 according to this post
https://forums.thinkboxsoftware.com/t/launcher-error-with-deadline-10-1/25710/9

getting docker to run with ipv6 requires changes to daemon.json

{
  "ipv6": true,
  "fixed-cidr-v6": "2001:db8:1::/64"
}

if you make an error 

~]$ less .docker/daemon.json

can't creat ipv6 netowork with compose.
had to put this in the up.sh wrapper
docker network create --driver bridge --ipv6 --subnet fd15:555::/64 --subnet 172.16.238.0/24 dockernet  --attachable

down.sh now doesn't delete the nework if the manager is running. - did that happen before????
