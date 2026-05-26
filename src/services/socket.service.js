import { Server } from 'socket.io';
import User from '../models/User.model.js';

let io = null;

// userId -> { userId, username, socketId, connectedAt }
const onlineUsers = new Map();

export const initSocket = (httpServer) => {
  io = new Server(httpServer, {
    cors: {
      origin: [
        'http://localhost:5000',
        'http://localhost:8083',
        'http://localhost:5173',
        'http://192.168.1.39:5000',
        'http://192.168.1.39:8083',
        'http://10.0.10.81:8083',
        'https://serverbimnext.masmara-dimajelo.org',
        '*',
      ],
      methods: ['GET', 'POST'],
      credentials: true,
    },
  });

  io.on('connection', (socket) => {
    console.log(`🔌 Socket connecté : ${socket.id}`);

    // Utilisateur normal rejoint sa room privée
    socket.on('join', async (userId) => {
      if (userId) {
        socket.join(`user_${userId}`);
        const connectedAt = new Date().toISOString();

        // Récupération du username depuis la DB
        let username = null;
        try {
          const user = await User.findByPk(userId, { attributes: ['username'] });
          username = user?.username ?? null;
        } catch (e) {
          console.error('[Socket] Erreur lookup username:', e.message);
        }

        onlineUsers.set(String(userId), {
          userId: String(userId),
          username,
          socketId: socket.id,
          connectedAt,
        });
        console.log(`👤 User ${userId} (${username ?? 'inconnu'}) en ligne`);

        // Notifier les admins connectés
        io.to('admin_room').emit('user:online', { userId: String(userId), username, connectedAt });
        io.to('admin_room').emit('online_users', Array.from(onlineUsers.values()));
      }
    });

    // L'admin rejoint la room admin pour recevoir les events temps réel
    socket.on('join_admin', () => {
      socket.join('admin_room');
      console.log(`🛡️  Admin connecté à admin_room (socket ${socket.id})`);
      socket.emit('online_users', Array.from(onlineUsers.values()));
    });

    // Suivi d'une commande en temps réel
    socket.on('track_order', (orderNumber) => {
      if (orderNumber) {
        socket.join(`order_${orderNumber}`);
        console.log(`📦 Socket ${socket.id} suit la commande ${orderNumber}`);
      }
    });

    // Livreur partage sa position
    socket.on('livreur:update_location', ({ livreurId, latitude, longitude }) => {
      if (livreurId) {
        io.emit(`livreur:location:${livreurId}`, { livreurId, latitude, longitude });
      }
    });

    socket.on('disconnect', () => {
      console.log(`❌ Socket déconnecté : ${socket.id}`);

      // Retrouver l'userId associé à ce socket
      for (const [userId, info] of onlineUsers.entries()) {
        if (info.socketId === socket.id) {
          onlineUsers.delete(userId);
          console.log(`👤 User ${userId} (${info.username ?? 'inconnu'}) hors ligne`);
          io.to('admin_room').emit('user:offline', { userId, username: info.username });
          io.to('admin_room').emit('online_users', Array.from(onlineUsers.values()));
          break;
        }
      }
    });
  });

  return io;
};

export const getIO = () => {
  if (!io) throw new Error('Socket.io non initialisé');
  return io;
};

export const emitToUser = (userId, event, data) => {
  if (io) {
    io.to(`user_${userId}`).emit(event, data);
  }
};

export const getOnlineUsers = () => Array.from(onlineUsers.values());

// Émet un changement de statut de commande à tous ceux qui la suivent
export const emitOrderUpdate = (orderNumber, payload) => {
  if (io) {
    io.to(`order_${orderNumber}`).emit('order:status_updated', payload);
  }
};

// Émet une alerte SOS livreur aux admins
export const emitSOSAlert = (payload) => {
  if (io) {
    io.to('admin_room').emit('livreur:sos', payload);
  }
};
