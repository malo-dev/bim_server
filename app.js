import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import morgan from 'morgan';
import helmet from 'helmet';
import authRoutes from './src/routers/auth.routes.js';
import roleRoutes from './src/routers/role.routes.js';
import productRoutes from './src/routers/product.router.js';
import currencyRoutes from './src/routers/currency.routes.js';
import categoryRoutes from './src/routers/category.routes.js';
import productCategoryRoutes from './src/routers/productCategory.routes.js';
import userRoleRoutes from './src/routers/userRole.routes.js';
import productSoldRoutes from './src/routers/productSold.routes.js';
import branchRoutes from './src/routers/branchTrack.routes.js';
import clientRoutes from './src/routers/clientTrack.routes.js';
import commereRoutes from './src/routers/commerce.routes.js';
import expetrackRoutes from './src/routers/expetrack.routes.js';
import redevtrackRoutes from './src/routers/redevtrack.routes.js';
import notificationRoutes from './src/routers/notification.routes.js';
import feedbackRoutes from './src/routers/feedback.routes.js';
import  historyRoutes from './src/routers/history.routes.js'
import TransactionRoutes from './src/routers/transaction.routes.js'
import SupportRoutes from './src/routers/supportTrack.routes.js'
import BusinessRoutes from './src/routers/businessCategory.routes.js';
import CompanyRoutes from './src/routers/company.routes.js'
import NotesRoutes from './src/routers/notes.routes.js'
import BonusRoutes from './src/routers/bonusTrack.routes.js'
import path from 'path';
const app = express();
dotenv.config();
app.use(express.json());
 app.use(express.urlencoded({
  extended: true,
  })
 );
app.use(morgan('dev'));
app.use(helmet());
app.use(cors({ origin: '*' }));
app.use((req, res, next) => {
  res.setHeader('Cross-Origin-Resource-Policy', 'cross-origin');
  next();
});
app.use(
  '/images',
  // eslint-disable-next-line no-undef
  express.static(path.join(process.cwd(), 'public/images'))
);

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/role', roleRoutes);
app.use('/api/v1/product', productRoutes);
app.use('/api/v1/currency', currencyRoutes);
app.use('/api/v1/category', categoryRoutes);
app.use('/api/v1/history', historyRoutes);
app.use('/api/v1/product_category', productCategoryRoutes);
app.use('/api/v1/user_role', userRoleRoutes);
app.use('/api/v1/product_sold', productSoldRoutes);
app.use('/api/v1/branch_track', branchRoutes);
app.use('/api/v1/client_track', clientRoutes);
app.use('/api/v1/commerce_track', commereRoutes);
app.use('/api/v1/expe_track', expetrackRoutes);
app.use('/api/v1/redev_track', redevtrackRoutes);
app.use('/api/v1/feedback_track', feedbackRoutes);
app.use('/api/v1/support_track', SupportRoutes);
app.use('/api/v1/notification_track', notificationRoutes);
app.use('/api/v1/tsx', TransactionRoutes);
app.use('/api/v1/sector', BusinessRoutes);
app.use('/api/v1/company', CompanyRoutes);
app.use('/api/v1/bonus', BonusRoutes);
app.use('/api/v1/notes',NotesRoutes)




export default app;
