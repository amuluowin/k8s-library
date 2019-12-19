#!/bin/sh

function checkZK() {
  while true; do
    echo "waiting for ZooKeeper..."
    sleep 1s

    if echo "ruok" | nc "$ZK_HOST" "$ZK_PORT"; then
      echo -e "\nZooKeeper has already started"
      break
    fi
  done
}

if [ "$1" = "help" ]; then
  echo "Usage: $(basename "$0") (master|worker|alert|help|debug)"
  exit 0
elif [ "$1" = "debug" ]; then
  # debuging
  echo "sleep 1d..."
  sleep 1d
  exit 0
fi

if [ "$1" = "master" ]; then
  echo "Starting master-server"
  LOG_FILE="-Dspring.profiles.active=master -Ddruid.mysql.usePingMethod=false"
  CLASS=org.apache.dolphinscheduler.server.master.MasterServer

  checkZK
elif [ "$1" = "worker" ]; then
  echo "Starting worker-server and logger-server"
  LOG_FILE="-Dspring.profiles.active=worker -Ddruid.mysql.usePingMethod=false"
  CLASS=org.apache.dolphinscheduler.server.worker.WorkerServer

  checkZK
  HOST_IP=$(ip -o -4 addr show up scope global | grep -v docker | grep -v br- | head -1 | awk '{print $4}' | cut -d"/" -f 1)
  python /opt/dolphinscheduler/script/del-zk-node.py $ZK_HOST:$ZK_PORT $HOST_IP

  echo "Starting logger-server"
  # 4g is too much for init
  sed -i 's/-Xms4g/-Xms1g/g' /opt/dolphinscheduler/bin/dolphinscheduler-daemon.sh
  /opt/dolphinscheduler/bin/dolphinscheduler-daemon.sh start logger-server

  echo "Starting worker-server"
elif [ "$1" = "alert" ]; then
  if [ -n "$ALERT_SERVER_STARTUP_DELAY" ]; then
    echo "delay $ALERT_SERVER_STARTUP_DELAY seconds before starting(waiting for master and worker)"
    sleep "$ALERT_SERVER_STARTUP_DELAY"
  fi
  echo "Starting alert-server"
  LOG_FILE="-Dlogback.configurationFile=conf/alert_logback.xml"
  CLASS=org.apache.dolphinscheduler.alert.AlertServer

elif [ "$command" = "combined" ]; then
  echo "Starting combined-server"
  LOG_FILE="-Dspring.profiles.active=combined"
  CLASS=org.apache.dolphinscheduler.api.CombinedApplicationServer

elif [ "$1" = "api" ]; then
  echo "Starting api-server"
  LOG_FILE="-Dspring.profiles.active=api"
  CLASS=org.apache.dolphinscheduler.api.ApiApplicationServer

  checkZK
fi

export DOLPHINSCHEDULER_HOME=/opt/dolphinscheduler
export DOLPHINSCHEDULER_CONF_DIR=$DOLPHINSCHEDULER_HOME/conf
export DOLPHINSCHEDULER_LIB_JARS="$DOLPHINSCHEDULER_HOME/lib/*"
export DOLPHINSCHEDULER_OPTS="-server -Xmx2g -Xms1g -Xss512k -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70"
cd $DOLPHINSCHEDULER_HOME || exit 1
exec $JAVA_HOME/bin/java $LOG_FILE $DOLPHINSCHEDULER_OPTS -classpath $DOLPHINSCHEDULER_CONF_DIR:$DOLPHINSCHEDULER_LIB_JARS $CLASS