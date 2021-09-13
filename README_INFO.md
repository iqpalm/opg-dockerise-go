# Technical challenge

This repository forms the basis of our technical challenge and is used with in our hiring process.

Our production environments utilise AWS cloud platform with the infrastructure being created and controlled by Hashicorp's Terraform. Our deployment process takes the app code repository, generates a series of docker images which are then placed into AWS Elastic Cluster Service.

## Application

This repository contains a [Go](https://golang.org/) application (inside the `./app` folder) that acts as an API; it is configured to respond on port `8080` and has two endpoints (`/` and `/status`) that return `json` content.

The `/status` endpoint returns different content and `http` response code depending on the value of an environment variable called `APP_STATUS`. When `APP_STATUS=OK` the `/status` endpoint will return a `200` code and message, otherwise it will return a `500` code.

You can run the application directly using `go run ./app/main.go` from the root of this repository.

## The challenge

We would like you to create a fork of this repository which expands on the existing code. Aim to provide a working docker image based on the included application where both endpoints of the API return a 200 http status code.

Please include an updated README.md with steps to run your solution along with notes to document your approach and process.

Complete the task at your own pace, we recommend around an hour and a half of focus, this can be spread out and is not a strict factor.

**Do not worry if you are not able to fully complete the task, we are more interested in your approach then a perfect solution.**

To help guide you in this task, we've outlined some typical steps (in no particular order) that would be needed.

- Creating a Dockerfile
- Building the Go app
- Mapping ports
- Setting up Docker on your local machine
- Passing environment variables

## The interview

The challenge and your solution will form part of your face to face interview. We will ask you to explain your approach and, where relevant, ask questions on your solution.

The solution, your notes and interactions in the interview will go towards following criteria:

- Breaking down problems into logical steps
- Explaining your thoughts and communicating them
- Iterating towards a solution
- Verifying your work
