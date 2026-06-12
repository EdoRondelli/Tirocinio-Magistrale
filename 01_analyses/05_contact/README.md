### Combining the structural alphafold model with the analysis performed by recur
The next step in the analysis is to utilize the results of alphafold, in combination with those of recur, to perform a statistical analysis of the stringency of mutation of aminoacid residues.
The idea is that residues which are in close contact between subunits, especially between a nuclear and mitochondrial derived subunit, are more likely to be less freely able to mutate and evolve,
and so regions of contact will be less represented in the RECUR analysis which measures aminoacid changes over time.

The first step is to create a bridge between the alphafold proteins and the recur proteins, as these are modelled slightly differently (e.g. some of the sequences used in alphadfold were not
represented enough as an orthologue across species to be succesffully analyzed by recur, so they are missing). To do this we create a concatenated sequence of GAGAL RECUR proteins and insert X instead
of the missing AA or the missing TP (tp removal was also applied differently between the orthologues used for alphafold and those used for recur).
This brridge allows us to easily have information regarding position of AA to be associated with the exact same AA in the alphafold structure (e.g. an aminoacid which has changesd and recur indicates
as a lysine at position 34 will correspond to an existing lysine at position 34 of the same alphafold chain, with no inconsistencies, allowing an easier analysis).

- scaffold created.

### Modification of the recur files themselves
Another important step is the modification of the recur files TSVs themselves. Each file referring to a subunit which was longer than the alphafold subunit (§NDUFS3 & SDHD), the region which was not present in alphafold was eliminated from the annotated changes in the tsv (for example if alphafold and recur overlap on the last 100aas, and recur has an extra 5aas at the front, those first 5 are cut completely from the recur data, and we switch the site indicator by -5 for each recur-annotated row, so the indicated aa6 on recur becomes aa1, and corresponds correctly with the alphafold aa1). The second step is the reverse, where if in recur sites are missing w.r.t. alphafold, and thus we added Xs to compensate in the scaffolding, those sites which were recognized by recur are all shifted to +Number of Xs, so that site 1/2/3/etc actually become 1+nX, so it will refer to the actual site isntead of the added Xs. 


### Information table
Objective is to create an information table containing all the paired AA's and their respective information. Derived the pairs from the contact probs matrix extracting only pairs with 0.5> 
probabiliyty, With the contact_dataframe script then created the table which contains aas, recur(subunit) position, global position, whether the subunit is mitochondrial or nuclear for both AAs, and the probabiliyy of contact. This table is the results_df.
Did this for all 4 complexes. 

### Translation to chimera
The objective from here is to translate the contact pairs found in the results_df both into a way to overlap them with the recur tsv, and then in a way to insert this into chimera, colouring all the pairs we want. 
The idea is generating two bimodal information groups. One contains all the residues which are in fact in contact between nucleus subunits and mitochonrial subunits, and the other contains all the ones that arent. In each of these we analyze the representation % of recur variance vs invariance in both the groups.

1) Construct table listing all univocal AAs which are in these contact regions. AA | GPOS | CHAIN POS | MIT/NUC
