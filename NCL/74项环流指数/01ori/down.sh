for (( I=1; I<75; I++))

    {

        wget "https://cmdp.ncc-cma.net/160/74.php?station_id=${I}&fromYear=1951&toYear=2019&posMonth=&predMonth=&avgPeriod=1981-2010&submit=%B2%E9%D1%AF&dump_search_data=1" -O idx${I}.txt;

    }
