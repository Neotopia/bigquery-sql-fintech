# BigQuery SQL – Analyses Fintech

Requêtes SQL sur des données financières simulées, écrites et commentées en français.  
Projet réalisé dans le cadre d'une montée en compétences vers des rôles **Data Analyst / Analytics Engineer**.

**Stack :** Google BigQuery · SQL standard · Window Functions

---

## Structure du repo

```
bigquery-sql-fintech/
└── sql/
    ├── 01_dataset_transactions.sql   → Création du jeu de données (inline, sans table)
    ├── 02_window_functions_bases.sql → Enrichir la table via des fonctions Window
```

---

## Comment utiliser ces requêtes

1. Ouvrir [BigQuery Sandbox](https://console.cloud.google.com/bigquery)
2. Créer un nouveau projet si nécessaire
3. Copier-coller le jeu de donnée disponible dans le fichier 01_dataset_transactions.sql dans l'éditeur BigQuery. Cela permettra que les requêtes soient auto-contenues (les données sont définies directement dans des CTEs `WITH`, pas besoin de créer ou importer des tables)
4. Dans le même éditeur, coller ensuite la requête voulue depuis
   `02_window_functions_bases.sql` **sous** le bloc WITH du fichier 01
5. Cliquer **Exécuter**

---

## Concepts couverts

| Fichier | Fonctions SQL |
|---------|--------------|
| `01_dataset_transactions.sql | 50 transactions fictives sur 5 clients, 3 mois, thème fintech (salaire, loyer, loisirs...) — auto-contenu, aucune table à créer
| `02_window_functions_bases.sql` | Trie et enrichissement de la table de donnée

---

## Auteure

**Lisa Momas** – Digital Analytics & Data  
[LinkedIn](https://www.linkedin.com/in/lisa-momas)
