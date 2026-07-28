import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const Favorite = sequelize.define("Favorite", {
  favoriteId: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  userId:     { type: DataTypes.INTEGER, allowNull: false },
  productId:  { type: DataTypes.INTEGER, allowNull: false },
}, {
  tableName: "user_favorites",
  timestamps: true,
  indexes: [{ unique: true, fields: ["userId", "productId"] }],
});

export default Favorite;
