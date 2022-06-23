 #!/bin/bash
export PGPASSWORD=postgres
FILEPATH=$1
FPATH=$2
FILENAME=$3
FNAME=$4
NROWS=$5

#To get csv column count
CSVCNT=`wc -l "$FILEPATH" | cut -d " " -f 1`
echo "CSV COUNT: $CSVCNT"

#Establishing connection to database
psql -h localhost -p 5432 -d emptab -U postgres -f Edata.sql
CNT=`psql -h localhost -p 5432 -d emptab -U postgres -t -q -c 'select count(*) from empltab.Edata;'`
`psql -h localhost -p 5432 -d emptab -U postgres -t -q -c '\COPY empltab.Edata TO '$FPATH' CSV HEADER;'`
echo "COUNT: $CNT"


CSVCNT1=`wc -l "$FILENAME" | cut -d " " -f 1`
echo "CSV COUNT1: $CSVCNT1"



CSVCNT2=`wc -l "$FNAME" | cut -d " " -f 1`
echo "CSV COUNT2: $CSVCNT2"


for i in '$CSVCNT2'
do 
	if [ $i != $NROWS ];
	then
		cat $FILENAME >> $FNAME
	fi
done




CSVCNT3=`wc -l "$FNAME" | cut -d " " -f 1`
echo "CSV COUNT3: $CSVCNT3"



