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
-- REQUÊTE 1 : Enrichir les informations de transaction bancaire de client dans la table via des fonctions windows
-- ─────────────────────────────────────────────────────────────
-- Cas d'usage : 
--    - Trier et compter les transactions de chaque client pour étudier leur comportement d'achat
--    - Isoler la date de la 1ère et la dernière transaction de chaque client pour étudier la durée de la relation client
--    - Solde cumulé du client lors de la transaction pour détecter les pics de dépenses
--    - Rythme de dépense du client (jours entre 2 transactions) pour détecter les clients inactifs ou les changements de comportement




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
  MIN(date_transaction) OVER w_client_total AS date_premiere_txn,
  MAX(date_transaction) OVER w_client_total AS date_derniere_txn,

  -- Solde cumulé transaction par transaction pour détecter les pics de dépenses
  ROUND(SUM(montant) OVER w_solde, 2) AS solde_cumule,

  -- Montant de la transaction précédente du même client (pour détecter les sauts)
  LAG(montant) OVER w_client AS montant_precedent,

  -- Jours écoulés depuis la transaction précédente (rythme de dépense)
  DATE_DIFF(
    date_transaction,
    LAG(date_transaction) OVER w_client,
    DAY
  ) AS jours_depuis_precedente_txn

FROM transactions

WINDOW 
  w_client       AS (PARTITION BY client_id ORDER BY date_transaction ASC),
  w_client_total AS (PARTITION BY client_id),
  w_solde         AS (PARTITION BY client_id ORDER BY date_transaction ASC
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

ORDER BY client_id, date_transaction;

