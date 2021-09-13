# Application

This repository contains a [Go](https://golang.org/) application (inside the `./app` folder) that acts as an API; it is configured to respond on port `8080` and has two endpoints (`/` and `/status`) that return `json` content.

The `/status` endpoint returns different content and `http` response code depending on the value of an environment variable called `APP_STATUS`. When `APP_STATUS=OK` the `/status` endpoint will return a `200` code and message, otherwise it will return a `500` code.

# Steps to run the docker image

Run the following command in the terminal first to ensure that you don't need to run sudo commands.

`sudo chmod 666 /var/run/docker.sock`

Then run the following command

`docker run -d -p 8080:8080 --env-file env.txt --name server opg-dockerise-go`

this should return a container_id on the terminal

Then to test the endpoints run the following 2 commands

`curl localhost:8080` which should return {"code":200,"message":"Home"}

`curl localhost:8080/status` which should return {"code":200,"message":"OK"}

The docker image in the container is still running so to terminate it you will need to stop it and then remove it using the following commands:

`docker stop server`

`docker rm server`

Check that the image has been removed by running the command:

`docker ps -all` which should return no containers

## Approach taken and process

Forked the github repository and cloned it to my local machine

I tried to run the application using `go run ./app/main.go` but Go was not installed so followed terminal tip and installed Go.

Checked that Go has been correctly installed by creating and running a new file hello.go which returned "Hello,world!" using `go run ./app/hello.go` from the root of this repository.

Ran `go run ./app/main.go` from the root of this repository

Opened the browser and navigated to `localhost:8080` which returned `200` code and message

Navigated to `localhost:8080/status` which returned `500` code and an empty message.

**Next was to create the docker image having tested that the application works correctly.**

# Downloaded and installed docker

Navigated to docker.com and under Developers went to Docs, this took me to (https://docs.docker.com)

Chose Download and install then picked Docker for Linux and chose Ubuntu from the Server table. I followed the installation guide (https://docs.docker.com/engine/install/ubuntu/).

Checked that the Docker Engine is installed correctly by running the hello-world image `sudo docker run hello-world` in the terminal.

# Create the Dockerfile

Navigate back to docs.docker.com and pick Guides and choose Language-specific guides (New) from the left-hand menu and pick Go and then Overview (https://docs.docker.com/language/golang/)

Installed the Docker extension in VS Code as not used Docker before.

Followed the instructions from (https://docs.docker.com/language/golang/build-images/) to build the image.

I created a file with no extension called Dockerfile in the root of the directory.

I opened this file in VS Code and the first line to add was # syntax=docker/dockerfile:1. This is optional but it instructs the Docker builder what syntax to use when parsing the Dockerfile. This was used as it always points to the latest release of the version 1 syntax.

Next I added a line to tell Docker what base image to use for the application. As we are using Go I used the official Go image that already included all the tools and packages to compile and run a Go application. `FROM golang:1.16-alpine`

Next I created a destination directory for Docker to use rather than typing the full file paths every time I can then use relative paths based on this directory.`WORKDIR /app`

Next is to copy the modules necessary to compile the application. I used the COPY command to copy the go.mod file in the app folder to the app folder in the dockerfile.`COPY app/go.mod ./`

PROBLEM: Originally the command I used was `COPY go.mod ./` and it did not work properly.

SOLUTION: I realised that the WORKDIR was for the destination directory only and therefore I had to include the full path for the first argument of the COPY command (what was to be copied).

Now that the module file is inside the Docker image I executed the command `RUN go mod download` which installs the Go modules into the app directory inside the image.

Next is to copy the source code into the image. This is similar to above using the COPY command.`COPY app/main.go ./`

Now we can compile the application using the RUN command.`RUN go build -o /opg-dockerise-go`

Next is to specify the port where Docker will get all its information from so this is achieved using the command `EXPOSE 8080`.

Finally, `CMD ["/opg-dockerise-go"]` tells Docker what command to execute when the image is used to start a container.

## Create image from Dockerfile

I then created an image called opg-dockerise-go from the dockerfile by using the docker build command.
`docker build --tag opg-dockerise-go .`

PROBLEM: Originally the command `docker build --tag opg-dockerise-go .` was not working correctly and returning permission denied while trying to connect to the Docker daemon socket at unix.
The simple solution seemend to be adding sudo to the start of the command. However, I wanted to be able to run the commands without adding sudo all the time.

SOLUTION: I searched the internet for a solution and there seemed to be 2 answers. One was a 1 line command and another was a more comprehensive solution which required setting up a new docker group and adding my user account to it.
I opted for the 1 line solution so I ran `sudo chmod 666 /var/run/docker.sock` and re-ran the build command and it worked.

## Run the image as a container

I used the docker run command to run the image inside of a container.

The complete command is:

`docker run -d -p 8080:8080 --env-file env.txt --name server opg-dockerise-go`

A breakdown of the command is as follows:

-d (--detach) This ensures that Docker runs the container in the background and returns the user to the terminal prompt. It prints the container ID on the terminal.

-p (--publish) The container is running in isolation so I needed to publish a port for the container. The format is [host:port]:[container:port]. As the two ports are the same in this example it is 8080:8080. If we wanted to expose port 8080 inside the container to port 3000 outside the container it would be 3000:8080.

--env-file Originally, I passed the environment variables as key-value pairs directly on to the command line using --env APP_STATUS=OK. However, this is error-prone and not very secure especially for passwords. Therefore the key-value pair was moved to its own file and that file was referenced in the docker run command using --env-file.

--name Docker assigns a random name to a container if one is not provided. Therefore, --name enabled me to give the container a more useful name.

Other commands that I used to inspect containers were:

docker ps (running containers)
docker ps -all (all containers)
docker stop [NAME] (stop a container that is running)
docker restart [NAME] (restart stopped container)
docker rm [NAME] (remove a container)
