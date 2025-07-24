FROM ubuntu:24.04 AS builder
WORKDIR /opt
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y wget unzip
RUN wget -O mat.zip https://download.eclipse.org/mat/1.16.1/rcp/MemoryAnalyzer-1.16.1.20250109-linux.gtk.x86_64.zip
RUN unzip mat.zip

FROM ubuntu:24.04
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y openjdk-21-jdk && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk21-installer;
WORKDIR /opt
COPY --from=builder /opt/mat /opt/mat
COPY run.sh ./mat
WORKDIR /data
ENTRYPOINT ["/opt/mat/run.sh"]
