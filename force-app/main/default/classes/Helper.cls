public with sharing class Helper {
    public Helper() {

    }

    public static string recuperaToken()
    { 
        SIGECO__c dadoToken = SIGECO__c.getOrgDefaults();   
        String Cache_token = dadoToken.token__c + dadoToken.token2__c;
        return Cache_token;
    }

    public static DateTime arrumaData(String data)
    {
        String ano = data.mid(0,4);
        String mes = data.mid(5,2);
        String dia = data.mid(8,2);
        String hora = data.mid(11,2);
        String minuto = data.mid(14,2);
        String segundo = data.mid(17,2);
        String data2 = ano + '-' + mes + '-' + dia + ' ' + hora + ':' + minuto + ':' + segundo;
        DateTime dataArrumada = DateTime.valueOf(data2);
        return dataArrumada;
    }
}
