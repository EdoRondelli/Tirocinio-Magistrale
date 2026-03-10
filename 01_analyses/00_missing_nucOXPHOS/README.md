# Searching for orthogroups of proteins with no assigned orthogroups

I used the following dataset [annotated nucOXP](https://github.com/MirkMart/Mitochondrial_aves/blob/main/01_analyses/06_annotation/annotated_nucOXP.tsv) to subset
all the proteins found which didn't have a previously associated orthogroup, --> produced the [missing nucOXPHOS](./missing_nucOXPHOS.tsv) file.

```bash
awk -F'\t' '$5 == ""  {print $0}' annotated_nucOXP.tsv > ~/tirocinio_magistrale/missing_nucOXPHOS.tsv
```
The first search was seeing if and how many matches were found between the proteins and the FASTA headers in the nucleotide CDS files of each species, to see if a) the proteins had a species they
were represented in and b) if yes, how many --> produced the [present name](./present_name.tsv) file.

```bash
for name in $(cat missing_protein_names.txt); do count=$(grep "$name" 03_cds_amino_backup/* | grep -c ">"); presence=$(if [ "$count" -gt 0 ]; then echo "Yes"; else echo "No"; fi); echo -e "$name\t$presence\t$count"; done > present_name.tsv
```

I then subsetted the file to extract the names of the proteins, and only the ones with found matches in the species, performing a search of these names across the Orthologue Sequences dataset containing all 30,000+ orthologue groups, each of each orthologue, searching for the protein, and if found extracting the protein and the file it was found in.

```bash
for protname in $(awk '$2 == "Yes" {print $1}' present_name.tsv); do echo "$protname"; for OG in ../../../../../PERSONALE/mirko.martini3/00_Mitochondrial_aves/01_analyses/04_orthology/00_OrthoFinder/Results_Mar17/Orthogroup_Sequences/*; do grep -l "$protname" "$OG"; done; done | tee -a found_OG_missing_nucOXPHOS.tsv
```

This created a file with the structure containing the protein name followed by the associated file path/s it was found in, and it was further elaborated to obtain the 
[TSV version](./found_OG_missing_nucOXPHOS.tsv) file.

```bash
awk '/^OG/{files=(files?files","$0:$0); next} {if(name) print name "\t" files; name=$0; files=""} END{if(name) print name "\t" files}' <(sed 's-../../../../../PERSONALE/mirko.martini3/00_Mitochondrial_aves/01_analyses/04_orthology/00_OrthoFinder/Results_Mar17/Orthogroup_Sequences/--' found_OG_missing_nucOXPHOS.tsv) > tempmissoxphos.tsv
```

Subsetted solely the names of the orthologue files from that file, creating a list of names --> produced (separated_og_names.txt)
```bash
awk '{print $2}' found_OG_missing_nucOXPHOS.tsv
```

For each name, checked if the number of species it was represented in was more or less than 129, by checking, for each, its corresponding FASTA (residing in the Orthogroups_Sequences folder), and counting the ">" present, which correspond to unique species. In this process they were also labelled based on if they were supposedly eliminated by DISCO processing (because <129 species) or by trimming. --> Produced file (lost_fasta.tsv)

```bash
for unsureOG in $(cat separated_og_names.txt); do count=$(grep -c ">" /home/SHARED/00_Mitochondrial_aves/01_analyses/04_orthology/00_OrthoFinder/Results_Mar17/Orthogroup_Sequences/${unsureOG}); if [ "$count" -gt 128 ]; then echo -e "$unsureOG\tEliminated by trimming, has over 129 species associated"; else echo -e "$unsureOG\tEliminated by disco, has less than 129 species associated"; fi; done > lost_fasta.tsv
```

Discovered that some files with over 129 species were however eliminated by DISCO processing because they were not present in the DISCO product folder, so now we checked why and how. Found that 2 files categorized as "elimninated by trimming" were actually eliminated by DISCO, as they were not present in the /home/SHARED/00_Mitochondrial_aves/01_analyses/04_orthology/02_disco_OG location. These two files are OG0009750.fa and OG0001580.fa. 
