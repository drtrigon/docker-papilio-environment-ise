## Intro

Docker image containing an automated Papilio build environment.

For more info see http://forum.gadgetfactory.net/topic/2792-an-automated-papilio-build-environment-with-cloud9-ide-in-docker/

## Usage

Install docker:

`$ wget -qO- https://get.docker.com/ | sh`

Set user and group permissions (might need logout and new login to take effect):

`$ sudo usermod -aG docker osboxes`

(Re)start docker service:

`$ sudo service docker restart`

Now you can already run the cloud9 ide docker (gassettj/papilio-environment-cloud9) as it does not need the X server.

Enable access to X server:

`$ xhost local:root` or may better since a bit more restrictive: `$ xhost local:docker`

Finally run ISE:

`$ docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd):/workspace drtrigon/papilio-environment-ise bash -c "/opt/Xilinx/14.7/ISE_DS/common/bin/lin64/xlcm; ise;"`

This will first start the License Configuration Manager allowing you to add your Xilinx.lic license file (load it from /workspace directory). After you close that dialog it finally starts ISE in a window.

## Further info

### gassettj/papilio_environment (mirror at drtrigon/papilio_environment)

Base docker image the others build on. No entrypoint, but you can e.g. run ISE like:

`$ docker run --entrypoint "ise" -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd):/workspace gassettj/papilio_environment`

the problem with it is it misses the libqt4-network package and thus the License Configuration Manager will not work.

### gassettj/papilio-environment-cloud9 (mirror at drtrigon/papilio-environment-cloud9)

The cloud9 IDE image as described in http://forum.gadgetfactory.net/topic/2792-an-automated-papilio-build-environment-with-cloud9-ide-in-docker/. To run it use:

`$ docker run -v $(pwd):/workspace -p 8181:8181 gassettj/papilio-environment-cloud9 --auth username:password`

it can also run ISE with the same issues as gassettj/papilio_environment like:

`$ docker run --entrypoint "ise" -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd):/workspace gassettj/papilio-environment-cloud9`

### drtrigon/papilio-environment-ise

Modified gassettj/papilio_environment image adding libqt4-network and symlink needed to run  the License Configuration Manager. We use RUN construct to start the container not ENTRYPOINT as RUN together with bash allows to execute 2 commands in sequence.

### debugging

You can also run a bash shell in the docker container for testing and debugging with (ENTRYPOINT construct):

`$ docker run -it --entrypoint "/bin/bash" -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd):/workspace gassettj/papilio-environment-cloud9`

in order to stop the docker containers (especially with the original entrypoint as Jack set it) use ps to get the container id and then stop it:

`$ docker ps`

`$ docker stop <container>`

In order to get more info on how the docker image was created, run:

`$ docker history gassettj/papilio-environment-cloud9 --no-trunc`

### Reference

[1] https://docs.docker.com/engine/reference/run/#foreground (-it param)
[2] https://forums.docker.com/t/docker-run-cannot-be-killed-with-ctrl-c/13108 (docker stop)
[3] https://medium.com/@oprearocks/how-to-properly-override-the-entrypoint-using-docker-run-2e081e5feb9d (entrypoint)
[4] https://github.com/jessfraz/dockerfiles/issues/6 (xhost)
