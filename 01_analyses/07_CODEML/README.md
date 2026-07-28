codeml requires us to fix the messed up orthogroups as they are quite important
the bue ones (in the excel) had to be cleaned for paralogues  /duplicate genes, so we opened the gene trees for each of the three, looked at them with ITOL, decided based on gene length (uniprot of other species) and phylogeny (comparison to mitochondrial genome tree of all species, to check the position of the multiple genes to see which was the original, as the original would follow mitochondrial phylogeny more closely)
which duplicates to remove. in most cases the whole species was removed, as we could not decide surely which gene was the original, however in others we were able to decide, and remove all 
the copies, keeping a species. these decisions are in the ChgouDV15 notepad file. 
the next step is removing those removed gene tips from the tree, and then removing those duplicate genes from the current orthogroups, thus updating them. we will then have to align and trim these orthogroups.
the code to remove the tips was in R. 

``library(ape)
OG0009750 = read.tree("../../../../../OG0009750_tree.txt")
toremove <- c("Spmen|FQV24_0015320", "Spmen|FQV24_0003693", "Fialb|LOC101817512", "Plnig|PLONIG_R04016", "Plnig|PLONIG_R04017")
OG0009750 = drop.tip(OG0009750, toremove)
write.tree(OG0009750, "../../../../../OG0009750_tree.txt")``


### To align and trim we use the alignment_trimming.smk snakemake. 
performed alignment and trimming.
performed targetpepetide removal with targep2.0 (will have to remove manually too)
performed gene tree creation for all 3 genes which had the tips removed.
[all this in ~/snakemake-tutorial/01_tree_paralogous_manual]

manual trimming was then done for the 3 orthogroups, and then the 8 (red+blue) orthogroups were ran through CODEML to obtain the rst files.


# Extraction of NEB/BEB from each .rst. 
```bash
# Extraction NEB
for i in $(cat ../NEB_todo); do if [ -f "$i".rst ]; then sed -n '/Naive Empirical Bayes (NEB) probabilities for 2 classes & postmean_w/,/lnL = /{/Naive Empirical Bayes (NEB) probabilities for 2 classes & postmean_w/d ; /lnL = /d ; p}' "$i".rst | tail -n +3 | head -n -2 > "$i".txt; fi; done
# Extract BEB
for i in $(cat ../BEB_todo); do if [ -f "$i".rst ]; then sed -n '/Bayes Empirical Bayes (BEB) probabilities for 3 classes (class) & postmean_w/,/Positively selected sites/{/Bayes Empirical Bayes (BEB) probabilities for 3 classes (class) & postmean_w/d ; /Positively selected sites/d ; p}' "$i".rst | tail -n +3 | head -n -1 > "$i".txt; fi; done
```
these extracted .txts were then placed into a tsv which only contains residue number + class.

After extracting we now have each AA of the aligned/trimmed codeml input assigned to a class. we have to associate this alignment (and the positions to which the class is assigned to) to the alphafold positions. the alignment is different than the one used in recur because of no outgroup, so a new association has to be drawn manually. (cX_codemltoalphafold.txt notepads, constructed from manual curation via aliview, between the aligned gagal and the gagal in alphafold)
CYTC HAS NO GAGAL.

Each subunit was aligned (alphafold vs codeml trimmed gagal) and 4 files were obtaiend (c1-4_codemltoalphafold.txt) which indicated the modifications required to apply to each .tsv file in order to make the residue number match the intended residue on the alphafold corresponding gene. using a libreoffice macro:

```office
Sub Main
    Dim sCol As String, sStartRow As String, sDelta As String

    sCol = InputBox("Which column do you want to shift? (1 = column A, 2 = column B, ...)", "Shift Column", "1")
    If sCol = "" Then Exit Sub
    If Not IsNumeric(sCol) Then
        MsgBox "'" & sCol & "' isn't a valid column number."
        Exit Sub
    End If

    sStartRow = InputBox("Start shifting from which row? (1 = first row on the sheet)", "Shift Column", "1")
    If sStartRow = "" Then Exit Sub
    If Not IsNumeric(sStartRow) Then
        MsgBox "'" & sStartRow & "' isn't a valid row number."
        Exit Sub
    End If

    sDelta = InputBox("Shift by how much? (positive to add, negative to subtract)", "Shift Column", "1")
    If sDelta = "" Then Exit Sub
    If Not IsNumeric(sDelta) Then
        MsgBox "'" & sDelta & "' isn't a valid number."
        Exit Sub
    End If

    Dim col As Integer
    Dim startRow As Long
    Dim delta As Double
    col      = CInt(sCol) - 1        ' UNO API columns/rows are 0-based
    startRow = CLng(sStartRow) - 1
    delta    = CDbl(sDelta)

    Dim oDoc As Object, oSheet As Object, oCell As Object, oCursor As Object
    oDoc = ThisComponent
    oSheet = oDoc.CurrentController.ActiveSheet

    ' Find the last used row on this sheet.
    oCursor = oSheet.createCursor()
    oCursor.gotoEndOfUsedArea(False)
    Dim lastRow As Long
    lastRow = oCursor.RangeAddress.EndRow   ' 0-based

    If startRow > lastRow Then
        MsgBox "Row " & (startRow + 1) & " is past the last row with data (row " & (lastRow + 1) & ")."
        Exit Sub
    End If

    Dim r As Long, nChanged As Long
    nChanged = 0
    For r = startRow To lastRow
        oCell = oSheet.getCellByPosition(col, r)
        oCell.setValue(oCell.getValue() + delta)
        nChanged = nChanged + 1
    Next r

    MsgBox "Shifted " & nChanged & " cell(s) in column " & (col + 1) & ", starting at row " & (startRow + 1) & ", by " & delta & "."
End Sub
```

shifting of each residue and associated class was performed, then this tsv was merged with the alphafold .faa file, obtaining a 3 column tsv which has all the residues in equal positions as the alphafold, and the NEB/BEB classes from the codeml tsv.
the goal is to then also add a contact column and colour by generating a cxs file.
