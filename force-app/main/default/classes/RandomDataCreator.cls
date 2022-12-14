public with sharing class RandomDataCreator {
    public static void createAccounts() {
        List<Account> acc = new List<Account>();
        for (Integer i = 1; i < 6; i++) {
            Account a = new Account(
                Name = 'Test Account ' + i
            );
            acc.add(a);
        }
        insert acc;
    }

    public static void createOrders() {
        List<Order__c> orders = new List<Order__c>();
        List<Account> acc = [SELECT Id
                             FROM Account
                             WHERE Name LIKE 'Test Account%'
                             LIMIT 100];
        Integer num = 1;
        for (Account item : acc) {
            for (Integer i = 0; i < 8; i++) {
                Order__c order = new Order__c(
                    Name = 'Test Order Number: ' + num,
                    Total_Amount__c = Integer.valueOf(1000 * Math.random() + 1) * 10,
                    Payment_Due_Date__c = Date.today().addDays(Integer.valueOf(Math.random() * 25)).addMonths(Integer.valueOf(Math.random() * 12)),
                    Account__c = item.Id
                );
                num++;
                orders.add(order);
            }
        }
        insert orders;
    }
}