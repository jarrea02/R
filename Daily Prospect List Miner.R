options(java.parameters = "-Xmx8g")
options(stringsAsFactors = F)
#library(XLConnect)y
#library(scan)
library(lubridate)
library(plyr)

ddir = "F:/Development/Prospect Screening/Daily Screening/Daily List - Original Copies"

list.files("F:/Development/Prospect Screening/Daily Screening/Daily List - Original Copies")#/Daily List - Original Copies")


a = list.dirs(ddir)

b =  a[grepl(".*(?:/.*){6}", a)]

l = character(0)
m = character(0)
z = 0

for (i in 1:length(b)){

  
 l =  c(l, paste0(b[i],'/',list.files(b[i])))
  
}

cols = c("MRN","Last.Name","First.Name","DOB","Gender","Admit.Dt", "Addr1",
         "Addr2","City" ,"State", "Zip","Phone", "Parent","Attending","specialityUnit" )
dat = setNames(data.frame(matrix(ncol = length(cols), nrow = 0)), cols)


for(i in l){
  tryCatch({
  test2 =  read.csv(i)
  if("SpecialityUnit" %in% colnames(test2)== F){
   test2$specialityUnit = ''
  }

  if("Attending" %in% colnames(test2)== F){
   test2$Attending = ''
  }
  test2 <- test2[cols]
  
  dat = rbind(dat,test2)
  },error=function(e){print(i)})
  
  
  
}

dat$Admit.Dt =  parse_date_time(dat$Admit.Dt,orders = c("mdy", "dmy"))

#dat = dat[rev(order(as.Date(dat$Admit.Dt, format="%d/%m/%Y"))),]

#dat$Admit.Dt = dmy(dat$Admit.Dt) 

dat =  arrange(dat, desc(Admit.Dt))
#
g =  dat[dat$Attending != "", ]
g = g[!duplicated(g$MRN),]

#write.csv(g,"Daily test 2.csv")
#getwd()

write.csv(dat,"Daily test 2.csv")
