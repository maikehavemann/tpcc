## @description
##   tpc-c benchmark suite 
FROM s390x/ibmjava:jre


##install tools
##Create Ant Dir
RUN mkdir -p /opt/ant/
##Download Ant 1.9.8
RUN wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.8-bin.tar.gz -P /opt/ant
##Unpack Ant
RUN tar -xvzf /opt/ant/apache-ant-1.9.8-bin.tar.gz -C /opt/ant/
## Remove tar file
RUN rm -f /opt/ant/apache-ant-1.9.8-bin.tar.gz

##Setting Ant Home
ENV ANT_HOME=/opt/ant/apache-ant-1.9.8
##Setting Ant Params
ENV ANT_OPTS="-Xms256M -Xmx512M"
##Updating Path
ENV PATH="${PATH}:${HOME}/bin:${ANT_HOME}/bin"

##Install GIT
RUN apk --update add git

##Create Ivy Dir
RUN mkdir -p /opt/ivy/
##Download Ivy
RUN git clone https://git-wip-us.apache.org/repos/asf/ant-ivy.git
##Build from source
RUN ant jar

RUN cp ant-ivy/build/artifact/ivy.jar $ANT_HOME/lib/ivy.jar



CMD ["./oltpbenchmark", "-b", "tpcc", "-c", "config/sample_tpcc_config.xml", "--execute=true", "-s", "5", "-o", "outputfile"]


