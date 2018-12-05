global with sharing class Connect_Pendencia implements Queueable, Database.AllowsCallouts
{
    public Integer quantidadePedidos{get;set;}
    public Integer deslocamento{get;set;}
    public String token{get;set;}
    public List<classePedido> listaPedidosPendencia{get;set;}
    public List<DK__c> listaProdutoPendencia{get;set;}
    public List<pendencia__c> listaPendencia{get;set;}
    
    final Integer limite = 50;

    public Connect_Pendencia(Integer quantidadePedidos, Integer deslocamento) {
        this.quantidadePedidos = quantidadePedidos;
        this.deslocamento = deslocamento;
        
        token = Helper.recuperaToken();
        
    }

    public void execute(QueueableContext context){
        capturaPedidosPendencia();
        capturaProdutos();
        enfileiraProximaExecucao();
    }

    public void capturaPedidosPendencia(){
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.connectparts.com.br:8032/fenix/Pedido/Listar?statusCodigo=8%2C9' + 
                        '&limite=' + limite + 
                        '&deslocamento=' + deslocamento);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        req.setHeader('Accept', '*/*');
        req.setHeader('Authorization', 'Bearer ' + token);
        
        Http h = new Http();
        HttpResponse resp = h.send(req);

        if(resp.getStatusCode() == 200){
            List<Object> listaPedidos = (List<Object>)JSON.deserializeUntyped(resp.getBody());
            listaPedidosPendencia = new List<classePedido>();

            for(Object obj: listaPedidos){
                Map<String,Object> mapPedido = (Map<String,Object>)obj;       
                Map<String,Object> mapCanalVenda = (Map<String,Object>)mapPedido.get('CanalVenda');        
                Map<String,Object> mapSubCanalVenda = (Map<String,Object>)mapCanalVenda.get('Subcanal');

                classePedido pedido = new classePedido();
                pedido.numeroPedido = String.valueOf(mapPedido.get('CodigoExterno'));
                pedido.canalVenda = String.valueOf(mapCanalVenda.get('Nome')) + ' - ' + String.valueOf(mapSubCanalVenda.get('Nome')) ;
                pedido.dataVenda = String.valueOf(mapPedido.get('DataVenda'));
                
                System.debug('Pedido: ' + pedido);
                listaPedidosPendencia.add(pedido);
                System.debug('Lista: ' + listaPedidosPendencia);
            }
        }
    }

    public void capturaProdutos(){

        for(classePedido ped: listaPedidosPendencia){

            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://api.connectparts.com.br:8032/fenix/PedidoItem/Listar?pedidoCodigoExterno=' + ped.numeroPedido);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json; charset=utf-8');
            req.setHeader('Accept', '*/*');
            req.setHeader('Authorization', 'Bearer ' + token);
            
            Http h = new Http();
            HttpResponse resp = h.send(req);

            if(resp.getStatusCode() == 200){
                List<Object> listaProdutos = (List<Object>)JSON.deserializeUntyped(resp.getBody());
                listaProdutoPendencia = new List<DK__c>();

                for(Object obj: listaProdutos){
                    Map<String,Object> mapItemPedido = (Map<String,Object>)obj;

                    if(Integer.valueOf(mapItemPedido.get('QuantidadeReservada')) == 0){

                        Map<String,Object> mapProduto = (Map<String,Object>)mapItemPedido.get('Produto');
                        Map<String,Object> mapDimensoes = (Map<String,Object>)mapProduto.get('Dimensoes');
                        Map<String,Object> mapMarca = (Map<String,Object>)mapProduto.get('Marca');
                        Map<String,Object> mapGrupo = (Map<String,Object>)mapProduto.get('Grupo');
                        Map<String,Object> mapClasse = (Map<String,Object>)mapProduto.get('Classe');

                        DK__c produto = new DK__c();
                        produto.codigo__c = String.valueOf(mapProduto.get('Codigo'));
                        produto.Name = String.valueOf(mapProduto.get('CodigoExterno'));
                        produto.codigoPai__c = String.valueOf(mapProduto.get('CodigoPai'));
                        produto.codigoBarras__c = String.valueOf(mapProduto.get('Ean'));
                        produto.nome__c = String.valueOf(mapProduto.get('Nome'));
                        produto.descricao__c = String.valueOf(mapProduto.get('Descricao'));
                        produto.marca__c = String.valueOf(mapMarca.get('Nome'));
                        produto.classe__c = String.valueOf(mapClasse.get('Nome'));
                        produto.grupo__c = String.valueOf(mapGrupo.get('Nome'));
                        produto.altura__c = Integer.valueOf(mapDimensoes.get('Altura'));
                        produto.comprimento__c = Integer.valueOf(mapDimensoes.get('Comprimento'));
                        produto.largura__c = Integer.valueOf(mapDimensoes.get('Largura'));
                        produto.peso__c = Integer.valueOf(mapDimensoes.get('Peso'));
                        produto.volume__c = Integer.valueOf(mapDimensoes.get('Volume'));
                        
                        listaProdutoPendencia.add(produto);
                        
                        //produto.nomePai__c = String.valueOf(mapProduto.get('CodigoExterno'));
                        //produto.categoria__c = String.valueOf(mapProduto.get('CodigoExterno'));
                        //produto.custoBruto__c = String.valueOf(mapProduto.get('CodigoExterno'));
                        //produto.custoLiquido__c = String.valueOf(mapProduto.get('CodigoExterno'));
                    }
                }
            }
        }

        upsert listaProdutoPendencia Name;

        listaPendencia = new List<pendencia__c>();

        for(DK__c dk: listaProdutoPendencia){

            List<pendencia__c> procurarPendencia = [select Id
                                                    from pendencia__c
                                                    where produto__r.Name = :dk.Name 
                                                    and status__c = 'Em aberto']; 
            // Procura se já existe um evento de pendencia em aberto do DK
            if(procurarPendencia.size() == 0){
                pendencia__c pendencia = new pendencia__c();
                pendencia.produto__c = dk.Id;
                pendencia.status__c = 'Em aberto';
                listaPendencia.add(pendencia);
            }
        }
        
        insert listaPendencia;
    }

    public void enfileiraProximaExecucao(){
        if(quantidadePedidos > (deslocamento + limite)){
            Id jobId = System.enqueueJob(new Connect_Pendencia(quantidadePedidos,deslocamento + limite));
        }
    }

    public with sharing class classePedido{
        public String numeroPedido{get;set;}
        public String canalVenda{get;set;}
        public String dataVenda{get;set;}
    }
}
