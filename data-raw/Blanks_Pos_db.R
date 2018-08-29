library(RSQLite)
library(LUMA)

if(!file.exists("data-raw/Blanks_Pos_db")) {
  download.file(
    "https://raw.githubusercontent.com/jmosl01/lcmsfishdata/master/data-raw/Blanks_Pos_db",
    "data-raw/Blanks_Pos_db"
  )
}

peak_db <- connect_peakdb(file.base = "Blanks_Pos_db",
                          db.dir = "data-raw")

mynames <- RSQLite::dbListTables(peak_db)
mynames <- mynames[1:(length(mynames)-2)]


Blanks_Pos_db <- lapply(mynames, function(x) read_tbl(x, peak.db = peak_db))
temp <- gsub(" ", "_", mynames)
names(Blanks_Pos_db) <- temp
devtools::use_data(Blanks_Pos_db, compress = "xz")

dbDisconnect(peak_db)