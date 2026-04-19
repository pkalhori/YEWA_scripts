#! /bin/bash


deme0=SAN
deme1=CRUZ
deme2=ISA
pops="${deme1}_${deme0} ${deme2}_${deme0} ${deme2}_${deme1}"
models="2D.Migration 2D.Isolation"
rundate=`date +%Y%m%d`
#rundate=20240830

#this is the string of populations to loop through
# wd stands for "working directory"

wd=/home/pkalhori/fastsimcoal
md=/home/pkalhori/fastsimcoal/modeldir
fsc=/home/pkalhori/bin/fsc28/fsc28


for model in $models
#iterate through each model
do
for pop in $pops
#iterate through each population
do
cd $wd
header=${model}_${pop}_$rundate
mkdir $header
cd $header
for run in {1..50}
do
cp $md/$model.tpl ${model}_${pop}.tpl
cp $md/$model.est ${model}_${pop}.est
cp $wd/SFS_dir/${pop}_jointMAFpop1_0.obs ${model}_${pop}_jointMAFpop1_0.obs
mkdir $wd/$header/run_${run}
cd $wd/$header/run_${run}
cp $wd/$header/${model}_${pop}.tpl $wd/$header/${model}_${pop}.est $wd/$header/${model}_${pop}_jointMAFpop1_0.obs ./

$fsc -t ${model}_${pop}.tpl -n100000 -m -e ${model}_${pop}.est -M -L 50 &
done

wait

done
done
cd $wd
sleep 10m 
