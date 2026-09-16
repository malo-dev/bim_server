'use strict';

/**
 * Beaucoup de tables (transactions, recharges, retraits, bonus, historique...)
 * référencent users.id avec une contrainte qui bloque la suppression d'un
 * utilisateur ayant de l'activité (RESTRICT par défaut, malgré CASCADE prévu
 * côté modèles Sequelize — dérive de schéma comme pour orders/products).
 *
 * Ici on corrige TOUTES les tables concernées d'un coup, génériquement, en
 * passant chaque contrainte en ON DELETE SET NULL : l'utilisateur peut être
 * supprimé, l'historique (montants, dates, références) reste intact mais
 * détaché plutôt que supprimé ou bloquant. Idempotent : ignore les
 * contraintes déjà en SET NULL.
 */
module.exports = {
  async up(queryInterface) {
    const [fks] = await queryInterface.sequelize.query(`
      SELECT kcu.TABLE_NAME, kcu.COLUMN_NAME, kcu.CONSTRAINT_NAME, rc.DELETE_RULE
      FROM information_schema.KEY_COLUMN_USAGE kcu
      JOIN information_schema.REFERENTIAL_CONSTRAINTS rc
        ON rc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME AND rc.CONSTRAINT_SCHEMA = kcu.CONSTRAINT_SCHEMA
      WHERE kcu.CONSTRAINT_SCHEMA = DATABASE()
        AND kcu.REFERENCED_TABLE_NAME = 'users'
        AND kcu.REFERENCED_COLUMN_NAME = 'id';
    `);

    for (const fk of fks) {
      if (fk.DELETE_RULE === 'SET NULL') continue; // déjà corrigé

      const [[colInfo]] = await queryInterface.sequelize.query(`
        SELECT COLUMN_TYPE, IS_NULLABLE FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = '${fk.TABLE_NAME}' AND COLUMN_NAME = '${fk.COLUMN_NAME}';
      `);
      if (!colInfo) continue;

      console.log(`→ ${fk.TABLE_NAME}.${fk.COLUMN_NAME} : ${fk.DELETE_RULE} → SET NULL`);

      if (colInfo.IS_NULLABLE === 'NO') {
        await queryInterface.sequelize.query(
          `ALTER TABLE \`${fk.TABLE_NAME}\` MODIFY COLUMN \`${fk.COLUMN_NAME}\` ${colInfo.COLUMN_TYPE} NULL;`
        );
      }

      await queryInterface.sequelize.query(
        `ALTER TABLE \`${fk.TABLE_NAME}\` DROP FOREIGN KEY \`${fk.CONSTRAINT_NAME}\`;`
      );
      await queryInterface.sequelize.query(`
        ALTER TABLE \`${fk.TABLE_NAME}\` ADD CONSTRAINT \`${fk.CONSTRAINT_NAME}\`
          FOREIGN KEY (\`${fk.COLUMN_NAME}\`) REFERENCES \`users\`(\`id\`)
          ON DELETE SET NULL ON UPDATE CASCADE;
      `);
    }
  },
  async down() {
    // Pas de rollback automatique : reviendrait à réintroduire un blocage volontairement corrigé.
  },
};
