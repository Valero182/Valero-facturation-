# VALERO HÔTEL — Gestion & Facturation

Application web de facturation en français, pensée pour Valero Hôtel (Cotonou).

## Fonctions incluses
- Connexion administrateur via Supabase Auth.
- Sauvegarde distante des factures et paramètres.
- Historique et recherche de documents.
- Calcul des quantités, remises, taxes et soldes.
- Export PDF et impression.
- Numérotation automatique des documents côté base de données.

## Mise en ligne gratuite

### 1. Créer le projet Supabase
1. Crée un compte sur https://supabase.com et un projet.
2. Dans **SQL Editor**, ouvre `supabase/schema.sql`, colle tout son contenu et exécute-le.
3. Dans **Project Settings > API**, copie le **Project URL** et la clé publique **anon / publishable**.
   Ne copie jamais la clé `service_role` ou `secret` dans le site.

### 2. Créer l'administrateur
1. Dans Supabase, ouvre **Authentication > Users**.
2. Crée ton utilisateur avec ton adresse e-mail et un mot de passe robuste.
3. Pour un usage strictement personnel, ne crée pas d'autres utilisateurs.

### 3. Déployer sur Vercel
1. Crée un compte sur https://vercel.com.
2. Crée un dépôt GitHub et téléverse le contenu de ce dossier.
3. Dans Vercel, importe le dépôt.
4. Dans les paramètres de déploiement, choisis le dossier racine du projet. Le site est servi depuis `public/`.
   Si Vercel demande un réglage, configure le dossier de sortie `public` et laisse la commande de build vide.
5. Déploie. Vercel fournit une adresse gratuite en `vercel.app`.

### 4. Connecter l'application
1. Ouvre l'adresse Vercel.
2. Dans la configuration initiale, colle le Project URL et la clé publique Supabase.
3. Connecte-toi avec l'utilisateur administrateur créé dans Supabase.
4. Renseigne l'IFU et le RCCM de Valero Hôtel dans Paramètres.

## Sécurité et limites
- La clé publique Supabase est destinée au navigateur. La sécurité des données repose sur les règles RLS du fichier SQL.
- Les lignes sont limitées à l'utilisateur connecté par `auth.uid()`.
- Ne partage pas le compte administrateur.
- Active la confirmation e-mail dans Supabase si souhaité.
- Les taxes par défaut sont à 0 % : fais valider les taux et mentions fiscales applicables au Bénin par ton comptable avant émission officielle.
- Le logiciel ne remplace pas un système certifié de facturation normalisée ou les obligations fiscales applicables. Vérifie les exigences DGI du Bénin avant usage officiel.
- Le plan gratuit Supabase peut avoir des limites et mettre en pause certains projets inactifs. Consulte les conditions actuelles des fournisseurs.

## Personnalisation
Les coordonnées, IFU, RCCM et nom commercial sont modifiables dans Paramètres.
