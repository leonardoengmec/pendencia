global with sharing class Connect_PendenciaController {
   
    @RemoteAction
    global static List<pendencia__c> pendenciasPorCategoria(String categoria){
        List<pendencia__c> pendencias = [select Id, 
                                        CreatedDate, 
                                        produto__r.Name,
                                        produto__r.nome__c,
                                        produto__r.giro__c,
                                        produto__r.classe__c,
                                        produto__r.marca__c,
                                        produto__r.grupo__c,
                                        produto__r.codigoFornecedor__c,
                                        status__c,
                                        statusCompras__c,
                                        statusAtendimento__c,
                                        previsaoEntrega__c,
                                        observacao__c,
                                        pedidoCompra__c,
                                        notaFiscal__c,
                                        fornecedores__c,
                                        transportadora__c,
                                        pedidoMaisAntigo__c,
                                        quantidadeNota__c
                                        from pendencia__c
                                        where produto__r.categoria__c = :categoria and
                                        status__c = 'Em aberto'];
        return pendencias;
    }

    @RemoteAction
    global static List<__c> buscarProduto(String DK){

    }
}