#
# computes mean RSA values for a given DCD and reference PDB
#
# Requires: 
#   bio3d
#   max SASA vector for individual residues withh 1-letter codes ordered alphabetically 
#   PDB and DCD file names
#   notice that dssp requires all backbone atoms to be present with IUPAC names: N CA C
# Output
#   a 3-column csv file: resid, RSA mean, RSA sem

# specify PDB and DCD file names

PDBfile <-"rsa_gSWT_protein_noh_heavyatom.pdb"
DCDfile <-"rsa_gSWT_protein_noh-0-399999-every20.dcd"


#output file name (csv)
outfile <-"rsa_gSWT_protein_noh_heavyatom.csv"

#path to DSSP and executalbe name
mydssp <-"/nfspool-0/home/jfreites/envs/bin/mkdssp"

#---- END OF UI
library (bio3d)

mypdb <-read.pdb(PDBfile)
mytraj <-read.dcd(DCDfile)

myseq <-pdbseq(mypdb)

#Default values are from Tien et al THEO
getACCseq <-function(myseq, maxacc = c (129, 167, 193, 223, 240, 104, 224, 197, 236, 201, 224, 195, 159, 225, 274, 155, 172, 174, 285, 263, NA)){
  aa <-c ("A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y", "X")
  seqacc <-sapply(myseq, function(z){maxacc[which(z == aa)]})
  if(!is.numeric(seqacc)) {
    stop("unknown sequence code")
  }
  return(seqacc)
}
mymaxacc <-getACCseq(myseq)
getRSAfun <-function(config,mypdb,maxacc){
  pdbtemp <-as.pdb(pdb = mypdb,xyz = config)
  mydssp <-dssp(pdbtemp,exefile = mydssp)
  myacc <-mydssp$acc
  if(length(myacc) != length(maxacc)) {
    stop("maximum ACC length and config ACC length don't match")
  } 
  return(myacc/maxacc)
}

myrsa <-apply(mytraj,1,getRSAfun,mypdb = mypdb,maxacc = mymaxacc)

write.csv(data.frame(resid = unique(mypdb$atom$resno),rsa = rowMeans(myrsa),
                     se = apply(myrsa,1,function(z){sd(z)/sqrt(length(z))})),outfile,row.names = F)

