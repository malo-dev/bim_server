import { Server } from 'socket.io';

let io = null;

// userId -> { userId, socketId, connectedAt }
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
    socket.on('join', (userId) => {
      if (userId) {
        socket.join(`user_${userId}`);
        onlineUsers.set(String(userId), {
          userId: String(userId),
          socketId: socket.id,
          connectedAt: new Date().toISOString(),
        });
        console.log(`👤 User ${userId} en ligne`);

        // Notifier les admins connectés
        io.to('admin_room').emit('user:online', {
          userId: String(userId),
          connectedAt: new Date().toISOString(),
        });
        io.to('admin_room').emit('online_users', Array.from(onlineUsers.values()));
      }
    });

    // L'admin rejoint la room admin pour recevoir les events temps réel
    socket.on('join_admin', () => {
      socket.join('admin_room');
      console.log(`🛡️  Admin connecté à admin_room (socket ${socket.id})`);
      // Envoyer la liste courante des utilisateurs en ligne
      socket.emit('online_users', Array.from(onlineUsers.values()));
    });

    socket.on('disconnect', () => {
      console.log(`❌ Socket déconnecté : ${socket.id}`);

      // Retrouver l'userId associé à ce socket
      for (const [userId, info] of onlineUsers.entries()) {
        if (info.socketId === socket.id) {
          onlineUsers.delete(userId);
          console.log(`👤 User ${userId} hors ligne`);
          io.to('admin_room').emit('user:offline', { userId });
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
