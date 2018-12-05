global with sharing class Connect_PendenciaInit implements Schedulable
{
    public String token{get;set;}

    global void execute(SchedulableContext SC)
    {
        token = Helper.recuperaToken();
        contarPedidosPendencia();
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
            System.debug(resp.getBody());
            Map<String,Object> mapResp = (Map<String,Object>)JSON.deserializeUntyped(resp.getBody());
            Integer quantidadePedidos = Integer.valueOf(mapResp.get('Total'));

            Id jobId = System.enqueueJob(new Connect_Pendencia(quantidadePedidos,0));
        }
    }
}