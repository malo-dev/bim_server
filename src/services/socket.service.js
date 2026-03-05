import { Server } from 'socket.io';

let io = null;

/**
 * Initialise Socket.io sur le serveur HTTP
 * @param {import('http').Server} httpServer
 */
export const initSocket = (httpServer) => {
  io = new Server(httpServer, {
    cors: {
      origin: [
        'http://localhost:5000',
        'http://localhost:8083',
        'http://192.168.1.39:5000',
        'http://192.168.1.39:8083',
        'https://serverbimnext.masmara-dimajelo.org',
        '*',
      ],
      methods: ['GET', 'POST'],
      credentials: true,
    },
  });

  io.on('connection', (socket) => {
    console.log(`🔌 Socket connecté : ${socket.id}`);

    // Le client envoie son userId pour rejoindre sa room privée
    socket.on('join', (userId) => {
      if (userId) {
        socket.join(`user_${userId}`);
        console.log(`👤 User ${userId} a rejoint la room user_${userId}`);
      }
    });

    socket.on('disconnect', () => {
      console.log(`❌ Socket déconnecté : ${socket.id}`);
    });
  });

  return io;
};

/**
 * Retourne l'instance io (doit être appelé après initSocket)
 */
export const getIO = () => {
  if (!io) throw new Error('Socket.io non initialisé');
  return io;
};

/**
 * Envoie un événement à un utilisateur spécifique via sa room
 * @param {number|string} userId
 * @param {string} event - nom de l'événement
 * @param {object} data - données à envoyer
 */
export const emitToUser = (userId, event, data) => {
  if (io) {
    io.to(`user_${userId}`).emit(event, data);
  }
};
