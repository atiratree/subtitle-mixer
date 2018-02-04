FROM centos/ruby-24-centos7

# Extras
USER root
# dependencies
RUN yum install -y libicu-devel libffi libffi-devel
RUN yum clean all
RUN rm -rf /var/cache/yum
