library(RSQLite)
library(LUMA)

if(!file.exists("data-raw/Peaklist_db")) {
  download.file(
    "https://raw.githubusercontent.com/jmosl01/lcmsfishdata/master/data-raw/Peaklist_db",
    "data-raw/Peaklist_db"
  )
}

peak_db <- connect_peakdb(file.base = "Peaklist_db",
                          db.dir = "data-raw")

RSQLite::dbListTables(peak_db)

final.tbl <- read_tbl(mytable = "Peaklist_Combined_FINAL",
                    peak.db = peak_db)

comb.tbl <- read_tbl(mytable = "Peaklist_Combined_with Duplicate IDs",
                    peak.db = peak_db)

neg.solv.tbl <- read_tbl(mytable = "Peaklist_Neg_Solvent Peaks Only",
                    peak.db = peak_db)

neg.peak.tbl <- read_tbl(mytable = "Peaklist_Neg_Solvent Peaks Removed",
                       peak.db = peak_db)

norm.tbl <- read_tbl(mytable = "Peaklist_Normalized",
                     peak.db = peak_db)

pos.solv.tbl <- read_tbl(mytable = "Peaklist_Pos_Solvent Peaks Only",
                     peak.db = peak_db)

pos.peak.tbl <- read_tbl(mytable = "Peaklist_Pos_Solvent Peaks Removed",
                   peak.db = peak_db)

Peaklist.db <- list(final.tbl,comb.tbl,neg.solv.tbl,neg.peak.tbl,norm.tbl,pos.solv.tbl,pos.peak.tbl)

save(Peaklist.db, file = "data/Peaklist.rda")

dbDisconnect(peak_db)