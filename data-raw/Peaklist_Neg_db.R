library(RSQLite)
library(LUMA)

if(!file.exists("data-raw/Peaklist_Neg_db")) {
  download.file(
    "https://raw.githubusercontent.com/jmosl01/lcmsfishdata/master/data-raw/Peaklist_Neg_db",
    "data-raw/Peaklist_Neg_db"
  )
}

peak_db <- connect_peakdb(file.base = "Peaklist_Neg_db",
                          db.dir = "data-raw")

mynames <- RSQLite::dbListTables(peak_db)
mynames <- mynames[-grep("sqlite",mynames)]


Peaklist_Neg_db <- lapply(mynames, function(x) read_tbl(x, peak.db = peak_db))
temp <- gsub(" ", "_", mynames)
names(Peaklist_Neg_db) <- temp
save(Peaklist_Neg_db, file = "data/Peaklist_Neg_db.rda")

dbDisconnect(peak_db)