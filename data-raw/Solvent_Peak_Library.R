library(RSQLite)
library(LUMA)

if(!file.exists("data-raw/Solvent_Peak_Library")) {
  download.file(
    "https://raw.githubusercontent.com/jmosl01/lcmsfishdata/master/data-raw/Annotated_Library",
    "data-raw/Solvent_Peak_Library"
  )
}

lib_db <- connect_libdb(lib.db = "Solvent_Peak_Library",
                        db.dir = "data-raw")

RSQLite::dbListTables(lib_db)
lib.neg <- read_tbl(mytable = "Neg_list",
                    peak.db = lib_db)

lib.pos <- read_tbl(mytable = "Pos_list",
                    peak.db = lib_db)

Solvent_Peak_Library <- list(lib.neg,lib.pos)

save(Solvent_Peak_Library, file = "data/Solvent_Peak_Library.rda")

dbDisconnect(lib_db)