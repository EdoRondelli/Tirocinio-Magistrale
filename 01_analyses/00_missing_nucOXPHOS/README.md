# Searching for orthogroups of proteins with no assigned orthogroups

I used the following dataset [annotated nucOXP](https://github.com/MirkMart/Mitochondrial_aves/blob/main/01_analyses/06_annotation/annotated_nucOXP.tsv) to subset
all the proteins found which didn't have a previously associated orthogroup, --> produced the [missing nucOXPHOS](./missing_nucOXPHOS.tsv) file.

```bash
awk -F'\t' '$5 == ""  {print $0}' annotated_nucOXP.tsv > ~/tirocinio_magistrale/missing_nucOXPHOS.tsv
```
The first search was seeing if and how many matches were found between the proteins and the FASTA headers in the nucleotide CDS files of each species, to see if a) the proteins had a species they
were represented in and b) if yes, how many --> produced the [present name](./present_name.tsv)

```bash
for name in $(cat missing_protein_names.txt); do count=$(grep "$name" 03_cds_amino_backup/* | grep -c ">"); presence=$(if [ "$count" -gt 0 ]; then echo "Yes"; else echo "No"; fi); echo -e "$name\t$presence\t$count"; done > present_name.tsv
```

I then subsetted the file to extract the names of the proteins, and only the ones with found matches in the species, performing a search of these names across the Orthologue Sequences dataset containing all 30,000+ orthologue groups, each of each orthologue, searching for the protein, and if found extracting the protein and the file it was found in

```bash
for protname in $(awk '$2 == "Yes" {print $1}' present_name.tsv); do echo "$protname"; for OG in ../../../../../PERSONALE/mirko.martini3/00_Mitochondrial_aves/01_analyses/04_orthology/00_OrthoFinder/Results_Mar17/Orthogroup_Sequences/*; do grep -l "$protname" "$OG"; done; done | tee -a found_OG_missing_nucOXPHOS.tsv
```

This created a file with the structure containing the protein name followed by the associated file path/s it was found in, and it was further elaborated to obtain the 
[TSV version](./found_OG_missing_nucOXPHOS.tsv)

```bash
awk '/^OG/{files=(files?files","$0:$0); next} {if(name) print name "\t" files; name=$0; files=""} END{if(name) print name "\t" files}' <(sed 's-../../../../../PERSONALE/mirko.martini3/00_Mitochondrial_aves/01_analyses/04_orthology/00_OrthoFinder/Results_Mar17/Orthogroup_Sequences/--' found_OG_missing_nucOXPHOS.tsv) > tempmissoxphos.tsv
```
