FROM centos/ruby-24-centos7

# Extras
USER root
# dependency of charlock_holmes
RUN yum install -y libicu-devel
RUN yum clean all
RUN rm -rf /var/cache/yum
