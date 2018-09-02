FROM mysql:5.7.23

RUN sed -i '/\[mysqld\]/a server-id=1\nlog-bin' /etc/mysql/mysql.conf.d/mysqld.cnf

VOLUME /var/lib/mysql

COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]