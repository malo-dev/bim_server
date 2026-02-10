import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const ExpeTrack = sequelize.define(
  "ExpeTrack",
  {
    expeTrackId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    reference: {
      type: DataTypes.STRING(100),
      allowNull: false,
      comment: "Numéro unique de la fiche d’expédition",
    },

    shipmentDate: {
      type: DataTypes.DATE,
      allowNull: false,
      comment: "Date d’expédition",
      set(value) {
        if (value) {
          this.setDataValue("shipmentDate", new Date(value));
        }
      },
    },

    expectedArrivalDate: {
      type: DataTypes.DATE,
      allowNull: true,
      comment: "Date d’arrivée prévue",
      set(value) {
        if (value) {
          this.setDataValue("expectedArrivalDate", new Date(value));
        }
      },
    },

    origin: {
      type: DataTypes.STRING(150),
      allowNull: false,
      comment: "Lieu de départ",
    },

    destination: {
      type: DataTypes.STRING(150),
      allowNull: false,
      comment: "Lieu de destination",
    },

    carrierName: {
      type: DataTypes.STRING(150),
      allowNull: true,
      comment: "Nom du transporteur",
    },

    vehiclePlate: {
      type: DataTypes.STRING(50),
      allowNull: true,
      comment: "Plaque du véhicule",
    },

    totalPackages: {
      type: DataTypes.INTEGER,
      allowNull: false,
      comment: "Nombre total de colis",
    },

    totalWeight: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: true,
      comment: "Poids total expédié",
      validate: { min: 0 },
    },

    status: {
      type: DataTypes.ENUM(
        "EN_ATTENTE",
        "EXPEDIE",
        "RECU_PARTIEL",
        "RECU_COMPLET",
        "LITIGE"
      ),
      allowNull: false,
      defaultValue: "EN_ATTENTE",
    },

    remarks: {
      type: DataTypes.TEXT,
      allowNull: true,
      comment: "Observations à l’expédition",
    },

    commerceId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "commerces",
        key: "commerceId",
      },
      onUpdate: "CASCADE",
      onDelete: "RESTRICT",
    },

    branchTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: "branch_tracks",
        key: "branchTrackId",
      },
      onUpdate: "CASCADE",
      onDelete: "SET NULL",
    },

    imageUrl: {
      type: DataTypes.STRING(500),
      allowNull: true,
    },
  },
  {
    tableName: "expe_tracks",
    timestamps: true,
    underscored: false,
    indexes: [
      {
        unique: true,
        fields: ["reference"],
      },
    ],
  }
);

export default ExpeTrack;
