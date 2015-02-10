FROM debian:wheezy
MAINTAINER Zack Yang <zackcf.yang@moxa.com>

RUN apt-get update && apt-get install -y \
    python python-dev \
    build-essential \
    libssl-dev \
    libpng-dev \
    git \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Create user
#RUN /bin/bash -c "adduser --disabled-password --gecos '' moxa && \
#adduser moxa sudo && \
#echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"

ENV HOME /root
ENV NODE_INSTALL_VERSION v0.10.36
ENV RUBY_INSTALL_VERSION 2.1.2

# Install node.js and upgrade npm
RUN git clone https://github.com/creationix/nvm.git $HOME/.nvm
RUN /bin/bash -c "source ~/.nvm/nvm.sh && nvm install $NODE_INSTALL_VERSION && \
   nvm use $NODE_INSTALL_VERSION && nvm alias default $NODE_INSTALL_VERSION && \
   ln -s $HOME/.nvm/$NODE_INSTALL_VERSION/bin/node /usr/bin/node && \
   ln -s $HOME/.nvm/$NODE_INSTALL_VERSION/bin/npm /usr/bin/npm && \
   curl -L https://www.npmjs.org/install.sh | sh"

# Install node global module
RUN /bin/bash -c "npm install -g forever"

# Install ruby
#RUN /bin/bash -c "git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv && \
#                  git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build"
#
#RUN /bin/bash -c "echo 'export PATH=\$HOME/.rbenv/bin:$PATH' >> ~/.bash_profile && \
#                        echo 'eval \"\$(rbenv init - --no-rehash)\"' >> ~/.bash_profile"
#
## Setup exec path
#ENV PATH $HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH
#
## Never install rubygem docs
#RUN /bin/bash -c "rbenv install $RUBY_INSTALL_VERSION && \
#                  rbenv global $RUBY_INSTALL_VERSION && \
#                  rbenv rehash && \
#                  echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc"
#
## Install sass and compass
#RUN gem install compass && rbenv rehash

# Setup ssh key and git config
VOLUME $HOME/.ssh

#COPY id_rsa $HOME/.ssh/id_rsa
#COPY id_rsa.pub $HOME/.ssh/id_rsa.pub
#RUN /bin/bash -c "chmod 600 $HOME/.ssh/id_rsa && \
#                  echo 'echo -e \"Host github.com\n\tStrictHostKeyChecking no\n\" >> ~/.ssh/config' >> ~/.bash_profile && \
#                  echo 'echo -e \"Host bitbucket.org\n\tStrictHostKeyChecking no\n\" >> ~/.ssh/config' >> ~/.bash_profile && \
#                  echo 'git config --global url.\"https://\".insteadOf git://' >> ~/.bash_profile"

# Setup ssh key and git config
COPY start.sh $HOME/start.sh

# Mount project
VOLUME $HOME/project

ENTRYPOINT ["/bin/bash", "--login", "-i", "-c"]
WORKDIR $HOME

CMD ["/root/start.sh"]
