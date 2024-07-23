<h1 align="center">
  <a href="https://github.com/jtmb">
    <img src="https://dev.vividbreeze.com/wp-content/uploads/2018/08/DockerSwarmLogo.png" alt="Logo" width="125" height="125">
  </a>
</h1>

<div align="center">
  <b>EZ Swarm</b> - A simple ready to go swarm cluster with built in applications and DNS predeployed/preconfigured.
  <br />
  <br />
  <a href="https://github.com/jtmb/ez_swarm/issues/new?assignees=&labels=bug&title=bug%3A+">Report a Bug</a>
</div>
<br>
<details open="open">
<summary>Table of Contents</summary>


- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started) 
- [Environment Variables Explained](#environment-variables-explained)
- [Contributing](#contributing)
- [License](#license)

</details>
<br>

---  
## Prerequisites
- Docker installed on your system

### Getting Started
A simple run command gets your instance running.
```shell
./deploy_cluster.sh

```

## Environment Variables explained

```shell
    container_volumes_location=~/container-program-files'
```  
The location of where the container persistent volumes will be stored
```shell
    domain_name="mycluster.lan"
```  
The cluster domain name that will be used
```shell
    ip_address=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
```  
The ip address of the cluster, defaults to eth0. Change this to your machine ipv4 if your adpater does not line up or you are on WSL.


## Contributing

First off, thanks for taking the time to contribute! Contributions are what makes the open-source community such an amazing place to learn, inspire, and create. Any contributions you make will benefit everybody else and are **greatly appreciated**.

Please try to create bug reports that are:

- _Reproducible._ Include steps to reproduce the problem.
- _Specific._ Include as much detail as possible: which version, what environment, etc.
- _Unique._ Do not duplicate existing opened issues.
- _Scoped to a Single Bug._ One bug per report.

## License

This project is licensed under the **GNU GENERAL PUBLIC LICENSE v3**. Feel free to edit and distribute this template as you like.

See [LICENSE](LICENSE) for more information. 
