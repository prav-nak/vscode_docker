 # the base miniconda3 image
 FROM continuumio/miniconda3:latest
 
 # load in the environment.yml file - this file controls what Python packages we install
 ADD environment.yml /
 
 # install the Python packages we specified into the base environment
 RUN conda update -n base conda -y && conda env update
 
 # download the coder binary, untar it, and allow it to be executed
 RUN wget https://github.com/cdr/code-server/releases/download/1.604-vsc1.32.0/code-server1.604-vsc1.32.0-linux-x64.tar.gz \
     && tar -xzvf code-server1.604-vsc1.32.0-linux-x64.tar.gz && chmod +x code-server1.604-vsc1.32.0-linux-x64/code-server
 
 RUN apt-get update && apt-get install -y build-essential manpages-dev 

 # add in the code folder
 ADD ./code/ /code

#=====================================================#
#  Add usual lightweight text editors.                #
#  Add a user "devuser" with password "userpassword"  #
#=====================================================#
RUN apt-get update && \
    apt-get install -y \
    sudo \
    curl \
    git-core \
    gnupg \
    locales \
    zsh \
    wget \
    vim \
    nano \
    npm \
    fonts-powerline && \
    locale-gen en_US.UTF-8 && \
    adduser --quiet --disabled-password --shell /bin/zsh --home /home/devuser --gecos "User" devuser && \
    echo "devuser:userpassword" | chpasswd &&  usermod -aG sudo devuser
 
 COPY docker-entrypoint.sh /usr/local/bin/
 
 ENTRYPOINT ["docker-entrypoint.sh"]
