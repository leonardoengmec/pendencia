@isTest
public class Connect_PendenciaTest {
    
    @isTest
    static void deveriaRetornarTotal(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('respContarPedido');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Connect_Pendencia pend = new Connect_Pendencia();
        pend.contarPedidosPendencia();

        System.assertEquals(1305, pend.quantidadePedidos);
    }

}
