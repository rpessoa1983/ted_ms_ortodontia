library(microdatasus)
library(dplyr)
library(magrittr)
library(tidyr)
library(stringi)
library(readr)
library(arrow)

# Leitura de dados filtrados por procedimento ortodontico do banco SIASUS ISC-UFBA 
dados <-data.table::rbindlist(lapply(Sys.glob("data/ortodontia2008a2021.parquet/part-*gz.parquet"), arrow::read_parquet))


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

PA_CONDIC_ref <- as.data.frame(PA_CONDIC_ref)
PA_CONDIC_ref %<>% mutate(cod = stri_sub(PA_CONDIC_ref,1,2))
dados %<>% left_join(PA_CONDIC_ref,by = c("PA_CONDIC"="cod"))



# CBO

SCNES_DOMINIOS_CBO_OCUPACAO <- read_delim("data/SCNES_DOMINIOS_CBO_OCUPACAO.csv", 
                                          delim = ";", escape_double = FALSE, 
                                          locale = locale(encoding = "ISO-8859-1"),
                                          trim_ws = TRUE)

names(SCNES_DOMINIOS_CBO_OCUPACAO) <- c("OCUPACAO","DESCRICAO","SAUDE","REGULAMENTADO") 


dados %<>% left_join(SCNES_DOMINIOS_CBO_OCUPACAO,c("PA_CBOCOD"="OCUPACAO"))

## Procedimentos 

procedimentos <- c("0701070099 PROTESE PARCIAL MANDIBULAR REMOVIVEL",
                   "0701070102 PROTESE PARCIAL MAXILAR REMOVIVEL",
                   "0701070110 PROTESE TEMPORARIA",
                   "0701070129 PROTESE TOTAL MANDIBULAR",
                   "0701070137 PROTESE TOTAL MAXILAR",
                   "0701070145 PROTESES CORONARIAS / INTRA-RADICULARES FIXAS / ADESIVAS (POR ELEMENTO)")

procedimentos <- as.data.frame(procedimentos)


procedimentos %<>% mutate(codp=stri_sub(procedimentos,1,10))


dados %<>% left_join(procedimentos,c("PA_PROC_ID"="codp"))

## Natureza Juridica

SCNES_DOMINIOS_NATUREZA_JURIDICA <- read_delim("data/SCNES_DOMINIOS_NATUREZA_JURIDICA.csv", 
                                         delim = ";", escape_double = FALSE, trim_ws = TRUE)


names(SCNES_DOMINIOS_NATUREZA_JURIDICA) <- c("NAT_JUR_COD","NAT_JUR_DESCRICAO") 

SCNES_DOMINIOS_NATUREZA_JURIDICA %<>% mutate(NAT_JUR_COD = as.character(NAT_JUR_COD))


dados %<>% left_join(SCNES_DOMINIOS_NATUREZA_JURIDICA,c("PA_NAT_JUR"="NAT_JUR_COD")) 


# Municipios 

SCNES_DOMINIOS_MUNICIPIOS <- read_delim("data/SCNES_DOMINIOS_MUNICIPIOS.csv", 
                                      delim = ";", 
                                      escape_double = FALSE, 
                                      trim_ws = TRUE)

names(SCNES_DOMINIOS_MUNICIPIOS) <- c("NOME_MUN","COD_IBGE6","UF") 

SCNES_DOMINIOS_MUNICIPIOS %<>% mutate(COD_IBGE6=as.character(COD_IBGE6))

dados %<>% left_join(SCNES_DOMINIOS_MUNICIPIOS,c("PA_UFMUN"="COD_IBGE6"))


# Entrega

dforto <- dados %>%
  select(UF,PA_UFMUN,NOME_MUN,
         PA_CMP,
         PA_PROC_ID,procedimentos,PA_QTDPRO,PA_QTDAPR,
         PA_NAT_JUR,NAT_JUR_DESCRICAO,
         PA_CONDIC,PA_CONDIC_ref)

dforto %<>% mutate(PA_QTDAPR=as.numeric(PA_QTDAPR),PA_QTDPRO = as.numeric(PA_QTDPRO))
## LEIA-ME
### As conversões se basearam em dois documentos principais 
### CNES-DOMINIOS http://cnes.datasus.gov.br/pages/downloads/documentacao.jsp
### Manual do SIASUS ftp://arpoador.datasus.gov.br/siasus/documentos/Manual_Operacional_SIA_V_1_1.pdf

# UF - CHAR (2) Unidade da Federação 
# PA_UFMUN CHAR (6) Unidade da Federação + Código do Município onde está localizado o estabelecimento
# NOME_MUN - Nome do município CHAR() 
# PA_CMP CHAR (6) Data da Realização do Procedimento / Competência (AAAAMM) 
# PA_PROC_ID CHAR (10) Código do Procedimento Ambulatorial 
# procedimentos - Código + descrição do procedimento 
# PA_QTDPRO NUMERIC (11) Quantidade Produzida (APRESENTADA)
# PA_QTDAPR NUMERIC (11) Quantidade Aprovada do procedimento 
# PA_NAT_JUR CHAR(4) Código da Natureza Juridica11 
# NAT_JUR_DESCRICAO - Natureza Jurídica - Descrição 
# PA_CONDIC CHAR (2) Sigla do Tipo de Gestão no qual o Estado ou Município está habilitado 
# PA_CONDIC_ref



## Verificacao 

# Inclusao da variavel ano a partir da competencia
dforto %<>% mutate(ANO = stri_sub(PA_CMP,1,4))

# Soma das quantidades aprovadas no SIASUS
dfortoc<- dforto %>% group_by(ANO) %>% 
  summarise(totaldf=sum(PA_QTDAPR))

# Leitura dos dados coletados no SIA-SUS A221644189_28_143_208.csv
# Um arquivo auxiliar foi preparado sem as informacoes de datas de aquisicao
# no TabNet.
dftabnet <- read_csv("data/A221644189_28_143_208_ref_check.csv", 
                      col_types = cols(ano = col_character()))

library(DT)
verificacao <- inner_join(dfortoc,dftabnet,c("ANO"="ano"))
names(verificacao) <- c(" ","Banco ISC","TAbNet") 
datatable(verificacao)



# Escrita em formato compativel com stata 

library(foreign)



dforto_anual <- dforto %>% group_by(ANO,
                     UF,
                     PA_UFMUN,
                     NOME_MUN,           
                     PA_PROC_ID,
                     procedimentos,
                     PA_NAT_JUR,
                     NAT_JUR_DESCRICAO,
                     PA_CONDIC,
                     PA_CONDIC_ref) %>%
  summarise(PA_QTDPRO_SUM_ANUAL = sum(PA_QTDPRO),
            PA_QTDAPR_SUM_ANUAL = sum(PA_QTDAPR))

write.dta(dforto_anual,file = 'dforto_anual.dta')
write.csv2(dforto_anual,file = 'dforto_anual.csv')
save(dforto_anual,file = 'dforto_anual.RData')
write_parquet(dforto_anual,'dforto_anual.parquet')



