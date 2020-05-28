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
names(Peaklist_Pos)

colname.list <- lapply(Peaklist_Pos, colnames)
orig_colname <- colnames(Peaklist_Pos[["From_CAMERA"]])


#Repeat as many times as necessary until all colnames are appropriate for LUMA function examples and tests
newcolname.list <- lapply(Peaklist_Pos, function(x) {
  
  mycolnames <- colnames(x)
  newcolnames <- mycolnames[-which(mycolnames %in% orig_colname)]
  return(newcolnames)
  
})

mylengths <- sapply(newcolname.list, length)
newcolname.list[which(mylengths %in% max(mylengths))]

#These should have identical column names
identical(newcolname.list[[5]],newcolname.list[[6]])

##Make changes to specific column names that are inconsistent across tables
#Trimmed By CV, CV column has '%"
temp <- colnames(Peaklist_Pos$Trimmed_by_CV)
temp[which(temp %in% "%CV")] <- "X.CV"
colnames(Peaklist_Pos$Trimmed_by_CV) <- temp



usethis::use_data(Peaklist_Pos, compress = "xz", overwrite = T)

dbDisconnect(peak_db)
