
##########################################################################################################################################
###                                                          Description of ImmuCC.R                                            ################
##########################################################################################################################################

  # ImmuCC R script
#       ImmuCC is a tissue deconvolution tool for mouse model that derived from the CIBERSORT method. It was composed of a traing signature matrix specific for mouse and the SVR method called from CIBERSORT.

# 1,    Researchers who are intersted in the application of ImmuCC to estimate the immune composition of mouse tissues, 
#       please cite "Chen,Z.et al.Inference of immune cell composition on the expression profiles of mouse tissue.Sci.Rep.7,40508;doi:10.1038/srep40508(2017)."

# 2,    The core algorithm of ImmuCC is based on a SVR method in CIBERSORT that was developed by Newman et al.
#       Researchers who are intersted in the methodology framework or algorithm, please cite "Newman, A.M.et al. Robust enumeration of cell 
#       subsets from tissue expression profiles. Nature methods 12,453???457,doi:10.1038/nmeth.3337(2015)".

# 3,    To access the CIBERSORT software, please request from https://cibersort.stanford.edu/ and follow their license: http://cibersort.stanford.edu/CIBERSORT_License.txt
#
# 4,    Author: Ziyi Chen, chziy429@163.com, 2017-02-07

##########################################################################################################################################
###                                                          Scripts of ImmuCC                                            ################
##########################################################################################################################################

# Main function of ImmuCC

CEL_ematrix <- function(path){
# Args:
  #    path: a character denoting the path to cel files
  
  library(affy)                      # Version: 1.56.0
  library(frma)                      # Version: 1.30.1
  library(mouse4302mmentrezgcdf)     # Version: 19.0.0
  library(mouse4302frmavecs)         # Version: 1.5.0
  library(preprocessCore)            # Version: 1.40.0
 # Note: the library version listed here is the package versions used in my work. However, you can choose the correspondent version based on the R installed in your computer and it will have no impact on the result.
  
# Read all cel files under path with a custom cdf "mouse4302mmentrezcdf"
  affydata <- ReadAffy(celfile.path=path, cdf="mouse4302mmentrezcdf")

# Preprocessing with frma
  eset <- frma(affydata)

# Output the expression value of samples profiled on array
  ematrix <- exprs(eset)
  write.table(ematrix, "mixture.txt",row.names=F, col.names=F)
  ematrix
}

# 
# ematrix <- CEL_ematrix(path)

ImmuCC <- function(expression, training_data='srep40508-s1.csv'){
 # Args:
   #    expression: expression matrix of sample data.
   #    training_data: signature matrix for deconvlolution.(The training data srep40508-s1.csv can be 
   #                   downloaded from the supplentary material of Sci.Rep.7,40508;doi:10.1038/srep40508(2017))
   #                   (https://media.nature.com/original/nature-assets/srep/2017/170113/srep40508/extref/srep40508-s1.csv)

 # Load the function of CIBERSORT
   source("CIBERSORT.R")
 # Note: the scirpts of CIBERSORT.R is a method developed by Newman et al.and can be accesssed upon an request from https://cibersort.stanford.edu/

    perm <- 100
    results <- CIBERSORT(training_data, expression, perm)
    results
}
