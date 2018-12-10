# SFDX  App

## Dev, Build and Test


## Resources
- [x] Duas vezes por dia, capturar os pedidos em pendência.
- [x] Para cada pedido, puxar os itens de pedidos que estão em pendência.
- [ ] Sinalizar Status por DK;
- [ ] Tratativa DK de Pendencia prazo de 24 horas;
- [ ] Similar/Substituto e Fora de Linha/Indisponível gerar termo no ato da sinalização;
- [ ] Status Em Negociação prazo 3 dias;
- [ ] Contato Pedido de Pendência Automático;

- [ ] Status Comprado preenchimento obrigatório dos campos abaixo:
    - [x] Previsão de Entrega;
    - [x] Pedido de Compra;
    - [x] Quantidade comprada;
    - [x] Nº NF – Campo não Obrigatório

- [ ] Relatório de Pendencias Automática;
- [ ] Relatório Separado Por Categorias;
- [ ] Relatório de Pedidos com mais de um DK na pendencia para Analise

## Regras de negócio
- Quando STATUS COMPRAS for vazio, prazo é de 24 horas para tratativa
    - Se no prazo: Status => Novo
    - Se fora do prazo: Status => Atrasado
- Quando STATAUS COMPRAS = 'Em negociação', prazo é de 3 dias úteis:
    - Se no prazo: Status => 'Em andamento'
    - Se fora do prazo: Status => Atrasado

## Description of Files and Directories

## Issues


