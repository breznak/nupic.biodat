#!/bin/bash
# formats output from CLA's inference
# ./formatOutput.sh

DATA='./swarm/inference/DefaultTask.TemporalAnomaly.predictionLog.csv'

# fields
F_ACTUAL=4
F_PREDICTED=10
F_SEQID=5
F_ANOMALY=8
F_ANNOTATION_CLS=2
F_ANNOTATION_STR=3
F_METRIC=12 # minimize criterion

#1 get rid of the {12 232 232} field that breaks "normal" CSV 
# cut only the ecg (orig value) and pred.1 (prediction for T+1)
cat "$DATA" | sed -e's/{.*}/X/g' | cut -d, -f$F_ACTUAL,$F_PREDICTED,$F_ANOMALY,$F_ANNOTATION_CLS |\
grep -v 'string,' | grep -v ',,' # skip header data
