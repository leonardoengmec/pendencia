public with sharing class Connect_Pendencia {
    
    public Integer quantidadePedidos{get;set;}
    public String token = '123';
    
    public Connect_Pendencia() {

    }

    public void contarPedidosPendencia(){
        

        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.connectparts.com.br:8032/fenix/Pedido/Contar?statusCodigo=8%2C9');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        req.setHeader('Accept', '*/*');
        req.setHeader('Authorization', 'Bearer ' + token);
        
        Http h = new Http();
        HttpResponse resp = h.send(req);

        if(resp.getStatusCode() == 200){
            Map<String,Object> mapResp = (Map<String,Object>)JSON.deserializeUntyped(resp.getBody());
            Integer quantidadePedidos = Integer.valueOf(mapResp.get('Total'));
        }
    }

//fenix/Pedido/Contar?statusCodigo=8%2C9

    public void capturaPedidosPendencia(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.connectparts.com.br:8032/fenix/Pedido/Listar?statusCodigo=8%2C9');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        req.setHeader('Accept', '*/*');
        req.setHeader('Authorization', 'Bearer ' + token);
        
        Http h = new Http();
        HttpResponse resp = h.send(req);

        if(resp.getStatusCode() == 200){

        }

    }
}
