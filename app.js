import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import morgan from 'morgan';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
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
import OrderRoutes from './src/routers/order.routes.js'
import LivreurRoutes from './src/routers/livreur.routes.js'
import FavoriteRoutes from './src/routers/favorite.routes.js'
import path from 'path';
const app = express();
dotenv.config();

// ── Rate limiters ──────────────────────────────────────────
// Limite globale : 200 requêtes / 15 min par IP
const globalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 200,
  standardHeaders: true,
  legacyHeaders: false,
  message: { message: 'Trop de requêtes. Réessayez dans 15 minutes.' },
});

// Limite stricte sur les routes sensibles : 10 requêtes / 15 min par IP
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,
  standardHeaders: true,
  legacyHeaders: false,
  message: { message: 'Trop de tentatives. Réessayez dans 15 minutes.' },
});

const ALLOWED_ORIGINS = [
  'http://localhost:5000',
  'http://localhost:5173',
  'http://localhost:8083',
  'http://192.168.1.39:5000',
  'http://192.168.1.39:8083',
  'http://10.0.10.81:5000',
  'https://serverbimnext.masmara-dimajelo.org',
  'https://admin-bim-pi.vercel.app',
];

const corsOptions = {
  origin: (origin, callback) => {
    // Autoriser les requêtes sans origin (apps mobiles, Postman, etc.)
    // et toutes les origines Vercel du projet admin
    if (!origin || ALLOWED_ORIGINS.includes(origin) || /\.vercel\.app$/.test(origin)) {
      callback(null, true);
    } else {
      callback(null, true); // permissif — changer en callback(new Error('Not allowed')) en prod stricte
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
};

// ── Middlewares ────────────────────────────────────────────
// ⚠️  CORS doit être avant le rate limiter : sinon les réponses 429
//     n'ont pas de header CORS et le navigateur les signale comme erreur CORS.
app.use(cors(corsOptions));
// Répondre immédiatement aux preflight OPTIONS sans passer par le rate limiter
app.options('*', cors(corsOptions));

app.use(globalLimiter);
app.use(express.json({ limit: '2mb' }));
app.use(express.urlencoded({ extended: true, limit: '2mb' }));
app.use(morgan('dev'));
app.use(
  helmet({
    crossOriginResourcePolicy: { policy: 'cross-origin' },
    contentSecurityPolicy: false,
  })
);
app.disable('x-powered-by');
app.use(
  '/images',
  // eslint-disable-next-line no-undef
  express.static(path.join(process.cwd(), 'public/images'))
);

// Rate limiter strict sur les routes auth sensibles
app.use('/api/v1/auth/login', authLimiter);
app.use('/api/v1/auth/reset-password', authLimiter);
app.use('/api/v1/auth/ask-password-reset', authLimiter);

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
app.use('/api/v1/notes', NotesRoutes)
app.use('/api/v1/order', OrderRoutes)
app.use('/api/v1/livreur', LivreurRoutes)
app.use('/api/v1/favorite', FavoriteRoutes)


app.get('/', (req, res) => {
  res.status(200).json({
    message: '👋 Hello from BIM NEXT API — Server is running !',
    version: 'v1.0.0',
    status:  'online',
    docs:    '/api/v1',
  });
});

export default app;
