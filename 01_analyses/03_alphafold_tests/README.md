First tests with alphafold, for complexes 1-4, detailed in the following excel[https://liveunibo-my.sharepoint.com/:x:/g/personal/edoardo_rondelli_studio_unibo_it/IQA3Y_RUAHbQQoZHlexDfJhlAWR6_dU_uPh_4JByd5kKbOk?e=fFilRb], which contains file names, origin of subunit sequences, etc.
Objective here was to start understanding the workflow for comparing an alphafold-generated structure to available literature structures taken from PDB.
Complex 5 of gallus gallus surpassed the 5000 residue limit for alphafold so was un-generateable.

Matchmaker to align unequal atom amount models and obtain an RMSD
Colouring by Bfactor to colour by distance between paired atoms

Another alternative to RMSD  is using an approximated TM-Score
<img width="253" height="39" alt="image" src="https://github.com/user-attachments/assets/7049c353-22ce-4df7-8e95-993bbf2dc701" />
With L being the number of matched residues that the RMSD corresponds to
Followed by the formula 
<img width="229" height="67" alt="image" src="https://github.com/user-attachments/assets/ced69af6-4338-4c26-a508-6304ab3ad1e9" />
which employs the calculated d0.
This can be converted to a % difference --> e.g. TM 0.99 = 1% error.

ANother option, since RMSDs are usually low and TMs high, since its the same protein, is normalizing RMSD by amount of aligned residues:
<img width="260" height="75" alt="image" src="https://github.com/user-attachments/assets/5faf60ff-3b40-45f9-8e83-cdd20ea056d0" />

https://onlinelibrary.wiley.com/doi/10.1002/prot.20264
https://aideepmed.com/TM-score/ 
sources for tm score approximation (basically instead of summing each individual distance for the dormula 1/summation(di/d0) it uses the average, which is the rmsd)

AVerage score of unrelated proteins is 0.13-0.2, thus giving error of 80%, Xu & Zhang, 2010 (I-TASSER benchmarking), but here the errors are all <1%.
ANOTHER NORMALIZATION OPTION - 100RESIDUE NORMALIZED RMSD - https://pmc.ncbi.nlm.nih.gov/articles/PMC2374114/


### Found that nd3, when being locally translated from the ncbi nucleotide to the assumed AA, was incorrect. A frameshift anomaly causes the actual AA sequence to be different to what a simple
### translation would give. Re-created complex 1 using the direct AA sequence isolated, and taken from NCBI. 

MUST DO MATCHMAKER CHAIN BY CHAIN BUT THIS WAY WE OBTAIN THE ENTIRE RMSD.
matchmaker #1/A,B,C to #2/A,B,C pairing ss showAlignment true 
or
use menu, match each chain, it returns an average rmsd of all the matched parts, colouring has to be done by selecting each chain from the log menu individually though
https://www.cgl.ucsf.edu/chimerax/docs/user/commands/matchmaker.html
https://www.youtube.com/watch?v=EEV-l067T6g

apparently must both match chains (easier if you first matchmake automatically, then select on chain of reference and click the other colour close to it, which is the same chain on the other superimposed model).
Must generate the alignment for rmsd to work i have no  clue why

If matching number error (e.g. 20refs 19 matches) probably have a dupe of one or the other inserted wihtout noticing.

Possible idea for colouring: Colour X (that stands out) for residues which are in alphafold model which are not in PDB reference. Colour Y for residues which are in PDB model but not in alphafold one. Rest, which is matched can be coloured based on traditional gradient.
Alternative, residues which are incompatible can have the colour of the most distant shade of traditional gradiant colour matching (e.g. darkest blue possible if blue means large Armstrong distance).

Seeing the RMSD results for complex 1 perhaps it makes sense to use unpruned metrics, as complex1 appears much better than it is, in the others pruning makes little difference but in complex1 it is a large difference in average rmsd if we prune with chimera rmsd calculation. Calulating rmsd returns a pruned and non pruned rmsd, pruning basically cuts off atom pairs which are over a chosen threshold, which i think  is 2A. In other complexes there are very few paired atoms over this distance but because of the angle change in the L shape in complex 1 between alphafold and PDB models there are many atoms over that distance. Either change threshold, or use non-pruned for all?

## TARGETING PEPTIDES
noticed that not all targeting peptides (which localize nuclear subunits to mitochondria) were removed and thus the models created still contained them
first ran program TargetP2.0 on our own sequences, which found some, others which wrere not able to be located were then derived from aligning mature / full / peptides of similar organisms in aliview to get an idea of possible target peptide of our chosen model and protein (seeing other tpS of similar organisms, and seeing similar mature sequences of similar organisms, compared to the full uncleaved target organism proteins). THis was done for complexes 1/2 (which were both fully constructed with our own orthogroups excepd sdhb which was just in our annotated genomes).
Then aim to re-construct complex 3+4 as well. 

COMPLEX 4 RECONSTRUCTRION FROM ONLY OUR DATA + REMOVAL OF TARGET PEPTIDES --> "FILE COMPLEX 4 WITHOUT CLEAVED TP"
Some sequences of these complexes were not available in mature form, so alignment was done manually comparing to others which had the mature, cutting the TP at conserved locations.
3 sequences were manually worked: COX6B/6C/8A
COX6B -> didnt get throguh disco. had to retrieve the orthgroups and process them with targetp. results were compared with available sequences from uniprot and then also the sequences found in the crystal structures in PDB, and we concluded that there were two possible reasonable cut points for the mature sequence, so we will test alphafold structure with both.
COX6C -> orthogroup didnt have a mature strain, so wasnt processed by targetp, so we manually compared with pdb structure crystals and other uniprot sequences, and here we also found two reasonable cleavage sites, so will work alphafold on both
COX8A -> didnt get through disco but ran target tp program on it and a clear cut site presented, even when compared to available sequences on unipro.
 RUN 2 SEPARATE ALPHAFOLDS, ONE WITH BOTH SHORTER AND ONE WITH BOTH LONGER REASONABLE SEQUENCES.

COMPLEX 3 RECONSTRUCTION
Only two main proteins gave issues, cyc1 (which we did not have at all) and uqcrhl. For UQCRHL the alignment was weird but we manually cut the target peptide.



## Completion of models
Completed thus the 4 models with alphafold, and obtained superimposition of them all with either botau/gagal/both. Added Fa4 (COX4A) subunit to complex 4 which is included in literature and some pdb structured.

COmpleted model 3. This model, on PDB, was often lacking subunit 11, there is no gagal pdb model with subunit 11 comprised, so we matched the rest.


# REINDEXING OF MODELS
To associate the global positions of the recur portion had to re-index all models so that the position corresponded to the global position in our recur & chi2 master tables. DId this with the reindex_complexes.R script, and produced the newly indexed models C_REINDEXED_FINAL.pdb.
