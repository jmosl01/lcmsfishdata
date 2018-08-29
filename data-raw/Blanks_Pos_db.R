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

RSQLite::dbListTables(peak_db)

ann.tbl <- read_tbl(mytable = "Annotated",
                    peak.db = peak_db)

comb.tbl <- read_tbl(mytable = "Combined Isotopes and Adducts",
                    peak.db = peak_db)

CAMERA.tbl <- read_tbl(mytable = "From CAMERA",
                    peak.db = peak_db)

MF.tbl <- read_tbl(mytable = "From CAMERA with MinFrac",
                       peak.db = peak_db)

Trim.tbl <- read_tbl(mytable = "Trimmed by RT",
                   peak.db = peak_db)

pars.in.tbl <- read_tbl(mytable = "input_parsed",
                     peak.db = peak_db)

pars.out.tbl <- read_tbl(mytable = "output_parsed",
                     peak.db = peak_db)

Blanks.db <- list(ann.tbl,comb.tbl,CAMERA.tbl,MF.tbl,Trim.tbl,pars.in.tbl,pars.out.tbl)

save(Blanks.db, file = "data/Blanks_Pos.rda")

dbDisconnect(peak_db)