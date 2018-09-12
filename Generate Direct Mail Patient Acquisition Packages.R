a = c('IP','OP')
b = c('X')
c = c('6','7','8')
d = c('A','B')
a1=c('C','D')
#a1 = c('C','D','E','F')


x = vector('character')
y = vector('character')

e = c('Inpatient','Outpatient')
f = c('')
g = c('age 60s','age 70s','age 80s')
h = c('Within 11 ZIPs','Outside 11 ZIPs')
e1 = c('Bookmark','No Bookmark')
#e1 = c('December','January','March','April')









for (i in a){
  
  for (j in b){
    
    for (k in c){
      
      for (l in d){
        
       for (m in a1){
        
         x = c(x,paste0(i,j,k,l,m))
        
        }
        
      }
      
    }
    
    
  }
  
  
}

for (i in e){
  
  for (j in f){
    
    for (k in g){
      
      for (l in h){
        
       for(m in e1){
        
        y = c(y,paste(i,j,k,l,m, sep = ', '))
        
     }
      
    }
    
    
  }
  
  
}

}

df  = data.frame(Pkg=x,Desc = y)
df$Desc =  gsub(', ,',',',df$Desc)
df = unique(df)
write.csv(df, file = "18QM08M3.csv", row.names = FALSE)

