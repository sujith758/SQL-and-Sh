FILEPATH=$1

export PGPASSWORD=postgres
psql -h localhost -p 5432 -d cyclecrash -U postgres -f Data Validation.sql
List_of_reasons=`psql -h localhost -p 5432 -d cyclecrash -U postgres -t -q -c 'select crashdate FROM crash_data.cyclecrashfreq1 WHERE DATE != ('YYYY-MM-DD');
'`
echo "Reasons: $List_of_reasons"
