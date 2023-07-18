 gatk \
   DepthOfCoverage \
   -R /home/pkalhori/geothlypis_reference_genome/ncbi_dataset/data/GCA_009764595.1/GCA_009764595.1_bGeoTri1.pri_genomic.fna \
   -O w_chromosome_coverage \
   -I ~/mpileup/all_bams_geothlypis_alignment.list \
   -L CM019934.1
