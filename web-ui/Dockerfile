FROM ubuntu:noble
MAINTAINER Jack Moon <rokmc756@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN set -eux; \
        apt-get update; \
        apt-get install -y --no-install-recommends sudo sshpass ruby \
                glusterfs-client nodejs libnode109 netbase \
                ruby-dev npm git make g++ libsqlite3-dev; \
    npm install -g bower; \
        echo "gem: --no-rdoc --no-ri" > ~/.gemrc; \
        gem install bundler; \
        git clone https://github.com/oss2016summer/gluster-web-interface.git \
                /gluster-web; \
        cd /gluster-web; \
        bower install --allow-root; \
        echo "gem 'tzinfo-data'" >> Gemfile; \
        rm -f Gemfile.lock; \
        bundle install; \
        bin/rake db:migrate; \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/* /tmp/* Gemfile.* ~/.gem ~/.bundle \
                /usr/lib/ruby/gems/3.2.0/cache; \
        apt-get remove --purge -y ruby-dev npm git make g++ libsqlite3-dev; \
        apt-get autoremove --purge -y

WORKDIR /gluster-web
COPY entrypoint /
EXPOSE 3000
ENTRYPOINT ["/entrypoint"]
