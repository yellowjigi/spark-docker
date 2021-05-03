docker exec spark hdfs dfs -put data/AdmissionsCorePopulatedTable.txt data/AdmissionsDiagnosesCorePopulatedTable.txt data/LabsCorePopulatedTable.txt data/PatientCorePopulatedTable.txt data/shakespeare.txt /tmp

docker exec spark hdfs dfs -chmod -R 777 /
