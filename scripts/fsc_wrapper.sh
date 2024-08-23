#! /bin/bash


pops='ISA CRUZ SAN'
models='1D.1Epoch'
rundate=`date +%Y%m%d`
#this is the string of populations to loop through
# wd stands for "working directory"
wd=/home/pkalhori/fastsimcoal
md=/home/pkalhori/fastsimcoal/modeldir
fsc=/home/pkalhori/bin/fsc28/fsc28
for run in {1..5}
do
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
cp $md/$model.tpl ${model}_${pop}.tpl
cp $md/$model.est ${model}_${pop}.est
cp $wd/SFSdir/${pop}_MAFpop0.obs ${model}_${pop}_MAFpop0.obs
mkdir $wd/$header/run_${run}
cd $wd/$header/run_${run}
cp $wd/$header/${model}_${pop}.tpl $wd/$header/${model}_${pop}.est $wd/$header/${model}_${pop}_MAFpop0.obs ./
#ss=`grep -w $pop $wd/projectionValues.txt|awk '{print$2}'`
##sed -i "s/SAMPLE_SIZE/$ss/g" ${model}_${pop}.tpl
$fsc -t ${model}_${pop}.tpl -n100000 -m -e ${model}_${pop}.est -M -L 50 -q
done
done
done
cd $wd
sleep 2m 