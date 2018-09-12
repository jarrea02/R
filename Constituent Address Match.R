options(stringsAsFactors = FALSE)
options(error=function() dump.frames(to.file=TRUE))
options(scipen = 999)
library(stringdist)
library(tidystringdist)
library(RODBC)






dbhandle <- odbcDriverConnect("Driver={SQL Server};Server=SCRYSQLP014001;Database=Development_Office_Reports_Database;Uid=CrSvrReRpt;Pwd=Winter2016")


re_cons = sqlQuery(dbhandle,paste0("select distinct
records.CONSTITUENT_ID,
                                   records.FIRST_NAME,
                                   records.LAST_NAME,
                                   addr.ADDRESS_BLOCK,
                                   addr.Preferred_City,
                                   addr.Preferred_City,
                                   addr.Preferred_ZIP,
                                   lower(records.FIRST_NAME + ' ' + records.LAST_NAME)  as lower_name,
                                   lower(addr.ADDRESS_BLOCK + addr.preferred_city + addr.Preferred_State +
                                   case when addr.Preferred_ZIP is not null then LEFT(addr.Preferred_ZIP,5) else '' end) as lower_address
                                   
                                   from  dbo.records
                                   left join
                                   (
                                   select * from constit_address
                                   
                                   
                                   join
                                   (select CONSTIT_ADDRESS_PHONES.CONSTITADDRESSPHONESID,
                                   CONSTIT_ADDRESS_PHONES.CONSTITADDRESSID,
                                   CONSTIT_ADDRESS_PHONES.PHONESID,
                                   e.num,
                                   e.LONGDESCRIPTION
                                   
                                   
                                   from dbo.constit_address_phones
                                   
                                   join
                                   (SELECT 
                                   QCONSTITPHONES2.PHONESID,
                                   QCONSTITPHONES2.NUM,
                                   TABLEENTRIES.LONGDESCRIPTION
                                   
                                   FROM 
                                   DBO.QCONSTITPHONES2
                                   join dbo.TABLEENTRIES on TABLEENTRIES.TABLEENTRIESID = QCONSTITPHONES2.PHONETYPEID
                                   
                                   WHERE lower(tableentries.longdescription) like '%email%') e
                                   
                                   on e.PHONESID = CONSTIT_ADDRESS_PHONES.PHONESID) em
                                   
                                   on em.CONSTITADDRESSID = CONSTIT_ADDRESS.ID)has_email
                                   
                                   on has_email.CONSTIT_ID = records.id
                                   
                                   left join (select * from dbo.CONSTITUENT_SOLICITCODES
                                   where CONSTITUENT_SOLICITCODES.SOLICIT_CODE in (3660,16811))
                                   s
                                   
                                   on s.RECORDSID = records.ID
                                   
                                   left join(SELECT 
                                   ConstituentAttributes.TABLEENTRIESID,
                                   ConstituentAttributes.PARENTID,
                                   TABLEENTRIES.LongDESCRIPTION, 
                                   TABLEENTRIES.SEQUENCE
                                   
                                   FROM 
                                   DBO.ConstituentAttributes LEFT OUTER JOIN DBO.TABLEENTRIES ON ConstituentAttributes.TABLEENTRIESID = TABLEENTRIES.TABLEENTRIESID
                                   
                                   WHERE 
                                   ATTRIBUTETYPESID  =  123 
                                   and ConstituentAttributes.TABLEENTRIESID = 15558)pe
                                   
                                   on pe.PARENTID = records.ID
                                   
                                   left join (select CONSTIT_ADDRESS.CONSTIT_ID,
                                   address.id,address.ADDRESS_BLOCK,
                                   
                                   address.CITY as Preferred_City,
                                   STATES.SHORTDESCRIPTION as Preferred_State,
                                   address.POST_CODE as Preferred_ZIP
                                   
                                   
                                   from ADDRESS
                                   
                                   join CONSTIT_ADDRESS on CONSTIT_ADDRESS.ADDRESS_ID = ADDRESS.ID 
                                   left join dbo.states on states.SHORTDESCRIPTION = address.STATE) addr
                                   on addr.CONSTIT_ID = RECORDS.id
                                   
                                   where --has_email.num is null
                                   --and s.RECORDSID is null
                                   --and pe.PARENTID is null
                                   --and addr.ADDRESS_BLOCK is not null
                                   records.IS_CONSTITUENT = -1
                                   and records.KEY_INDICATOR = 'I'
                                   --and records.DECEASED = 0
                                   --and records.NO_VALID_ADDRESSES = 0
                                   --and records.constituent_id in ('289468')

                                   "))

#patients = read.csv("FATRC Patients Other Parent.csv")

patients = read.csv("BI Leadership Fall Patient Appeal.csv")

patients$match_id = 0
patients$row_id = 0






for (i in 1:nrow(re_cons)){


###################Address Match Score
re_cons$lower_address 
  
t =  tidy_comb(patients$Lower.Address,re_cons$lower_address[i])

z = tidy_stringdist(t,v1 = V1, v2 = V2, method = "jw")

z$rownum = row(z, as.factor = FALSE)

z$cons_id = re_cons$CONSTITUENT_ID[i]

z = z[order(z$jw),]
z = z[1:20,]
z$cons_id = ifelse(z$jw < 0.15,z$cons_id,0)



####################Name Match Score
b  = tidy_comb(patients$Lower.Name,re_cons$lower_name[i])

c = tidy_stringdist(b,v1 = V1, v2 = V2, method = "jw")

c$rownum = row(c, as.factor = FALSE)

c$cons_id = re_cons$CONSTITUENT_ID[i]

c = c[order(c$jw),]

c = c[1:10,]
c$cons_id = ifelse(c$jw < 0.06,c$cons_id,-1)


#z$name_addr_match = ifelse(z$cons_id %in% c$cons_id & z$rownum %in% c$rownum,"Y","N")
z$name_addr_match = ifelse(z$cons_id %in% c$cons_id & z$rownum %in% c$rownum,"Y","N")


patients$match_id[z$rownum] = ifelse(z$name_addr_match=="Y" & patients$match_id[z$rownum] == 0,z$cons_id,patients$match_id[z$rownum])
patients$row_id[z$rownum] = ifelse(z$name_addr_match=="Y" & patients$row_id[z$rownum] == 0,z$rownum,patients$row_id[z$rownum])
}

#final = patients[8588, ]

write.csv(patients,"BI Fall Patient Mailing Match.csv")

