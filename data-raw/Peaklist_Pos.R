library(RSQLite)
library(LUMA)

if(!file.exists("data-raw/Peaklist_Pos.SQLite")) {
  download.file(
    "https://raw.githubusercontent.com/jmosl01/lcmsfishdata/master/data-raw/Peaklist_Pos.SQLite",
    "data-raw/Peaklist_Pos.SQLite"
  )
}

peak_db <- connect_peakdb(file.base = "Peaklist_Pos",
                          db.dir = "data-raw")

mynames <- RSQLite::dbListTables(peak_db)
mynames <- mynames[-grep("sqlite",mynames)]


Peaklist_Pos <- lapply(mynames, function(x) read_tbl(x, peak.db = peak_db))
temp <- gsub(" ", "_", mynames)
names(Peaklist_Pos) <- temp
devtools::use_data(Peaklist_Pos, compress = "xz", overwrite = T)

dbDisconnect(peak_db)
