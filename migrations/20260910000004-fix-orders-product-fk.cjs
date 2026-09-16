'use strict';

/**
 * orders.productId bloquait la suppression d'un produit ayant des commandes
 * (contrainte FK en RESTRICT au lieu de SET NULL). Idempotent : ne touche à
 * rien si c'est déjà corrigé (que ce soit via cette migration ou via le SQL
 * manuel donné précédemment).
 */
module.exports = {
  async up(queryInterface) {
    const [[current]] = await queryInterface.sequelize.query(`
      SELECT rc.CONSTRAINT_NAME, rc.DELETE_RULE
      FROM information_schema.REFERENTIAL_CONSTRAINTS rc
      JOIN information_schema.KEY_COLUMN_USAGE kcu
        ON kcu.CONSTRAINT_NAME = rc.CONSTRAINT_NAME AND kcu.CONSTRAINT_SCHEMA = rc.CONSTRAINT_SCHEMA
      WHERE rc.CONSTRAINT_SCHEMA = DATABASE()
        AND rc.TABLE_NAME = 'orders'
        AND kcu.COLUMN_NAME = 'productId'
        AND kcu.REFERENCED_TABLE_NAME = 'products'
      LIMIT 1;
    `);

    if (!current) return; // pas de contrainte trouvée, rien à faire
    if (current.DELETE_RULE === 'SET NULL') return; // déjà corrigé

    await queryInterface.sequelize.query(`ALTER TABLE orders MODIFY COLUMN productId INT NULL;`);
    await queryInterface.sequelize.query(`ALTER TABLE orders DROP FOREIGN KEY \`${current.CONSTRAINT_NAME}\`;`);
    await queryInterface.sequelize.query(`
      ALTER TABLE orders ADD CONSTRAINT \`${current.CONSTRAINT_NAME}\`
        FOREIGN KEY (productId) REFERENCES products(productId)
        ON DELETE SET NULL ON UPDATE CASCADE;
    `);
  },
  async down() {
    // Pas de rollback automatique : reviendrait à réintroduire un blocage volontairement corrigé.
  },
};
