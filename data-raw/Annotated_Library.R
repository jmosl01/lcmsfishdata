library(RSQLite)
library(LUMA)

if(!file.exists("data-raw/Annotated_Library")) {
  download.file(
    "https://raw.githubusercontent.com/jmosl01/lcmsfishdata/master/data-raw/Annotated_Library",
    "data-raw/Annotated_Library"
  )
}

lib_db <- connect_libdb(lib.db = "Annotated_Library",
                        db.dir = "data-raw")

RSQLite::dbListTables(lib_db)
lib.neg <- read_tbl(mytable = "Annotated Library_Neg",
                    peak.db = lib_db)

lib.pos <- read_tbl(mytable = "Annotated Library_Pos",
                    peak.db = lib_db)

Annotated_Library <- list(lib.neg,lib.pos)

devtools::use_data(Annotated_Library, compress = "xz")

dbDisconnect(lib_db)