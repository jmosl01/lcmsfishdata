library(RSQLite)
library(LUMA)

if(!file.exists("data-raw/Blanks_Neg")) {
  download.file(
    "https://raw.githubusercontent.com/jmosl01/lcmsfishdata/master/data-raw/Blanks_Neg",
    "data-raw/Blanks_Neg"
  )
}

peak_db <- connect_peakdb(file.base = "Blanks_Neg",
                          db.dir = "data-raw")

mynames <- RSQLite::dbListTables(peak_db)
mynames <- mynames[1:(length(mynames)-2)]


Blanks_Neg <- lapply(mynames, function(x) read_tbl(x, peak.db = peak_db))
temp <- gsub(" ", "_", mynames)
names(Blanks_Neg) <- temp
devtools::use_data(Blanks_Neg, compress = "xz", overwrite = T)

dbDisconnect(peak_db)
