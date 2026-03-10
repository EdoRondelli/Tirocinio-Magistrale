Started with the objective of obtaining folders containing the fasta files of orthogroups of two categories: COX7 family orthogroups and COX family orthogroups.
First subsetted the names of the fasta 
```bash
for name in $(cat COXorthos.txt); do grep "$name" /home/SHARED/00_Mitochondrial_aves/01_analyses/06_annotation/final_annotation.tsv; done | awk '{print $1}' > COXfilenames.txt
```
Then grouped all the equivalently names actual fasta files
```bash
for name in $(cat COXfilenames.txt); do cp /home/SHARED/00_Mitochondrial_aves/01_analyses/04_orthology/02_disco_OG/"$name".faa actualfilesCOX/; done
```
Next idea is to create a phylogenetic tree for these groups.

For COX: we tried both concatenating them into a single huge file (to generate a tree which would have a single protein for each tip), and also by placing into iqtree the individual
orthogroups for the species, so as each tip is a different species.

Following this, subjected the files to MSA and trimming with a snakemake workflow [alignment_trimming.smk]() 

The trimmed groups of COX (both the entire and the separated one) were ran with IQTREE
```bash
iqtree -s 02_trimmed2COX^C-m MFP -B 1000 -T 20
```
