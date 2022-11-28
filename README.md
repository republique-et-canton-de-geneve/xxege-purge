# XXEGE_PURGE

Description in English: [here](#English).

Description en français : [ici](#Français).

## English

This project contains a program intended to purge data from a OSB/SOA Suite database instance (Oracle Service Bus/Oracle SOA Suite).

It contains:
- a PL/SQL package that can delete OSB report data and SOA instances, which can take place in the database
- a SQL control script to check if the package has done the job correctly

### Installation

The package installs in an Oracle Database for Oracle SOA Suite 12.2, it is intended to be installed in the <prefix>_SOAINFRA schema.

### Usage

The program can be run from a database session as the <prefix>_SOAINFRA user, and requires the number of days of retention as the input parameter. The older OSB reports and inactive SOA instances will be deleted. For example, if you want to keep 100 days of history:

```
BEGIN
    xxege_purge.run_purge(100);
END;
```

### Credits

We have been using a monitoring strategy inpired from J@n van Zoggel since version 11.1 https://jvzoggel.com/2012/01/18/osb_tracing_report_action, and we have developed this purge program based on Demed L’Her and Sai Sudarsan presentation "Purging strategies in Oracle SOA Suite 11gR1 PS3" and ported it on version 12.2.

Oracle 12.2 Documentation : https://docs.oracle.com/cloud/latest/soa121300/SOAAG/GUID-DBCFFB8F-3B67-4000-9F48-404D16D503DD.htm#GUID-276E36C1-73B0-4044-8707-BACE17F3D594

## Français

Ce projet contient un programme de Purge des données pour OSB/SOA Suite (Oracle Service Bus/Oracle SOA Suite).

Ce projet contient 2 parties:
- un package PL/SQL permettant de purger les rapports OSB et les instances SOA qui peuvent encombrer la base de données
- un script SQL permettant de contrôler que le package fait le travail qui lui est demandé

### Installation

Dans une instance Oracle Database pour Oracle SOA Suite 12.2, ce package est à installer dans le schéma <préfixe>_SOAINFRA.

### Utilisation

Pour l'exécuter, il faut ouvrir une session de base de données en tant que <préfixe>_SOAINFRA, et spécifier le nombre de jours de rétention que l'on souhaite conserver. Les rapports OSB et les instance SOA inactives depuis plus longtemps seront supprimées. Par exemple, si on souhaite conserver 100 jours d'historique:

```
BEGIN
    xxege_purge.run_purge(100);
END;
```

### Crédits

Nous utilisons une méthode de trace des messages insprirée de J@n van Zoggel depuis la version 11.1 https://jvzoggel.com/2012/01/18/osb_tracing_report_action, et nous avons développé ce programme en nous basant sur les travaux de Demed L’Her, Sai Sudarsan "Purging strategies in Oracle SOA Suite 11gR1 PS3" puis nous l'avons porté en version 12.2.

Documentation Oracle 12.2 : https://docs.oracle.com/cloud/latest/soa121300/SOAAG/GUID-DBCFFB8F-3B67-4000-9F48-404D16D503DD.htm#GUID-276E36C1-73B0-4044-8707-BACE17F3D594