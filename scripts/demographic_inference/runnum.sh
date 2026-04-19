#wd=/u/scratch/p/pkalhori/fastsimcoal/bird_data
#wd=/u/home/p/pkalhori/project-klohmueldata/pooneh_data/fastsimcoal
wd=/home/pkalhori/fastsimcoal
models='1D.2Epoch'
#models="2D.Isolation 2D.Migration 2D.Migration.Uneven"
for rep in {1..50}
do
#pops='ISA_CRUZ ISA_SAN CRUZ_SAN'
pops='ISA CRUZ SAN'
#muts="4.6e-9"
rundate=20250513
for model in $models
do
for pop in $pops
do
outfile=$wd/${model}_${pop}_${rundate}.all.output.concatted.txt
#get header:
header=`head -n1 $wd/${model}_${pop}_${rundate}/run_1/${model}_${pop}/*bestlhoods`
echo -e "runNum\t$header" > $outfile
for i in {1..50}
do 
outdir=$wd/${model}_${pop}_${rundate}/run_${i}/${model}_${pop}
results=`grep -v [A-Z] $outdir/*.bestlhoods`
echo -e "${i}\t$results" >> $outfile
done
done
done
done
