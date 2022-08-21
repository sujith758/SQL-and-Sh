#set -x
export PGPASSWORD=1234
TABLE_NAME=$1
EXPECTED_COUNT=$2
if [ -z "$TABLE_NAME" ]; then
    echo "No arguments provided"
    exit 1
fi
echo "$TABLE_NAME  AND $EXPECTED_COUNT"
RECORD_COUNT=`time psql -h localhost -p 5432 -d crashdata -U deadpool -t -q -c "select count(*) from $TABLE_NAME;"`
echo "Record_count:$RECORD_COUNT"
rm cyclecrash.csv
#time psql -h localhost -p 5432 -d crashdata -U deadpool -t -q -AF $'|' --no-align -c "select * from $TABLE_NAME;" >>cyclecrash.csv
psql -h localhost -p 5432 -d crashdata -U deadpool -t -q -A -c "select * from $TABLE_NAME;" >>cyclecrash.csv
#to get column count
#head -1 cyclecrash.csv | smed 's/[^|]//g' | wc -c
rec_count=`wc -l cyclecrash.csv | cut -d' ' -f1`
echo "In cyclecrash file word count:$rec_count"
replicate_file=`echo $TABLE_NAME | cut -d'.' -f1`
repl_file=${replicate_file}_replicate
i_num=`expr $EXPECTED_COUNT / $rec_count`
echo "records to be added:$i_num"
if [ "$i_num" == '0' ]; then 
	echo "No input to be added"
	exit 1
fi
rm $repl_file.csv
if [ "$rec_count" -le "$EXPECTED_COUNT" ] 
then
	echo "Record count is less"
	
	
	
START=$(date +%s.%N)
for (( i=1; i <= $i_num; i++ ))
	do
		cat cyclecrash.csv >> $repl_file.csv
		rec_count_replicate=`wc -l $repl_file.csv | cut -d' ' -f1`
		echo "replicating:$rec_count_replicate $"
	done		
fi
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo "Time taken to replicate:$DIFF Seconds"

echo "record count in replicate file:$rec_count_replicate"
REPLI_TABLE_NAME=${TABLE_NAME}_replicate
echo "replicate table:$REPLI_TABLE_NAME"

rec_count1=`wc -l $repl_file.csv | cut -d' ' -f1`
echo "Record Count:$rec_count1"

if [ "$rec_count_replicate" == "$rec_count1" ]; then
	echo "Sucessfully replicated"
else 
	echo "ERROR"
	exit 1
fi

psql -h localhost -p 5432 -d crashdata -U deadpool -t -q -c "drop table if exists crashdata.$REPLI_TABLE_NAME;" 
psql -h localhost -p 5432 -d crashdata -U deadpool -t -q -c "create table crashdata.$REPLI_TABLE_NAME as select * from $TABLE_NAME where 1=2;"
time psql -h localhost -p 5432 -d crashdata -U deadpool -t -q -c "\copy $REPLI_TABLE_NAME from '/home/deadpool/Documents/$repl_file.csv' delimiter '|' csv header;"

JOIN_COUNT=`time psql -h localhost -p 5432 -d crashdata -U deadpool -t -q -c "select count(*) from crashdata.$TABLE_NAME FULL JOIN crashdata.$REPLI_TABLE_NAME on $TABLE_NAME.Collision_ID = $REPLI_TABLE_NAME.Collision_ID;"`
echo "Join Count:$JOIN_COUNT"

DUPLICATE_TABLE=${REPLI_TABLE_NAME}_duplicate
echo "Dup table:$DUPLICATE_TABLE"
psql -h localhost -p 5432 -d crashdata -U deadpool -t -q -c "drop table if exists $DUPLICATE_TABLE;" 
psql -h localhost -p 5432 -d crashdata -U deadpool -t -q -c "create table $DUPLICATE_TABLE as select * from $REPLI_TABLE_NAME where 1=2;"
time psql -h localhost -p 5432 -d crashdata -U deadpool -t -q -c "insert into $DUPLICATE_TABLE select * from $REPLI_TABLE_NAME;"
DUPLICATE_COUNT=`time psql -h localhost -p 5432 -d crashdata -U deadpool -t -q -c "select count(*) from $DUPLICATE_TABLE;"`
echo "Duplicate table count:$DUPLICATE_COUNT"


JOIN_COUNT_FINAL=`time psql -h localhost -p 5432 -d crashdata -U deadpool -t -q -c "select count(*) from crashdata.$DUPLICATE_TABLE FULL JOIN crashdata.$REPLI_TABLE_NAME on $DUPLICATE_TABLE.Collision_ID = $REPLI_TABLE_NAME.Collision_ID;"`
echo "Join Count after duplication:$JOIN_COUNT_FINAL"

