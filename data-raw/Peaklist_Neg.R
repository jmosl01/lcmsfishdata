library(RSQLite)
library(LUMA)

if(!file.exists("data-raw/Peaklist_Neg.SQLite")) {
  download.file(
    "https://raw.githubusercontent.com/jmosl01/lcmsfishdata/master/data-raw/Peaklist_Neg.SQLite",
    "data-raw/Peaklist_Neg.SQLite"
  )
}

peak_db <- connect_peakdb(file.base = "Peaklist_Neg",
                          db.dir = "data-raw")

mynames <- RSQLite::dbListTables(peak_db)
mynames <- mynames[-grep("sqlite",mynames)]


Peaklist_Neg <- lapply(mynames, function(x) read_tbl(x, peak.db = peak_db))
temp <- gsub(" ", "_", mynames)
names(Peaklist_Neg) <- temp
names(Peaklist_Neg)

colname.list <- lapply(Peaklist_Neg, colnames)
orig_colname <- colnames(Peaklist_Neg[["From_CAMERA"]])


#Repeat as many times as necessary until all colnames are appropriate for LUMA function examples and tests
newcolname.list <- lapply(Peaklist_Neg, function(x) {
  
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
temp <- colnames(Peaklist_Neg$Trimmed_by_CV)
temp[which(temp %in% "%CV")] <- "X.CV"
colnames(Peaklist_Neg$Trimmed_by_CV) <- temp

##Repeat the above code until identical is TRUE

usethis::use_data(Peaklist_Neg, compress = "xz", overwrite = T)

dbDisconnect(peak_db)
