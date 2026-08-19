import { AppVersion } from '../models/index.js';

// Renvoie la config de version pour une plateforme donnée (?platform=android|ios).
// Utilisé par l'app mobile pour savoir si une nouvelle version PlayStore/App Store existe.
export const getAppVersion = async (req, res) => {
  try {
    const { platform = 'android' } = req.query;
    const version = await AppVersion.findOne({ where: { platform } });

    if (!version) {
      return res.status(200).json({ data: null });
    }

    return res.status(200).json({ data: version });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

export const getAllAppVersions = async (req, res) => {
  try {
    const versions = await AppVersion.findAll();
    return res.status(200).json({ data: versions });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// Créé ou met à jour (upsert) la config de version pour une plateforme.
// C'est ce que l'admin appelle depuis admin-bimnext à chaque publication.
export const upsertAppVersion = async (req, res) => {
  try {
    const { platform, latestVersion, minSupportedVersion, storeUrl, releaseNotes, forceUpdate } = req.body;

    if (!platform || !latestVersion) {
      return res.status(400).json({ message: 'platform et latestVersion sont requis' });
    }

    const [version] = await AppVersion.upsert(
      {
        platform,
        latestVersion,
        minSupportedVersion: minSupportedVersion || null,
        storeUrl: storeUrl || null,
        releaseNotes: releaseNotes || null,
        forceUpdate: forceUpdate === undefined ? false : forceUpdate === 'true' || forceUpdate === true,
      },
      { returning: true }
    );

    try {
      const { getIO } = await import('../services/socket.service.js');
      getIO().emit('app:version_updated', { platform, latestVersion });
    } catch {}

    return res.status(200).json({ message: 'Version enregistrée', data: version });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};
