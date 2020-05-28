library(RSQLite)
library(LUMA)

if(!file.exists("data-raw/Peaklist_db.SQLite")) {
  download.file(
    "https://raw.githubusercontent.com/jmosl01/lcmsfishdata/master/data-raw/Peaklist_db.SQLite",
    "data-raw/Peaklist_db.SQLite"
  )
}

peak_db <- connect_peakdb(file.base = "Peaklist_db",
                          db.dir = "data-raw")

mynames <- RSQLite::dbListTables(peak_db)
mynames <- mynames[-grep("sqlite",mynames)]


Peaklist_db <- lapply(mynames, function(x) read_tbl(x, peak.db = peak_db))
temp <- gsub(" ", "_", mynames)
names(Peaklist_db) <- temp
names(Peaklist_db)

colname.list <- lapply(Peaklist_db, colnames)
pos_colname <- colnames(Peaklist_db[["Peaklist_Pos_Solvent_Peaks_Removed"]])
neg_colname <- colnames(Peaklist_db[["Peaklist_Neg_Solvent_Peaks_Removed"]])
orig_colname <- unique(c(pos_colname, neg_colname))

#Repeat as many times as necessary until all colnames are appropriate for LUMA function examples and tests
newcolname.list <- lapply(Peaklist_db, function(x) {
  
  mycolnames <- colnames(x)
  newcolnames <- mycolnames[-which(mycolnames %in% orig_colname)]
  

  return(newcolnames)
  
})

mylengths <- sapply(newcolname.list, length)
newcolname.list[which(mylengths %in% max(mylengths))]

#These should have identical column names
identical(newcolname.list[[1]],newcolname.list[[2]])
identical(newcolname.list[[1]],newcolname.list[[5]])
identical(newcolname.list[[2]],newcolname.list[[5]])

##Make changes to specific column names that are inconsistent across tables
#Peaklist_Combined_Final, 'Ion Mode' column  and 'Ion.Mode' column
temp <- colnames(Peaklist_db$Peaklist_Combined_FINAL)
Peaklist_db[["Peaklist_Combined_FINAL"]][["Ion.Mode"]] <- Peaklist_db[["Peaklist_Combined_FINAL"]][["Ion Mode"]]
Peaklist_db[["Peaklist_Combined_FINAL"]] <- Peaklist_db[["Peaklist_Combined_FINAL"]][,-(which(temp %in% "Ion Mode"))]

#Peaklist_Combined_with_Duplicate_IDs, 'Ion Mode' column  and 'Ion.Mode' column
temp <- colnames(Peaklist_db$Peaklist_Combined_with_Duplicate_IDs)
Peaklist_db[["Peaklist_Combined_with_Duplicate_IDs"]][["Ion.Mode"]] <- Peaklist_db[["Peaklist_Combined_with_Duplicate_IDs"]][["Ion Mode"]]
Peaklist_db[["Peaklist_Combined_with_Duplicate_IDs"]] <- Peaklist_db[["Peaklist_Combined_with_Duplicate_IDs"]][,-(which(temp %in% "Ion Mode"))]

#Peaklist_Normalized has 'Ion.Mode.1' and 'Ion.Mode' columns
temp <- colnames(Peaklist_db$Peaklist_Normalized)
temp
Peaklist_db[["Peaklist_Normalized"]][["Ion.Mode"]] <- Peaklist_db[["Peaklist_Normalized"]][["Ion.Mode.1"]]
Peaklist_db[["Peaklist_Normalized"]] <- Peaklist_db[["Peaklist_Normalized"]][,-(which(temp %in% "Ion.Mode.1"))]

usethis::use_data(Peaklist_db, compress = "xz", overwrite = T)

dbDisconnect(peak_db)
