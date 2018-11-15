FROM grafana/grafana:5.2.1
USER root
RUN   apt-get update && apt-get install -qq -y git\
      && git clone https://github.com/WangHL0927/grafana-chinese.git \
      && mv /grafana-chinese/public /usr/share/grafana \
      && rm -rf /grafana-chinese \
      && apt-get autoremove -y
USER grafana
