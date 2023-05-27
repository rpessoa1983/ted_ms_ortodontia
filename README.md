
# Dados para avaliação executiva

## Procedimentos de Próteses

- *0701070099 PROTESE PARCIAL MANDIBULAR REMOVIVEL*,
- *0701070102 PROTESE PARCIAL MAXILAR REMOVIVEL*,
- *0701070110 PROTESE TEMPORARIA*,
- *0701070129 PROTESE TOTAL MANDIBULAR*,
- *0701070137 PROTESE TOTAL MAXILAR*,
- *0701070145 PROTESES CORONARIAS / INTRA-RADICULARES FIXAS / ADESIVAS (POR ELEMENTO)*.

## Fontes de categorias das variáveis 
As conversões se basearam em dois documentos principais: 

[CNES-DOMINIOS](http://cnes.datasus.gov.br/pages/downloads/documentacao.jsp)

[Manual do SIASUS](ftp://arpoador.datasus.gov.br/siasus/documentos/Manual_Operacional_SIA_V_1_1.pdf)

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
