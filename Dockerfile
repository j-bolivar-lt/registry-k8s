# Use the Python 3.8 image
FROM python:3.8

RUN apt-get update -y && apt-get install vim -y
# Create a new user 'python-user'
RUN useradd -ms /bin/bash python-user

# Switch to 'python-user'
USER python-user

# Install the kubernetes and requests libraries
RUN pip install --user kubernetes requests
