-- ============================================================
-- FICHIER 01 : Jeu de données simulé – Transactions bancaires
-- ============================================================
-- Description : Crée un dataset de transactions financières fictives
--               représentant les mouvements de 5 clients sur 6 mois.
--               Utilisé comme source dans tous les autres fichiers.
--
-- Colonnes :
--   transaction_id   → identifiant unique de la transaction
--   client_id        → identifiant du client (C001 à C005)
--   date_transaction → date de la transaction
--   montant          → montant en euros (positif = crédit, négatif = débit)
--   type_transaction → virement_entrant, paiement_cb, retrait, virement_sortant
--   categorie        → salaire, loyer, alimentation, transport, loisirs, abonnement
-- ============================================================

-- Ce CTE (Common Table Expression) définit les données directement dans la requête.
-- Pas besoin de créer une vraie table – tu peux copier-coller et exécuter immédiatement.

WITH transactions AS (
  SELECT 'TXN001' AS transaction_id, 'C001' AS client_id, DATE '2024-01-05' AS date_transaction,  2800.00 AS montant, 'virement_entrant'  AS type_transaction, 'salaire'       AS categorie UNION ALL
  SELECT 'TXN002', 'C001', DATE '2024-01-07',  -950.00, 'virement_sortant', 'loyer'          UNION ALL
  SELECT 'TXN003', 'C001', DATE '2024-01-12',   -85.40, 'paiement_cb',      'alimentation'   UNION ALL
  SELECT 'TXN004', 'C001', DATE '2024-01-18',   -42.00, 'paiement_cb',      'transport'      UNION ALL
  SELECT 'TXN005', 'C001', DATE '2024-01-25',  -120.00, 'paiement_cb',      'loisirs'        UNION ALL
  SELECT 'TXN006', 'C001', DATE '2024-02-05',  2800.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN007', 'C001', DATE '2024-02-08',  -950.00, 'virement_sortant', 'loyer'          UNION ALL
  SELECT 'TXN008', 'C001', DATE '2024-02-14',   -67.20, 'paiement_cb',      'alimentation'   UNION ALL
  SELECT 'TXN009', 'C001', DATE '2024-02-20',   -35.90, 'paiement_cb',      'abonnement'     UNION ALL
  SELECT 'TXN010', 'C001', DATE '2024-03-05',  2800.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN011', 'C002', DATE '2024-01-03',  3500.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN012', 'C002', DATE '2024-01-06', -1200.00, 'virement_sortant', 'loyer'          UNION ALL
  SELECT 'TXN013', 'C002', DATE '2024-01-10',  -210.50, 'paiement_cb',      'alimentation'   UNION ALL
  SELECT 'TXN014', 'C002', DATE '2024-01-15',  -580.00, 'paiement_cb',      'loisirs'        UNION ALL
  SELECT 'TXN015', 'C002', DATE '2024-01-22',   -89.00, 'paiement_cb',      'transport'      UNION ALL
  SELECT 'TXN016', 'C002', DATE '2024-02-03',  3500.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN017', 'C002', DATE '2024-02-09', -1200.00, 'virement_sortant', 'loyer'          UNION ALL
  SELECT 'TXN018', 'C002', DATE '2024-02-16',  -145.00, 'paiement_cb',      'alimentation'   UNION ALL
  SELECT 'TXN019', 'C002', DATE '2024-03-03',  3500.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN020', 'C002', DATE '2024-03-07', -1200.00, 'virement_sortant', 'loyer'          UNION ALL
  SELECT 'TXN021', 'C003', DATE '2024-01-02',  1800.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN022', 'C003', DATE '2024-01-05',  -700.00, 'virement_sortant', 'loyer'          UNION ALL
  SELECT 'TXN023', 'C003', DATE '2024-01-11',   -55.30, 'paiement_cb',      'alimentation'   UNION ALL
  SELECT 'TXN024', 'C003', DATE '2024-01-19',  -200.00, 'retrait',          'loisirs'        UNION ALL
  SELECT 'TXN025', 'C003', DATE '2024-02-02',  1800.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN026', 'C003', DATE '2024-02-06',  -700.00, 'virement_sortant', 'loyer'          UNION ALL
  SELECT 'TXN027', 'C003', DATE '2024-02-13',   -48.90, 'paiement_cb',      'alimentation'   UNION ALL
  SELECT 'TXN028', 'C003', DATE '2024-02-21',   -25.00, 'paiement_cb',      'abonnement'     UNION ALL
  SELECT 'TXN029', 'C003', DATE '2024-03-02',  1800.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN030', 'C003', DATE '2024-03-10',  -300.00, 'paiement_cb',      'loisirs'        UNION ALL
  SELECT 'TXN031', 'C004', DATE '2024-01-04',  4200.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN032', 'C004', DATE '2024-01-08', -1500.00, 'virement_sortant', 'loyer'          UNION ALL
  SELECT 'TXN033', 'C004', DATE '2024-01-13',  -320.00, 'paiement_cb',      'alimentation'   UNION ALL
  SELECT 'TXN034', 'C004', DATE '2024-01-20',  -850.00, 'paiement_cb',      'loisirs'        UNION ALL
  SELECT 'TXN035', 'C004', DATE '2024-01-28',  -200.00, 'paiement_cb',      'transport'      UNION ALL
  SELECT 'TXN036', 'C004', DATE '2024-02-04',  4200.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN037', 'C004', DATE '2024-02-10', -1500.00, 'virement_sortant', 'loyer'          UNION ALL
  SELECT 'TXN038', 'C004', DATE '2024-02-17',  -410.00, 'paiement_cb',      'alimentation'   UNION ALL
  SELECT 'TXN039', 'C004', DATE '2024-02-24',  -980.00, 'paiement_cb',      'loisirs'        UNION ALL
  SELECT 'TXN040', 'C004', DATE '2024-03-04',  4200.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN041', 'C005', DATE '2024-01-06',  2200.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN042', 'C005', DATE '2024-01-09',  -800.00, 'virement_sortant', 'loyer'          UNION ALL
  SELECT 'TXN043', 'C005', DATE '2024-01-14',   -92.10, 'paiement_cb',      'alimentation'   UNION ALL
  SELECT 'TXN044', 'C005', DATE '2024-01-23',   -55.00, 'paiement_cb',      'abonnement'     UNION ALL
  SELECT 'TXN045', 'C005', DATE '2024-02-06',  2200.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN046', 'C005', DATE '2024-02-10',  -800.00, 'virement_sortant', 'loyer'          UNION ALL
  SELECT 'TXN047', 'C005', DATE '2024-02-18',  -110.40, 'paiement_cb',      'alimentation'   UNION ALL
  SELECT 'TXN048', 'C005', DATE '2024-02-25',  -480.00, 'paiement_cb',      'loisirs'        UNION ALL
  SELECT 'TXN049', 'C005', DATE '2024-03-06',  2200.00, 'virement_entrant', 'salaire'        UNION ALL
  SELECT 'TXN050', 'C005', DATE '2024-03-12',  -800.00, 'virement_sortant', 'loyer'
)

-- Affiche toutes les transactions pour vérifier le dataset
SELECT *
FROM transactions
ORDER BY client_id, date_transaction;

-- ✅ Résultat attendu : 50 lignes, 5 clients, transactions de janvier à mars 2024
-- 💡 Ce CTE "transactions" sera réutilisé dans les fichiers 02 et 03 comme base de données
