# Organelle_PBA

INTRODUCTION
------------

OrganelleRef_PBA is a script to perform a de-novo PacBio assemblies of any 
organelle (chloroplast or mitochondrial genomes) using several programs. 

The different steps are:

0. Search of the PacBio organelle reads by sequence homology search using BlasR with a related organelle genome. It is preferred to use an organelle sequence of the same genus or family, but if the organelle sequence coverage is high (>100X) it is possible to use organelle sequence references from the same taxonomic order.

0. Assemble of the PacBio reads using Sprai. Sprai is a pipeline that uses WGS-Assembler, but that compare the reads between them before perform the assembly to take the best 20X.

0. If the fraction of the Sprai assembly is below some ratio, the script will perform a rescaffolding using the whole PacBio set. Otherwise, it will skip this step.

0. Taking the longest sequence, it will check for the origin of the organelle comparing the sequence with the reference. Additionally it will check if there are an overlapping region produced by the circularity of the organelle.

0. It will check if the repeats have been missassembled, it will break the assembly in LCS, SSC and IR and it will try to put together, removing possible missassembled fragments.


SOFTWARE REQUIREMENTS
---------------------

* [BioPerl](http://www.bioperl.org/wiki/Installing_BioPerl) -- (used to process sequences)
* [Seqtk](https://github.com/lh3/seqtk) -- (used to change formats fastq/fasta)
* [BlastN](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download) -- (used for the assembly, find origin and check circularity)
* [BlasR](https://github.com/PacificBiosciences/blasr/blob/master/README.INSTALL.md) -- (used to get the organelle related reads)
* [Samtools](http://samtools.sourceforge.net/) -- (used to process BlasR output for coverage)
* [Bedtools](http://bedtools.readthedocs.org/en/latest/) -- (used to calculate coverage for the repeat analysis)
* [Sprai](http://zombie.cb.k.u-tokyo.ac.jp/sprai/README.html) -- (used for de-novo assembly)
* [WGS-Assembler](http://wgs-assembler.sourceforge.net) -- (used for de-novo asembly by Sprai)
* [SSPACE-Long](http://www.baseclear.com/genomics/bioinformatics/basetools/SSPACE-longread) -- (used for the rescaffolding)

Most of these programs can be installed from repositories (e.g. Blast).


INSTALLATION
------------