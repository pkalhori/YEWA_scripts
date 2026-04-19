
#!/bin/bash

pops='SAN CRUZ ISA'

stairway_dir=/home/pkalhori/stairway_plot

cd $stairway_dir

program_dir=/home/pkalhori/bin/stairway-plot-v2/stairway_plot_v2.1.2

for island in $pops

do

java -cp ${program_dir}/stairway_plot_es Stairbuilder folded_${island}.blueprint 

bash folded_${island}.blueprint.sh &

done
