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
