Flask Server with Nginx and Docker Compose

update 1.26.23:

 Just add Terraform for build all you need to run this Docker compose.
 You can enter your access key etc. in the terraform.tfvars file and run with terraform apply command.
 The entrypoint to the app is http://<public-ip>/hello
 enjoy!

Instructions:
 
This project sets up a Flask web server behind an Nginx reverse proxy using Docker Compose.

Requirements:
 -  Docker
 -  Docker Compose

Installation

Clone the repository, Navigate to the project directory and Start the containers: docker-compose up

Usage
Once the containers are running, you can access the Flask app by visiting http://localhost/hello in your web browser. The Nginx reverse proxy will handle routing traffic to the Flask app via the virtual network in docker.
To stop the containers, you can use docker-compose down.

Please let me know if you have any question.

Contributing
If you find any issues or have suggestions for improvements, feel free to open an issue or a pull request.
