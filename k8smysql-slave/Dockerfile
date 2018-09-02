FROM mysql:5.7.23

RUN RAND="$(date +%s | rev | cut -c 1-2)$(echo ${RANDOM})" && sed -i '/\[mysqld\]/a server-id='$RAND'\nlog-bin' /etc/mysql/mysql.conf.d/mysqld.cnf

VOLUME /var/lib/mysql

COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
