1) FInd which outgroup to use. FOund in bibliography thayt crocs are most common. We will use crocodylus porus.
2) Align outgroup with other group of orthologous genes (mitochondrial or nucoxphos)
3) Run msa result in recur.

Starting with ND1, taken from A0EQ81_CROPO uniprot. Added this sequence to the ND1.faa file, then will align with mafft. Added the croc sequence with nano to the nd1.faa raw, then used mafft --auto,
then ran recur with the command recur [options] -f <alignment_file> --outgroups <outgroup_species/file> -st <AA|CODON> -te <treefile> -m <model_of_evolution>, adding the treefile (with outgroup added) and the corresponding best model.

ND1-->A0EQ81
Nd2--> A0EQ82. 
ND3--> A0EQ88
ND4--> Q335T4
ND4L--> A0EQ89
ND5--> A0EQ91
ND6--> A0EQ92
CYTB--> A0EQ93
ATP6--> A0EQ86
ATP8--> Q335T9
