parent_dir=/home/pkalhori/bwa_mywa_geo_W_yewa_mtDNA_alignment
#parent_dir="/path/to/samples"

for sample_dir in "$parent_dir"/*/; do
    sample_id=$(basename "$sample_dir")
    
    for f in "$sample_dir"*; do
        [[ -f "$f" ]] || continue  # skip if not a file

        base=$(basename "$f")
        
        # Skip if filename already starts with "sampleID_"
        [[ "$base" == "${sample_id}_"* ]] && continue

        mv "$f" "$sample_dir${sample_id}_$base"
    done
done
