import crypto from 'crypto';

// Connexions faibles : l'app renvoie une action (payer, commander, transférer…)
// quand la réponse ne lui est pas parvenue, avec le MÊME en-tête
// `Idempotency-Key`. Si la première requête a déjà été traitée, on renvoie sa
// réponse au lieu de l'exécuter une seconde fois (pas de double débit / commande).
//
// Mémoire du serveur, 15 minutes. La clé est liée au jeton de session (un autre
// compte ne peut pas rejouer la réponse) et au chemin appelé.
const TTL_MS = 15 * 60 * 1000;
const store = new Map(); // empreinte → { state: 'pending' | 'done', status, body, at }

const prune = () => {
  const now = Date.now();
  for (const [k, v] of store) if (now - v.at > TTL_MS) store.delete(k);
};
setInterval(prune, 60 * 1000).unref?.();

export default function idempotency(req, res, next) {
  const key = req.get('Idempotency-Key');
  if (!key || req.method === 'GET' || req.method === 'OPTIONS' || key.length > 100) return next();

  const fingerprint = crypto
    .createHash('sha256')
    .update(`${req.get('Authorization') || ''}|${req.method}|${req.baseUrl}${req.path}|${key}`)
    .digest('hex');

  const seen = store.get(fingerprint);
  if (seen?.state === 'done') {
    res.set('Idempotent-Replay', 'true');
    return res.status(seen.status).json(seen.body);
  }
  // Une requête « en cours » depuis plus de 2 min est considérée comme abandonnée.
  if (seen?.state === 'pending' && Date.now() - seen.at < 2 * 60 * 1000) {
    // La première requête est encore en cours : l'app réessaiera dans un instant.
    return res.status(409).json({ code: 'IN_PROGRESS', message: 'Opération en cours, veuillez patienter.' });
  }

  store.set(fingerprint, { state: 'pending', at: Date.now() });

  const originalJson = res.json.bind(res);
  res.json = (body) => {
    // Erreurs serveur (5xx) : non mémorisées, l'action pourra être retentée.
    if (res.statusCode >= 500) store.delete(fingerprint);
    else store.set(fingerprint, { state: 'done', status: res.statusCode, body, at: Date.now() });
    return originalJson(body);
  };
  // Réponse envoyée sans JSON (page HTML…) : rien à rejouer, on libère la clé.
  // Si le CLIENT a coupé la connexion en cours de traitement, on garde la clé
  // « en cours » : le traitement continue côté serveur et sa réponse sera
  // mémorisée (res.json ci-dessus), prête pour la nouvelle tentative.
  res.on('finish', () => {
    const v = store.get(fingerprint);
    if (v?.state === 'pending') store.delete(fingerprint);
  });
  next();
}
