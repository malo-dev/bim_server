# StockTrack Backend

**Gestion d’approvisionnement et Réapprovisionnement (StockTrack)** – Backend Server

## Description

Ce projet constitue le **backend d’une application de gestion de stock et de réapprovisionnement**. Il permet de gérer les produits, les rôles, les utilisateurs et leurs permissions.

Fonctionnalités principales :

- Gestion des rôles et permissions (CRUD)
- Gestion des utilisateurs
- Gestion des produits (CRUD, lecture par sous-blocs, téléchargement de tableaux)
- Suivi des stocks et des valeurs seuil
- API sécurisée avec JWT

## Technologies utilisées

- Node.js
- Express.js
- Sequelize (ou Mongoose pour MongoDB)
- MySQL (ou MongoDB)
- JWT pour l’authentification
- dotenv pour la configuration des variables d’environnement

## Installation

1. **Cloner le projet :**

```bash
git clone <URL_DU_REPO>
cd stocktrack-backend
```

2. **Installer les dépendances :**

```bash
npm install
```

3. **Créer un fichier `.env`** à la racine et y ajouter :

```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=yourpassword
DB_NAME=stocktrack
JWT_SECRET=your_jwt_secret
PORT=5000
```

4. **Lancer le serveur :**

```bash
npm run dev
```

## Structure du projet

```
stocktrack-backend/
├─ config/         # Configuration de la base de données
├─ controllers/    # Logique des endpoints
├─ models/         # Définition des modèles Sequelize/Mongoose
├─ routes/         # Définition des routes API
├─ middleware/     # Middlewares (auth, permissions, etc.)
├─ utils/          # Fonctions utilitaires
├─ .env
├─ package.json
└─ server.js       # Point d’entrée du serveur
```

## Endpoints principaux

### Authentification

- `POST /auth/login` – Connexion
- `POST /auth/register` – Création d’utilisateur

### Gestion des rôles

- `GET /roles` – Liste des rôles
- `POST /roles` – Créer un ou plusieurs rôles
- `PUT /roles/:id` – Modifier un rôle
- `DELETE /roles/:id` – Supprimer un rôle

### Gestion des produits

- `GET /products` – Liste des produits (avec pagination et filtres)
- `POST /products` – Ajouter un produit
- `PUT /products/:id` – Modifier un produit
- `DELETE /products/:id` – Supprimer un produit
- `GET /products/download` – Télécharger le tableau des produits

### Exemple JSON pour créer plusieurs rôles

```json
[
  {
    "name": "crud.secondMenu",
    "description": "Permet de lire, créer, modifier, supprimer et télécharger toutes les informations du Gestion d’approvisionnement et Réapprovisionnement (StockTrack)."
  },
  {
    "name": "create.secondMenu",
    "description": "Permet d'ajouter un nouveau produit."
  }
]
```

## Tests

Pour lancer les tests unitaires et d’intégration :

```bash
npm run test
```

## Contribution

1. Fork le projet
2. Crée une branche (`git checkout -b feature/ma-feature`)
3. Commit tes modifications (`git commit -m 'Ajout d'une fonctionnalité'`)
4. Push (`git push origin feature/ma-feature`)
5. Ouvre une Pull Request

## Licence

MIT License

---
