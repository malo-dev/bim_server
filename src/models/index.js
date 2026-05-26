import User from './User.model.js';
import Role from './Role.model.js';
import UserRole from './UserRole.model.js';
import Product from './product.model.js';
import ProductCategory from './ProductCategory.model.js';
import Currency from './currency.model.js';
import Category from './categorie.model.js';
import ProductSold from './productSold.model.js';
import BranchTrack from './branchTrack.model.js';
import Commerce from './commerce.model.js';
import ClientTrack from './clientTrack.js';
import ExpeTrack from './expetrack.model.js';
import Notification from './notification.model.js';
import Redevtrack from './redevtrack.model.js';
import FeedBackTrack from './feedbackTrack.model.js';
import SupportTrack from './supportTrack.model.js';
import History from './history.model.js';

import BusinessCategory from './businessCategory.js';
import Company from './company.model.js';
import Bonus from './bonusTrack.model.js';

import Transaction from './transaction.model.js';
import TransactionRetrait from './TransactionRetrait.model.js';
import TransactionTransfert from './transfertTransaction.model.js';
import TransactionRecharge from './transactionRecharge.model.js';
import TransactionPaiement from './paiementTrasanction.model.js';
import Order from './order.model.js';

import Notes from './notes.model.js';
import Livreur from './livreur.model.js';
import LivreurRating from './livreurRating.model.js';
import LivreurSOS from './livreurSOS.model.js';
import UserSOS from './userSOS.model.js';

const CASCADE   = { onDelete: 'CASCADE', onUpdate: 'CASCADE' };
const SET_NULL  = { onDelete: 'SET NULL', onUpdate: 'CASCADE' };


// ================= TRANSACTIONS =================

Transaction.belongsTo(User, { foreignKey: "id", as: "user", ...CASCADE });
User.hasMany(Transaction, { foreignKey: "id", as: "transactions", ...CASCADE });

// TransactionRetrait: FK field is "id" (references users.id)
TransactionRetrait.belongsTo(User, { foreignKey: "id", as: "sender", ...CASCADE });
User.hasMany(TransactionRetrait, { foreignKey: "id", as: "retraits", ...CASCADE });

TransactionTransfert.belongsTo(User, { foreignKey: "senderId", ...CASCADE });
User.hasMany(TransactionTransfert, { foreignKey: "senderId", ...CASCADE });

// TransactionRecharge: FK field is "id" (references users.id)
TransactionRecharge.belongsTo(User, { foreignKey: "id", as: "user", ...CASCADE });
User.hasMany(TransactionRecharge, { foreignKey: "id", as: "recharges", ...CASCADE });

TransactionPaiement.belongsTo(User,    { foreignKey: "userId",    as: "payer",   ...CASCADE });
TransactionPaiement.belongsTo(Company, { foreignKey: "companyId", as: "company", ...SET_NULL });
TransactionPaiement.belongsTo(Product, { foreignKey: "productId", as: "product", ...SET_NULL });
User.hasMany(TransactionPaiement, { foreignKey: "userId", as: "paiements", ...CASCADE });


// ================= PRODUITS & ENTREPRISE =================

// Produit → Entreprise
Product.belongsTo(Company, { foreignKey: "companyId", as: 'company', ...CASCADE });
Company.hasMany(Product, { foreignKey: "companyId", as: 'products', ...CASCADE });

// Entreprise → Catégorie business
Company.belongsTo(BusinessCategory, { foreignKey: "businessId", as: 'category', ...CASCADE });
BusinessCategory.hasMany(Company, { foreignKey: "businessId", as: 'companies', ...CASCADE });

// Bonus
Bonus.belongsTo(User, { foreignKey: "userId", ...CASCADE });
Bonus.belongsTo(Company, { foreignKey: "companyId", ...CASCADE });

User.hasMany(Bonus, { foreignKey: "userId", ...CASCADE });
Company.hasMany(Bonus, { foreignKey: "companyId", ...CASCADE });


// ================= ROLES =================

User.belongsToMany(Role, {
  through: UserRole,
  foreignKey: 'userId',
  as: 'role',
  ...CASCADE
});

Role.belongsToMany(User, {
  through: UserRole,
  foreignKey: 'roleId',
  ...CASCADE
});


// ================= PRODUITS & CATEGORIES =================

Product.belongsToMany(Category, {
  through: ProductCategory,
  foreignKey: 'productId',
  as: 'categories',
  ...CASCADE
});

Category.belongsToMany(Product, {
  through: ProductCategory,
  foreignKey: 'categoryId',
  as: 'products',
  ...CASCADE
});


// ================= DEVISES =================

Product.belongsTo(Currency, {
  foreignKey: 'currencyId',
  as: 'currency',
  ...CASCADE
});

Currency.hasMany(Product, {
  foreignKey: 'currencyId',
  as: 'products',
  ...CASCADE
});

ProductSold.belongsTo(Currency, {
  foreignKey: 'currencyId',
  as: 'currency',
  ...CASCADE
});

Currency.hasMany(ProductSold, {
  foreignKey: 'currencyId',
  as: 'productsSold',
  ...CASCADE
});


// ================= VENTES PRODUITS =================

Product.hasMany(ProductSold, { foreignKey: 'productId', as: 'productSold', ...CASCADE });

ProductSold.belongsTo(Product, {
  foreignKey: 'productId',
  as: 'product',
  ...CASCADE
});


// ================= COMMERCE =================

User.hasMany(Commerce, { foreignKey: 'commerceId', as: 'commerce', ...CASCADE });

Commerce.belongsTo(User, {
  foreignKey: 'commerceId',
  as: 'user',
  ...CASCADE
});

Commerce.hasMany(BranchTrack, { foreignKey: 'commerceId', as: 'branchTrack', ...CASCADE });

BranchTrack.belongsTo(Commerce, {
  foreignKey: 'commerceId',
  as: 'commerce',
  ...CASCADE
});


// ================= TRACK =================

User.hasMany(BranchTrack, { foreignKey: 'branchTrackId', as: 'branchTrack', ...CASCADE });

BranchTrack.belongsTo(User, {
  foreignKey: 'branchTrackId',
  as: 'user',
  ...CASCADE
});


// ================= HISTORY =================

History.belongsTo(User, { foreignKey: 'userId', as: 'user', ...CASCADE });
User.hasMany(History, { foreignKey: 'userId', as: 'histories', ...CASCADE });


// ================= NOTIFICATIONS =================

User.hasMany(Notification, { foreignKey: 'userId', ...CASCADE });
Notification.belongsTo(User, { foreignKey: 'userId', ...CASCADE });

Commerce.hasMany(Notification, { foreignKey: 'commerceId', ...CASCADE });
Notification.belongsTo(Commerce, { foreignKey: 'commerceId', ...CASCADE });

ExpeTrack.hasMany(Notification, { foreignKey: 'expeTrackId', ...CASCADE });
Notification.belongsTo(ExpeTrack, { foreignKey: 'expeTrackId', ...CASCADE });

BranchTrack.hasMany(Notification, { foreignKey: 'branchTrackId', ...CASCADE });
Notification.belongsTo(BranchTrack, { foreignKey: 'branchTrackId', ...CASCADE });


// ================= EXPORT =================

// ================= SUPPORT ================

SupportTrack.belongsTo(User, { foreignKey: 'id', as: 'user', ...CASCADE });
User.hasMany(SupportTrack, { foreignKey: 'id', as: 'supportTracks', ...CASCADE });

// ================= ORDERS =================

Order.belongsTo(User,    { foreignKey: 'userId',    as: 'user',    ...SET_NULL });
Order.belongsTo(Company, { foreignKey: 'companyId', as: 'company', ...CASCADE  });
Order.belongsTo(Product, { foreignKey: 'productId', as: 'product', ...CASCADE  });

User.hasMany(Order,    { foreignKey: 'userId',    as: 'orders' });
Company.hasMany(Order, { foreignKey: 'companyId', as: 'companyOrders' });
Product.hasMany(Order, { foreignKey: 'productId', as: 'productOrders' });


// ================= NOTES =================

Notes.belongsTo(User,    { foreignKey: 'userId',    as: 'user',    ...SET_NULL });
Notes.belongsTo(Company, { foreignKey: 'companyId', as: 'company', ...CASCADE  });
Notes.belongsTo(Product, { foreignKey: 'productId', as: 'product', ...SET_NULL });

User.hasMany(Notes,    { foreignKey: 'userId',    as: 'notes' });
Company.hasMany(Notes, { foreignKey: 'companyId', as: 'notes' });
Product.hasMany(Notes, { foreignKey: 'productId', as: 'notes' });

// ================= ORDERS → LIVREUR =================

Order.belongsTo(Livreur, { foreignKey: 'livreurId', as: 'livreur', ...SET_NULL });
Livreur.hasMany(Order,   { foreignKey: 'livreurId', as: 'deliveries' });

// ================= LIVREURS =================

Livreur.belongsTo(User,    { foreignKey: 'userId',    as: 'user',    ...CASCADE });
Livreur.belongsTo(Company, { foreignKey: 'companyId', as: 'company', ...SET_NULL });
User.hasMany(Livreur,    { foreignKey: 'userId',    as: 'livreurs' });
Company.hasMany(Livreur, { foreignKey: 'companyId', as: 'livreurs' });

LivreurRating.belongsTo(Livreur, { foreignKey: 'livreurId', as: 'livreur', ...CASCADE });
LivreurRating.belongsTo(User,    { foreignKey: 'userId',    as: 'rater',   ...CASCADE });
Livreur.hasMany(LivreurRating, { foreignKey: 'livreurId', as: 'ratings', ...CASCADE });

// ================= LIVREUR SOS =================

LivreurSOS.belongsTo(Livreur, { foreignKey: 'livreurId', as: 'livreur', ...CASCADE });
Livreur.hasMany(LivreurSOS,   { foreignKey: 'livreurId', as: 'alerts',  ...CASCADE });

// ================= USER SOS =================

UserSOS.belongsTo(User, { foreignKey: 'userId', as: 'user', ...CASCADE });
User.hasMany(UserSOS,   { foreignKey: 'userId', as: 'sosAlerts', ...CASCADE });

export {
  User,
  Role,
  UserRole,
  Product,
  Currency,
  Category,
  ProductCategory,
  ProductSold,
  Commerce,
  ClientTrack,
  ExpeTrack,
  Notification,
  Redevtrack,
  BranchTrack,
  FeedBackTrack,
  SupportTrack,
  History,
  Transaction,
  TransactionRetrait,
  TransactionTransfert,
  TransactionRecharge,
  TransactionPaiement,
  Bonus,
  Company,
  BusinessCategory,
  Order,
  Notes,
  Livreur,
  LivreurRating,
  LivreurSOS,
  UserSOS,
};