library(RSQLite)
library(LUMA)

if(!file.exists("data-raw/Blanks_Pos.SQLite")) {
  download.file(
    "https://raw.githubusercontent.com/jmosl01/lcmsfishdata/master/data-raw/Blanks_Pos.SQLite",
    "data-raw/Blanks_Pos.SQLite"
  )
}

peak_db <- connect_peakdb(file.base = "Blanks_Pos",
                          db.dir = "data-raw")

mynames <- RSQLite::dbListTables(peak_db)
# mynames <- mynames[1:(length(mynames)-2)]
mynames <- mynames[-grep("sqlite",mynames)]


Blanks_Pos <- lapply(mynames, function(x) read_tbl(x, peak.db = peak_db))
temp <- gsub(" ", "_", mynames)
names(Blanks_Pos) <- temp
names(Blanks_Pos)

colname.list <- lapply(Blanks_Pos, colnames)
orig_colname <- colnames(Blanks_Pos[["From_CAMERA"]])


#Repeat as many times as necessary until all colnames are appropriate for LUMA function examples and tests
newcolname.list <- lapply(Blanks_Pos, function(x) {
  
  mycolnames <- colnames(x)
  newcolnames <- mycolnames[-which(mycolnames %in% orig_colname)]
  return(newcolnames)
  
})

mylengths <- sapply(newcolname.list, length)
newcolname.list[which(mylengths %in% max(mylengths))]



usethis::use_data(Blanks_Pos, compress = "xz", overwrite = T)

dbDisconnect(peak_db)
