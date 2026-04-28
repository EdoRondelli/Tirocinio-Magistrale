# Recur on mitochondrial
1) FInd which outgroup to use. FOund in bibliography thayt crocs are most common. We will use crocodylus porus.
2) Align outgroup with other group of orthologous genes (mitochondrial or nucoxphos)
3) Run msa result in recur.

Starting with ND1, taken from A0EQ81_CROPO uniprot. Added this sequence to the ND1.faa file, then will align with mafft. Added the croc sequence with nano to the nd1.faa raw, then used mafft --auto,
then ran recur with the command recur [options] -f <alignment_file> --outgroups <outgroup_species/file> -st <AA|CODON> -te <treefile> -m <model_of_evolution>, adding the treefile (with outgroup added) and the corresponding best model.

ND1-->A0EQ81
Nd2--> A0EQ82 
ND3--> A0EQ88
ND4--> Q335T4
ND4L--> A0EQ89
ND5--> A0EQ91
ND6--> A0EQ92
CYTB--> A0EQ93
ATP6--> A0EQ86
ATP8--> Q335T9
COX1--> A0EQ83
COX2--> Q335U0
COX3--> A0EQ87

### code to iterate over directories, append the croc seq to the raw aa unaligned sequence of all our birds.
for dir in */; do cd "$dir"; cat * > ${dir/\//}_out.faa; cd ..; done

### code tested to iterate over raw sequences and align them
for dir in */; do cd $dir; mafft --auto *_out.faa > ${dir/\//}.aln; cd .. ; done

now obtained folders containing unaligned w/out, unaligned without out, and aligned.

next step is to obtain the relevant mitochondrial model from the readme to iterate over all genes when we run recur


# Recur on nucoxphos
The approach to these is different. Nucoxphos sequences require trimming and deletion of target peptide so they were manually curared and grouped into orthogroups. the next step is to add the corresponding gene from the crocodile genome. FIrst we download the genome then delete isoforms and pseudogenes then we want to re-create the orthogeroup by adding this croc sequence.
agat_sp_keep_longest_isoform.pl --gff <GFF_file> -o <output_file>
agat_sp_extract_sequences.pl -g <GFF_longest_file> -f <FASTA_file> -t cds -p --cfs --output <output_file>
#N.B. AGAT use a particular module that wants FASTA file to be wrappend. Here it is important NOT to have single line FASTA. If you already have, try to use the command 'fold'

From the list of nucoxphos (annotated_nucOXP_OG.tsv), subset the ones which have an X in column 5, as we have the proteins of them. awk '$5 == "x" {print $4}' annotated_nucOXP_OG.tsv > nucoxphos.txt
Iterate over this list of names and grep each name in the fasta file of the annotated croc genome. Extracted all headers into headerlist.txt.
Made the fasta file of the entire genome into a oneliner fasta, in order to extract the sequences easily. (wk '/^>/{if(seq) print name"\n"seq; name=$0; seq=""} !/^>/{seq=seq$0} END{print name"\n"seq}' finaloutput > onelinefinaloutput.fa)

TARGETP ON THE CRPOR SEQUENCES. --> bin/targetp -fasta /home/STUDENTI/edoardo.rondelli/tirocinio_magistrale/00_data/00_genome/GCF_001723895.1/nucoxph_croc.fasta -prefix /home/STUDENTI/edoardo.rondelli/tirocinio_magistrale/00_data/00_genome/GCF_001723895.1/CrporTP -gff3 -mature -batch 300 -tmp /home/STUDENTI/edoardo.rondelli/.tmp       Must run in the targetp 08 folder.

Ran a code to extract all the sequences which were not found when comparing the nucoxph to the avbailable cropor genome. The ones that were not present we want to check if they are present under a different name, so we try to run a comparison blastp, between a fasta containing all of the crpor genome annotated sequences (turned into a diamond database) and the fasta containing all the files which were not found when matching the bird nucoxphos tsv and the crpor genome fasta.

Code to subset sequences between our nucoxphos gene names and the corresponding names in the total crpor genome for i in $(cat nucoxphos.txt); do grep -w -A1 "$i" onelinefinaloutput.fa | grep -A1 "^>"; done | wc -l

Found then the names in the nucoxph table which were not found in the crpor genome, and created a fasta file containing these 46 names + a representative sequence from a bird for each of them. This sequence was the blasted against the crpor database in order to find those sequences which while not being able to be matched due to not having the same name (synonym or locus) were still the same gene, and with blast out of the 46 non present nucoxphos 33 were found by blasting.

We then had a file containing all crpor nucoxph sequences, and had to run targetp on them. Obtained some mature files (58) with the target peptide removed, then had to run a script to extract the sequences which did not get matured and add them to the matured ones to obtain a complete set of genes, with some having TP removed and some not. for i in *_mature.fasta; do cp $i ${i/_mature/_complete}; done

for i in *_complete.fasta; do name=$(basename "$i" _complete.fasta); grep ">" "$i" | fgrep -v -f - <(grep ">" ../../00_disco_OG/"$name".faa) | fgrep -A1 -f - ../../00_disco_OG/"$name".faa | grep -v "\-\-" >> "$i" ; done


