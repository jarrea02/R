library(stringr)
library(lubridate)
library(dbplyr)

options(stringsAsFactors = FALSE)

cols = c("MRN",
         "LAST_NAME",                   
         "FIRST_NAME",
         "AGE",
         "DATE_OF_BIRTH",
         "GENDER",
         "ADDRESS_LINE_ONE",            
         "ADDRESS_LINE_TWO",            
         "ADDRESS_CITY",                
         "ADDRESS_STATE",               
         "ADDRESS_ZIP",
         "EMAIL_ADDRESS",
         "HOME_PHONE",
         "PHYSICIAN_NAME",              
         "MD_DEPARTMENT",               
         "DATE_OF_VISIT_WITH_PHYSICIAN",
         "TYPE_OF_VISIT"  )

dir = "F:/Development/Adrian/Files from C - 32 bit Build/Returned Files Copy"

l =  list.files(dir, pattern = '(MSH)')

dat = data.frame()


for( i in l){
  
  name = str_replace_all(i," ","_")
  
 a = read.csv(paste0(dir,'/',i))
 colnames(a)[which(names(a) == "HOME_PHONE_NUMBER")] <- "HOME_PHONE"
 colnames(a)[which(names(a) == "PHONE_NUMBER")] <- "HOME_PHONE"
 colnames(a)[which(names(a) == "PHONE")] <- "HOME_PHONE"
 a = a[,cols]
 
 dat = rbind(dat,a)

#assign(name,a)
  
 
  
}

#print(l)
#l[1]
#str_replace_all(l[1],"[[:punct:]]","_")
#str_replace_all(l[1]," ","_")

#names(`2018_05_11_MSH_Physicians.csv`)
#`2016_09_30_Multiple_MSH_Physicians.csv`$X = NULL

#test = `2016_09_30_Multiple_MSH_Physicians.csv`[,cols]


test2 = dat[dat$PHYSICIAN_NAME == "Sheryl Green"|
              dat$PHYSICIAN_NAME == "Elisa Port"|
              dat$PHYSICIAN_NAME == "Amy Tiersten"|
              dat$PHYSICIAN_NAME == "Christina Weltz"|
              dat$PHYSICIAN_NAME == "Jaime Alberty"|
              dat$PHYSICIAN_NAME == "Aarti Bhardwaj"|
              dat$PHYSICIAN_NAME == "Hanna Irie"|
              dat$PHYSICIAN_NAME == "Laurie Margolies"|
              dat$PHYSICIAN_NAME == "Paul H Schmidt"|
              dat$PHYSICIAN_NAME == "Paul Schmidt"|
              dat$PHYSICIAN_NAME == "Charles Shapiro"|
              
              dat$PHYSICIAN_NAME == "Richard Bakst"|
              dat$PHYSICIAN_NAME == "Emily Sonnenblick"
            
                   ,]

test2$DATE_OF_VISIT_WITH_PHYSICIAN <- mdy(test2$DATE_OF_VISIT_WITH_PHYSICIAN) 

test22 = test2[order(test2$DATE_OF_VISIT_WITH_PHYSICIAN),]

test22 = test22[!duplicated(test22[c("MRN")]),]
table(test22$PHYSICIAN_NAME)

write.csv(test22, "Patient Data Desc 2.csv")

write.csv(test2, "Patient Data ALL.csv")


test1 = dat[dat$PHYSICIAN_NAME == "Fred Lublin"|
              dat$PHYSICIAN_NAME == "Aaron Miller"|
              dat$PHYSICIAN_NAME == "Michelle Fabian"|
              dat$PHYSICIAN_NAME == "Ilana Katz-Sand"|
              dat$PHYSICIAN_NAME == "Sylvia Klineova"|
              dat$PHYSICIAN_NAME == "Stephen Krieger"|
              dat$PHYSICIAN_NAME == "Aliza Ben-Zacharia"|
              dat$PHYSICIAN_NAME == "Gretchen Mathewson"
             
            ,]
test11 = test1[order(-test1$DATE_OF_VISIT_WITH_PHYSICIAN),]
test1 = test1[!duplicated(test22[c("MRN")]),]
table(test1$PHYSICIAN_NAME)

write.csv(dat, "Patient Data ECTRIMS.csv")


dplyr::filter( grepl("Psych",dat$MD_DEPARTMENT))


class(dat$MD_DEPARTMENT)










