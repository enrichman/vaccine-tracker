#!/bin/bash

URL_DATA="https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/anagrafica-vaccini-summary-latest.json"
TOT_POPULATION="59641488"

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.' >&2
  exit 1
fi

FIRST_DOSE=$(curl -s ${URL_DATA} | jq '[.data [].prima_dose] | add')
FIRST_DOSE_PERCENTAGE=$(echo "scale=2; 100 * ${FIRST_DOSE} / ${TOT_POPULATION}" | bc)

FIR=$(echo "${FIRST_DOSE_PERCENTAGE} * 20 / 100" | bc)
for ((i=1; i<=20; i++))
do
    if (( $i <= $FIR )); then
        FIR_COUNTER=${FIR_COUNTER}"▓"
    else
        FIR_COUNTER=${FIR_COUNTER}"░"
    fi
done


SECOND_DOSE=$(curl -s ${URL_DATA} | jq '[.data [].seconda_dose] | add')
SECOND_DOSE_PERCENTAGE=$(echo "scale=2; 100 * ${SECOND_DOSE} / ${TOT_POPULATION}" | bc)

SEC=$(echo "${SECOND_DOSE_PERCENTAGE} * 20 / 100" | bc)

for ((i=1; i<=20; i++))
do
    if (( $i <= $SEC )); then
        SEC_COUNTER=${SEC_COUNTER}"▓"
    else
        SEC_COUNTER=${SEC_COUNTER}"░"
    fi
done

printf "Prima dose: %s\n%s %s%%\n" ${FIRST_DOSE} ${FIR_COUNTER} ${FIRST_DOSE_PERCENTAGE}
printf "Seconda dose: %s\n%s %s%%\n" ${SECOND_DOSE} ${SEC_COUNTER} ${SECOND_DOSE_PERCENTAGE}
