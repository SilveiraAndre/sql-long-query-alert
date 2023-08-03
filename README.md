# SQL Server Query Execution Alert Script 

## Esse é um procedimento armazenado que monitora e envia alertas via e-mail para consultas em execução a mais de 10 minutos.

## Uso
1.  Abra o SSMS em seu computador e conecte em sua instância de servidor;
2.  Execute o script de título @nome em seu banco de dados. O script irá criar um procedimento armazenado com nome @nome;
3.  Configuração para envio de e-mail:
   - No final da procedure, será necessário alterar o nome de usuário do sysmail de acordo com seu usuário configurado;
   - Alterar a variável @recipients com seus destinatários de preferência;

## Observações
1. O script faz uso de tabelas temporárias para processar e armazenar dados;
2. Execute o script em um ambiente controlado antes de rodá-lo em seu banco de produção;
3. Lembre-se de alterar as informações no body de html de acordo com suas preferências e caso inclua alguma coluna na tempdb #LOG;

##License 
This script is provided under the [MIT LICENSE](License).


