FROM centos:7
RUN yum install java-1.8.0-openjdk-devel -y
COPY . /home/
RUN /home/installSupervisor
ENTRYPOINT supervisord -c /etc/supervisord.conf && tail -f /dev/null
