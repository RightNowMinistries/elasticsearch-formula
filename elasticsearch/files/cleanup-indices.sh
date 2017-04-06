DAYSAGO=`date --date="30 days ago" +%Y%m%d`
CURRENTDATE=`date +%Y.%m.%d-%T`

deleteIndices () {
  INDEX=$1
  echo "Cleaning up: $INDEX index"
  ALLINDICES=`/usr/bin/curl -s -XGET http://127.0.0.1:9200/_cat/indices?v | egrep $INDEX`

  echo "$ALLINDICES" | while read LINE
    do
    FORMATTEDLINE=`echo $LINE | awk '{ print $3 }' | awk -F'-' '{ print $2 }' | sed 's/\.//g' `

    if [ "$FORMATTEDLINE" -lt "$DAYSAGO" ]
    then
      TODELETE=`echo $LINE | awk '{ print $3 }'`
      echo "http://127.0.0.1:9200/$TODELETE"
      /usr/bin/curl -XDELETE http://127.0.0.1:9200/$TODELETE
    fi
  done
  echo ""
}

echo "Cleaning up ES Indices at: $CURRENTDATE"
deleteIndices "logstash"
deleteIndices "filebeat"
deleteIndices "metricbeat"
