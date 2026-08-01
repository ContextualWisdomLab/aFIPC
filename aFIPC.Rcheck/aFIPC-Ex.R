pkgname <- "aFIPC"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('aFIPC')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("autoFIPC")
### * autoFIPC

flush(stderr()); flush(stdout())

### Name: autoFIPC
### Title: automated fixed item parameter linking
### Aliases: autoFIPC

### ** Examples

## Not run:
##D autoFIPC(
##D   newformXData = new_model,
##D   oldformYData = old_model,
##D   newformCommonItemNames = common_new,
##D   oldformCommonItemNames = common_old,
##D   confirmCommonItems = TRUE
##D )
## End(Not run)



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
