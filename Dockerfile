# docker image for running CC test suite
FROM rubybox:latest
MAINTAINER proubits <hynzhang@gmail.com>

# Checkout the work_page_app code
RUN git clone -b master https://github.com/proubits/work_page_app.git /work_page_app

# mysql gem requires these
#RUN apt-get -y install libmysqld-dev libmysqlclient-dev mysql-client
# pg gem requires this
#RUN apt-get -y install libpq-dev
# sqlite gem requires this
#RUN apt-get -y install libsqlite3-dev

# Optimization: Pre-run bundle install.
# It may be that some gems are installed that never get cleaned up,
# but this will make the subsequent CMD runs faster
RUN cd /work_page_app && bundle install

# Command to run at "docker run ..."
CMD if [ -z $BRANCH ]; then BRANCH=docker; fi; \
    cd /work_page_app \
    && git checkout $BRANCH \
    && git pull \
    && git submodule init && git submodule update \
    && bundle install \
    && bundle exec rspec spec
