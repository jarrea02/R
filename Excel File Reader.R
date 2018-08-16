options(java.parameters = "-Xmx8g")
library(XLConnect)

dir = 'B:/Returned Files/'

pass = 'Sinai1852'
l = list.files('B:/Returned Files',pattern = '(MSH)')

#for( i in l){
  name = paste0(dir,i)
  
  a =  loadWorkbook(name, create = FALSE, password = pass)
  
  s_name = getSheets(a)[1]
  
  b = readWorksheet(a,s_name)
  
  assign(i,b)
  
  
#}


a =  loadWorkbook(paste0(dir,l[1]), create = FALSE, password = pass)

