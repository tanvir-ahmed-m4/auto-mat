FROM ubuntu:22.04 AS builder
WORKDIR /opt
RUN apt-get update && apt-get install -y wget unzip
RUN wget -O mat.zip https://download.eclipse.org/mat/1.15.0/rcp/MemoryAnalyzer-1.15.0.20231206-linux.gtk.x86_64.zip
RUN unzip mat.zip

FROM ubuntu:22.04
RUN apt-get update && \
	apt-get install -y openjdk-17-jdk && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk17-installer;
WORKDIR /opt
COPY --from=builder /opt/mat /opt/mat
COPY run.sh ./mat
WORKDIR /data
ENTRYPOINT ["/opt/mat/run.sh"]
