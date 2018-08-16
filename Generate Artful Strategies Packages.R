a = c('AA')
b = c('D','E','F')
c = c('3','4','5','6','7','8','9','0')
d = c('A','B')

x = vector('character')
y = vector('character')

e = 'AS'
f = c('$250-$999','$1,000-$4,999','$5,000-$9,999')
g = c('age 30s','age 40s','age 50s','age 60s','age 70s','age 80s','age 90s','age unknown')
h = c('control','test')








for (i in a){
  
  for (j in b){
    
    for (k in c){
      
      for (l in d){
        
         x = c(x,paste0(i,j,k,l))
        
      }
      
    }
    
    
  }
  
  
}

for (i in e){
  
  for (j in f){
    
    for (k in g){
      
      for (l in h){
        
        y = c(y,paste(i,j,k,l, sep = '_'))
        
      }
      
    }
    
    
  }
  
  
}


df  = data.frame(Pkg=x,Desc = y)
write.csv(df, file = "Pakages for 18LA06M1.csv", row.names = FALSE)

