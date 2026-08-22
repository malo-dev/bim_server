import sharp from 'sharp';

/**
 * Compresse une image déjà écrite sur disque (par multer) : redimensionne
 * si trop grande et réencode en JPEG qualité 78 — réduit nettement le poids
 * sans perte visible, pour ne pas alourdir l'app (mobile + admin).
 */
export async function compressImageFile(filePath, { maxDimension = 1280, quality = 78 } = {}) {
  try {
    const buffer = await sharp(filePath)
      .rotate() // respecte l'orientation EXIF avant de la retirer
      .resize({ width: maxDimension, height: maxDimension, fit: 'inside', withoutEnlargement: true })
      .jpeg({ quality })
      .toBuffer();

    const fs = await import('fs');
    fs.writeFileSync(filePath, buffer);
  } catch (err) {
    // Si la compression échoue (format non supporté, etc.), on garde le fichier original.
    console.error('[compressImageFile] échec compression', filePath, err.message);
  }
}
