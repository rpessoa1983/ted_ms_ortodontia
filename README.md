# Dados para avaliação executiva

Os dados do SIASUS utilizados nesta consulta estão disponíveis no servidor do ISC-UFBA
no formato .parquet 
para as competências de jan/2008 ('200801') à dez/2021 ('202112'). Os seguintes procedimentos 
foram realizados para acessá-los, filtrá-los e compatibilizá-los com uma linguagem descritiva
(os dados do servidor estão disponíveis por meio de códigos.)

a. Utilizando a linguagem *Python* e biblioteca *Pyspark* os dados do arquivo **sia_2008a2021.parquet**
foram lidos. 
b. Em seguida, foi realizado o filtro do banco por meio da variável **PA_PROC_ID** para os *procedimentos de próteses* :

- *0701070099 PROTESE PARCIAL MANDIBULAR REMOVIVEL*,
- *0701070102 PROTESE PARCIAL MAXILAR REMOVIVEL*,
- *0701070110 PROTESE TEMPORARIA*,
- *0701070129 PROTESE TOTAL MANDIBULAR*,
- *0701070137 PROTESE TOTAL MAXILAR*,
- *0701070145 PROTESES CORONARIAS / INTRA-RADICULARES FIXAS / ADESIVAS (POR ELEMENTO)*.

c. Depois, foram selecionadas as variáveis:
**PA_UFMUN**,**PA_CODUNI**,**PA_CMP**,**PA_PROC_ID**,**PA_CBOCOD**,**PA_CONDIC**,
**PA_QTDPRO**, **PA_QTDAPR**, **PA_NAT_JUR**. 

d. Por meio da variável **PA_CMP** (competências) foi criada a variável **ANO**.

e. A variável **PA_CONDIC** (Sigla do Tipo de Gestão no qual o Estado ou Município está habilitado)
foi transformada em categorias por meio da sua descrição disponível no 
[Manual Operacional do SIA](ftp://arpoador.datasus.gov.br/siasus/documentos/Manual_Operacional_SIA_V_1_1.pdf). 

f. As variáveis **PA_UFMUN**,**PA_CODUNI**,**PA_PROC_ID**,**PA_CBOCOD**,**PA_CONDIC** e  **PA_NAT_JUR**
foram transformadas em suas respectivas categorias descritivas por meio do arquivo disponível 
no servidor do DataSus em [CNES-DOMINIOS](http://cnes.datasus.gov.br/pages/downloads/documentacao.jsp).  
Quanto à variável **PA_PROC_ID** deu origem a variável **PROCEDIMENTOS** utilizando a descrição disponível 
no TabNet. 

g. Os dados foram agrupados por **ANO**, **PA_UFMUN**,**PA_CODUNI**,**PA_PROC_ID**,
**PA_CBOCOD**,**PA_CONDIC**, **PA_NAT_JUR** e **PROCEDIMENTOS** e as variáveis 
correpondentes as quantidades *produzidas* e *aprovadas* (**PA_QTDPRO**, **PA_QTDAPR**) 
de cada um desses procedimentos foi somada de acordo com tais categorias, dando origem às
seguintes variáveis  **PA_QTDPRO_SUM_ANUAL** e **PA_QTDAPR_SUM_ANUAL**. 

h. O arquivo de verificação dos totais anuais de procedimentos realizados foi obtido do Tabnet (A221644189_28_143_208.csv)
e foram utilizados para comparar com dos dados somados de todos os anos independente de outras categorias para  as 
**PA_QTDPRO_SUM_ANUAL** e **PA_QTDAPR_SUM_ANUAL**. 

h. Por fim, os dados foram registrados em 4 formatos diferentes com os seguintes nomes:

- dforto_anual.dta
- dforto_anual.RData
- dforto_anual.parquet
- dforto_anual.csv


## Fontes de categorias das variáveis 
As conversões se basearam em dois documentos principais: 

- [CNES-DOMINIOS](http://cnes.datasus.gov.br/pages/downloads/documentacao.jsp)
- DISSEMINAÇÃO DE DADOS EM SAÚDE SISTEMA DE INFORMAÇÕES AMBULATORIAIS DO SUS - SIASUS (Contém dicionário de dados.)
- [Manual do SIASUS](ftp://arpoador.datasus.gov.br/siasus/documentos/Manual_Operacional_SIA_V_1_1.pdf)

## Dicionário de dados 

- **UF** - CHAR (2) Unidade da Federação 
- **PA_UFMUN** CHAR (6) Unidade da Federação + Código do Município onde está localizado o estabelecimento
- **NOME_MUN** - Nome do município CHAR() 
- **PA_CMP** CHAR (6) Data da Realização do Procedimento / Competência (AAAAMM) 
- **PA_PROC_ID** CHAR (10) Código do Procedimento Ambulatorial 
- **PROCEDIMENTOS** - Código + descrição do procedimento 
- **PA_QTDPRO_SUM_ANUAL** NUMERIC (11) Quantidade Produzida SOMA ANUAL(APRESENTADA)
- **PA_QTDAPR_SUM_ANUAL** NUMERIC (11) Quantidade Aprovada do procedimento SOMA ANUAL 
- **PA_NAT_JUR** CHAR(4) Código da Natureza Juridica11 
- **NAT_JUR_DESCRICAO** - Natureza Jurídica - Descrição 
- **PA_CONDIC** CHAR (2) Sigla do Tipo de Gestão no qual o Estado ou Município está habilitado 
- **PA_CONDIC_ref**
