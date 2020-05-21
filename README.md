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

* [BioPerl](https://github.com/bioperl/bioperl-live/blob/master/README.md) -- (used to process sequences)
* [Seqtk](https://github.com/lh3/seqtk) -- (used to change formats fastq/fasta)
* [BlastN](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download) -- (used for the assembly, find origin and check circularity)
* [BlasR](https://github.com/PacificBiosciences/blasr/wiki/Blasr-Installation-Qs-&-As) -- (used to get the organelle related reads)
* [Samtools](http://samtools.sourceforge.net/) -- (used to process BlasR output for coverage)
* [Bedtools](http://bedtools.readthedocs.org/en/latest/) -- (used to calculate coverage for the repeat analysis)
* [Sprai](http://zombie.cb.k.u-tokyo.ac.jp/sprai/README.html) -- (used for de-novo assembly)
* [WGS-Assembler](https://sourceforge.net/projects/wgs-assembler/) -- (used for de-novo asembly by Sprai)
* [SSPACE-Long](https://www.baseclear.com/services/bioinformatics/basetools/sspace-longread/) -- (used for the rescaffolding)

Note: SSPACE-Long uses getopt that it is not present in the Perl5 corelib. To fix this problem you can install it with ```cpan Perl4::CoreLibs```.

Most of these programs can be installed from repositories (e.g. Blast).


INSTALLATION
------------

To install the program

```sh
git clone https://github.com/aubombarely/Organelle_PBA.git
```

Once the directory is copied, you'll need to set up the environmental variables if the binaries of these programs are not in the PATH.

```
    export BLASR_PATH=<path_to_BlasR_binary>;
    export SAMTOOLS_PATH=<path_to_samtools_binaries>;
    export SPRAI_PATH=<path_to_Sprai_scripts>;
    export BLAST_PATH=<path_to_blast_binaries>;
    export CA_PATH=<path_to_WGS-assembler_binaries>;
    export SSPACELONG_PATH=<path_to_SSPACE-Long.pl_script>;
    export BEDTOOLS_PATH=<path_to_bedtools_binaries>;
```

INSTALLATION FROM DOCKER
------------------------

To install using docker

```sh
git clone https://github.com/cgjosephlee/Organelle_PBA.git  # currently my forked repo
cd Organelle_PBA
# SSPACE is not available in public domain, so
# acquire SSPACE from https://www.baseclear.com/services/bioinformatics/basetools/sspace-longread/
cp /path/to/SSPACE-LongRead.pl vendor/
chmod +x vendor/SSPACE-LongRead.pl

docker build -t aubombarely/organelle_pba .
docker run --rm aubombarely/organelle_pba
```

QUICK USAGE GUIDE
-----------------

```sh
mkdir chloro_out

OrganelleRef_PBA -i MySpeciesPacBio.fastq -r MyReferenceCHL.fasta -o chloro_out

# or use docker
docker run --rm -v $PWD:/data --user $UID:$GID aubombarely/organelle_pba \
    OrganelleRef_PBA -i MySpeciesPacBio.fastq -r MyReferenceCHL.fasta -o chloro_out
```

TESTING THE PIPELINE
--------------------

You can test the script with the test data. This data is a subset of the Arabidopsis thaliana PacBio data publicly available at SRA with the accession SRR1284093.

```sh
cd testdata
gzip -d artha_pacbioSRR1284093_c025k.fastq.gz artha_refchl01_artha.fa.gz

mkdir -p artha_chl
OrganelleRef_PBA -i artha_pacbioSRR1284093_c025k.fastq -r artha_refchl01_artha.fa -o artha_chl
# runs for ~30 min using 40 cores
```

Note: To speed up the process you can use multiple threads through different variables such as ``` -b '--nproc=40' -s 'num_threads=40' ```

