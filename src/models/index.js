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
import TransactionRetrait from './TransactionRetrait.model.js'
import TransactionTransfert from './transfertTransaction.model.js';
import TransactionRecharge from './transactionRecharge.model.js';
import TransactionPaiement from './paiementTrasanction.model.js';
User.belongsToMany(Role, {
  through: UserRole,
  foreignKey: 'userId',
  as: 'role',
});

Role.belongsToMany(User, {
  through: UserRole,
  foreignKey: 'roleId',
});

Product.belongsTo(Currency, {
  foreignKey: 'currencyId',
  as: 'currency',
});

Currency.hasMany(Product, {
  foreignKey: 'currencyId',
  as: 'products',
});


ProductSold.belongsTo(Currency, {
  foreignKey: 'currencyId',
  as: 'currency',
});

Currency.hasMany(ProductSold, {
  foreignKey: 'currencyId',
  as: 'productsSold',
});




Product.belongsToMany(Category, {
  through: ProductCategory,
  foreignKey: 'productId',
  as: 'categories',
});

Category.belongsToMany(Product, {
  through: ProductCategory,
  foreignKey: 'categoryId',
  as: 'products',
});

Product.hasMany(ProductSold, { foreignKey: 'productId', as: 'productSold' });
ProductSold.belongsTo(Product, {
  foreignKey: 'productId',
  as: 'product',
});

User.hasMany(BranchTrack, { foreignKey: 'branchTrackId', as: 'branchTrack' });
BranchTrack.belongsTo(User, {
  foreignKey: 'branchTrackId',
  as: 'user',
});


History.hasMany(User, { foreignKey: 'id', as: 'userIdTrack' });
User.belongsTo(History, {
  foreignKey: 'id',
  as: 'historyTrack',
});



User.hasMany(Commerce, { foreignKey: 'commerceId', as: 'commerce' });
Commerce.belongsTo(User, {
  foreignKey: 'commerceId',
  as: 'user',
});

Commerce.hasMany(BranchTrack, { foreignKey: 'commerceId', as: 'branchTrack' });
BranchTrack.belongsTo(Commerce, {
  foreignKey: 'commerceId',
  as: 'commerce',
});


User.hasMany(Notification, { foreignKey: 'userId' });
Notification.belongsTo(User, { foreignKey: 'userId' });

Commerce.hasMany(Notification, { foreignKey: 'commerceId' });
Notification.belongsTo(Commerce, { foreignKey: 'commerceId' });

ExpeTrack.hasMany(Notification, { foreignKey: 'expeTrackId' });
Notification.belongsTo(ExpeTrack, { foreignKey: 'expeTrackId' });

BranchTrack.hasMany(Notification, { foreignKey: 'branchTrackId' });
Notification.belongsTo(BranchTrack, { foreignKey: 'branchTrackId' });



BusinessCategory.hasMany(Company, {
  foreignKey: "bussinessId",
  as: "companies",
});

Company.belongsTo(BusinessCategory, {
  foreignKey: "bussinessId",
  as: "category",
});
User.hasMany(Bonus, { foreignKey: "id" });
Bonus.belongsTo(User, { foreignKey: "id" });

Bonus.belongsTo(User, { foreignKey: "id" });
Bonus.belongsTo(Company, { foreignKey: "companyId" });


Company.hasMany(Bonus, { foreignKey: "companyId" });
Bonus.belongsTo(Company, { foreignKey: "companyId" });


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
  Company
};
