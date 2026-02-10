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

// ---------------------------
// User ↔ Role (many-to-many)
// ---------------------------
User.belongsToMany(Role, { through: UserRole, foreignKey: 'userId', as: 'roles' });
Role.belongsToMany(User, { through: UserRole, foreignKey: 'roleId', as: 'users' });

// ---------------------------
// Product ↔ Currency
// ---------------------------
Product.belongsTo(Currency, { foreignKey: 'currencyId', as: 'currency' });
Currency.hasMany(Product, { foreignKey: 'currencyId', as: 'products' });

// ProductSold ↔ Currency
ProductSold.belongsTo(Currency, { foreignKey: 'currencyId', as: 'currency' });
Currency.hasMany(ProductSold, { foreignKey: 'currencyId', as: 'productsSold' });

// ---------------------------
// Product ↔ Category (many-to-many)
// ---------------------------
Product.belongsToMany(Category, { through: ProductCategory, foreignKey: 'productId', as: 'categories' });
Category.belongsToMany(Product, { through: ProductCategory, foreignKey: 'categoryId', as: 'products' });

// Product ↔ ProductSold (one-to-many)
Product.hasMany(ProductSold, { foreignKey: 'productId', as: 'productSold' });
ProductSold.belongsTo(Product, { foreignKey: 'productId', as: 'product' });

// ---------------------------
// User ↔ BranchTrack
// ---------------------------
User.hasMany(BranchTrack, { foreignKey: 'userId', as: 'branchTracks' });
BranchTrack.belongsTo(User, { foreignKey: 'userId', as: 'user' });

// Commerce ↔ BranchTrack
Commerce.hasMany(BranchTrack, { foreignKey: 'commerceId', as: 'branchTracks' });
BranchTrack.belongsTo(Commerce, { foreignKey: 'commerceId', as: 'commerce' });

// ---------------------------
// User ↔ History
// ---------------------------
User.hasMany(History, { foreignKey: 'id', as: 'historyTracks' }); // id = userId dans History
History.belongsTo(User, { foreignKey: 'id', as: 'user' });

// ---------------------------
// User ↔ Commerce
// ---------------------------
User.hasMany(Commerce, { foreignKey: 'commerceId', as: 'commerces' });
Commerce.belongsTo(User, { foreignKey: 'commerceId', as: 'user' });

// ---------------------------
// Notifications
// ---------------------------
User.hasMany(Notification, { foreignKey: 'id', as: 'notifications' });
Notification.belongsTo(User, { foreignKey: 'id', as: 'user' });

Commerce.hasMany(Notification, { foreignKey: 'commerceId', as: 'notifications' });
Notification.belongsTo(Commerce, { foreignKey: 'commerceId', as: 'commerce' });

ExpeTrack.hasMany(Notification, { foreignKey: 'expeTrackId', as: 'notifications' });
Notification.belongsTo(ExpeTrack, { foreignKey: 'expeTrackId', as: 'expeTrack' });

BranchTrack.hasMany(Notification, { foreignKey: 'branchTrackId', as: 'notifications' });
Notification.belongsTo(BranchTrack, { foreignKey: 'branchTrackId', as: 'branchTrack' });

// ---------------------------
// BusinessCategory ↔ Company
// ---------------------------
BusinessCategory.hasMany(Company, { foreignKey: 'bussinessId', as: 'companies' });
Company.belongsTo(BusinessCategory, { foreignKey: 'bussinessId', as: 'category' });

// ---------------------------
// Bonus ↔ User ↔ Company
// ---------------------------
User.hasMany(Bonus, { foreignKey: 'userId', as: 'bonuses' });
Bonus.belongsTo(User, { foreignKey: 'userId', as: 'user' });

Company.hasMany(Bonus, { foreignKey: 'companyId', as: 'bonuses' });
Bonus.belongsTo(Company, { foreignKey: 'companyId', as: 'company' });

// ---------------------------
// Export all models
// ---------------------------
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
  BusinessCategory
};
