-- ============================================================
-- FICHIER 02 : Window Functions – Les bases
-- ============================================================
-- Dataset : transactions bancaires fictives (5 clients, 3 mois) (CTE)
-- Objectif : utiliser les Window functions sur des cas d'usage financiers concrets.
--
-- 💡 Pour exécuter : copier UNE requête à la fois dans BigQuery,
--    depuis le CTE "transactions" disponible dans le fichier 01_dataset_transactions.sql jusqu'au SELECT final disponible dans ce fichier.
-- ============================================================


-- ─────────────────────────────────────────────────────────────
-- REQUÊTE 1 : ROW_NUMBER – Organiser les transactions par client
-- ─────────────────────────────────────────────────────────────
-- Cas d'usage : trouver la 1ère et la dernière transaction de chaque client pour étudier la durée de la relation client
-- ROW_NUMBER() attribue un numéro unique à chaque ligne dans une partition (groupe)



SELECT
  client_id,
  transaction_id,
  date_transaction,
  montant,

  -- Position de la transaction dans l'historique du client (1 = la plus ancienne)
  ROW_NUMBER() OVER w_client AS numero_transaction,

  -- Nombre total de transactions connues pour ce client
  COUNT(*) OVER w_client_total AS nb_transactions,

  -- Dates première et dernière transaction
  MIN(date_transaction) OVER w_client_total AS date_first_txn,
  MAX(date_transaction) OVER w_client_total AS date_last_txn

FROM transactions

WINDOW 
  w_client       AS (PARTITION BY client_id ORDER BY date_transaction ASC),
  w_client_total AS (PARTITION BY client_id)

ORDER BY client_id, date_transaction;

