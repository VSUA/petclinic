FROM openjdk:8-oraclelinux8
RUN git clone
RUN ./installSupervisor
COPY ./petclinic .
RUN ./setupApp
