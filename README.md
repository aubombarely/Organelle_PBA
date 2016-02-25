# Organelle_PBA

OrganelleRef_PBA is a script to perform a de-novo PacBio assemblies of any 
organelle (chloroplast or mitochondrial genomes) using several programs. 

The different steps are:

1- Search of the PacBio organelle reads by sequence homology search using
   BlasR with a related organelle genome. It is preferred to use an organelle
   sequence of the same genus or family, but if the organelle sequence coverage
   is high (>100X) it is possible to use organelle sequence references from the
   same taxonomic order.

2- Assemble of the PacBio reads using Sprai. Sprai is a pipeline that uses
   WGS-Assembler, but that compare the reads between them before perform the
   assembly to take the best 20X.

3- If the fraction of the Sprai assembly is below some ratio, the script will
   perform a rescaffolding using the whole PacBio set. Otherwise, it will skip
   this step.

4- Taking the longest sequence, it will check for the origin of the organelle
   comparing the sequence with the reference. Additionally it will check if 
   there are an overlapping region produced by the circularity of the organelle.

5- It will check if the repeats have been missassembled, it will break the 
   assembly in LCS, SSC and IR and it will try to put together, removing 
   possible missassembled fragments.


