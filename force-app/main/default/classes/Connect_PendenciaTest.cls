@isTest
public with sharing class Connect_PendenciaTest {
    
    static testMethod void deveriaRetornarTotal(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        //mock.setStaticResource('respContarPedido');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Connect_Pendencia pend = new Connect_Pendencia();
        pend.contarPedidosPendencia();

        System.assertEquals(2265, pend.quantidadePedidos);
    }

}
