library(microdatasus)
library(dplyr)
library(magrittr)
# estados  <- c("AC", "AL", "AP", "AM", "BA", "CE", 
#               "DF", "ES", "GO", "MA", "MT", "MS", 
#               "MG", "PA", "PB", "PR", "PE", "PI", 
#               "RJ", "RN", "RS", "RO", "RR", "SC", 
#               "SP", "SE", "TO")
# 
# 
# for (est in estados) {
#   
# dados <- fetch_datasus(year_start = 2022,month_start =1 , year_end = 2022,
#                        month_end = 12,
#                        uf = est, information_system ='SIA-PA',
#                        vars = c("PA_UFMUN",
#                                 "PA_CODUNI",
#                                 "PA_CMP",
#                                 "PA_PROC_ID",
#                                 "PA_NIVCPL" ,
#                                 "PA_CBOCOD",
#                                 "PA_GESTAO",
#                                 "PA_CONDIC",
#                                 "PA_TPFIN",
#                                 "PA_SUBFIN",
#                                 "PA_QTDPRO",
#                                 "PA_QTDAPR"))
# 
# dados %<>% filter(PA_PROC_ID %in% c('0701070099',	
#                                    '0701070102',	
#                                    '0701070110',	
#                                    '0701070129',	
#                                    '0701070137',
#                                    '0701070145'))
# 
# 
# save(dados,file = paste('data/PA',est,'.Rdata',sep = ''))
# 
#}



library(arrow)
#dados <- read_parquet(file = 'data/ortodontia2008a2021.parquet')

dados <-data.table::rbindlist(lapply(Sys.glob("data/ortodontia2008a2021.parquet/part-*gz.parquet"), arrow::read_parquet))

library(readr)
EXTRATO_DA_PRODUÇÃO_CONSOLIDADA_SUS_SIA_SIH_202212 <- read_csv("data/EXTRATO DA PRODUÇÃO CONSOLIDADA SUS (SIA_SIH)_202212.csv",  
                                                               locale = locale(encoding = "ISO-8859-1"))


# categorias de gestao

teste <- levels(as.factor(EXTRATO_DA_PRODUÇÃO_CONSOLIDADA_SUS_SIA_SIH_202212$GESTÃO))



# Manual do SIASUS com categorias das variáveis:
# ftp://arpoador.datasus.gov.br/siasus/documentos/Manual_Operacional_SIA_V_1_1.pdf

#EP: Indica o tipo de gestão da secretaria municipal ou estadual. 
# As siglas possíveis atualmente são: 

PA_CONDIC_ref <- c('MN – município pleno NOAS', 
'EP – estado pleno', 
'EC – estado convencional', 
'PA – município pleno da atenção básica NOAS', 
'PB – município pleno da atenção básica NOB96', 
'PG – pacto de gestão', 
'MP – município pleno NOB')

library(tidyr)
library(stringi)
library(dplyr)
dados %>% mutate(TP_GESTAO=if_else(condition = stri_extract_first_charclass(PA_CONDIC,PA_CONDIC_ref),PA_CONDIC_ref,NA))


