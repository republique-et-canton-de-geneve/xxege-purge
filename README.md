# XXEGE_PURGE

Purge OSB (Oracle Service Bus).

Ce projet contient 2 parties:
- un package PL/SQL permettant de purger les rapports OSB et les instances SOA qui peuvent encombrer la base de données
- un script SQL permettant de contrôler que le package fait le travail qui lui est demandé

Dans une instance Oracle Database pour Oracle SOA Suite 12.2 (fonctionne également avec 11.1), ce package est à installer dans le schéma <préfixe>_SOAINFRA.

Pour l'exécuter, il faut ouvrir une session dans la base en tant que <préfixe>_SOAINFRA, et spécifier le nombre de jours de rétention que l'on souhaite conserver. Les rapports OSB et les instance SOA inactives depuis plus longtemps seront supprimées. Par exemple, si on souhaite conserver 100 jours d'historique:

```
BEGIN
    xxege_purge.run_purge(100);
END;
```
