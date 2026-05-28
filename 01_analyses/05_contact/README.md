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


### Information table
Objective is to create an information table containing all the paired AA's and their respective information. Derived the pairs from the contact probs matrix extracting only pairs with 0.5> 
probabiliyty, With the contact_dataframe script then created the table which contains aas, recur(subunit) position, global position, whether the subunit is mitochondrial or nuclear for both AAs, and the probabiliyy of contact. This table is the results_df.
