codeml requires us to fix the messed up orthogroups as they are quite important
the bue ones (in the excel) had to be cleaned for paralogues  /duplicate genes, so we opened the gene trees for each of the three, looked at them, decided based on gene length and phylogeny
which duplicates to remove. in most cases the whole species was removed, as we could not decide surely which gene was the original, however in others we were able to decide, and remove all 
the copies, keeping a species. these decisions are in the Chgou notepad file. 
the next step is removing those removed gene tips from the tree, and then removing those duplicate genes from the current orthogroups, thus updating them. we will then have to align and trim 
these orthogroups.
the code to remove the tips was in R. 
'''library(ape)
OG0009750 = read.tree("../../../../../OG0009750_tree.txt")
toremove <- c("Spmen|FQV24_0015320", "Spmen|FQV24_0003693", "Fialb|LOC101817512", "Plnig|PLONIG_R04016", "Plnig|PLONIG_R04017")
OG0009750 = drop.tip(OG0009750, toremove)
write.tree(OG0009750, "../../../../../OG0009750_tree.txt")'''
