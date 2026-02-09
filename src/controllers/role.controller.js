/* eslint-disable no-undef */
import { Role } from '../models/index.js';

export const getAllRoles = async (req, res) => {
  try {
    const { search, paginate = 'false', page = 1, pageSize = 20 } = req.query;
    const isPaginate = paginate.toLowerCase() === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

    const whereClause = search
      ? {
          [Op.or]: [
            { name: { [Op.iLike]: `%${search}%` } },
            { description: { [Op.iLike]: `%${search}%` } },
          ],
        }
      : {};

    if (isPaginate) {
      const { rows, count } = await Role.findAndCountAll({
        where: whereClause,
        limit,
        offset,
        order: [['createdAt', 'ASC']],
      });

      return res
        .status(200)
        .json({ data: rows, total: count, currentPage, totalPages: Math.ceil(count / limit) });
    } else {
      const roles = await Role.findAll({
        where: whereClause,
        order: [['createdAt', 'ASC']],
      });
      return res
        .status(200)
        .json({ data: roles, total: roles.length, currentPage: 1, totalPages: 1 });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving roles', error });
  }
};

export const getRoleById = async (req, res) => {
  const { id } = req.params;
  const role = await Role.findByPk(id);
  if (role) {
    res.status(200).json({ data: role });
  } else {
    res.status(404).json({ message: 'Role not found' });
  }
  query;
};

export const createRole = async (req, res) => {
  const roles = req.body; // On s'attend à un tableau [{name, description}, ...]

  if (!Array.isArray(roles) || roles.length === 0) {
    return res.status(400).json({ message: 'Veuillez fournir un tableau de rôles à créer.' });
  }

  try {
    const newRoles = await Role.bulkCreate(roles);
    res.status(201).json(newRoles);
  } catch (error) {
    res.status(500).json({ message: 'Erreur lors de la création des rôles', error });
  }
};

export const updateRole = async (req, res) => {
  const { id } = req.params;
  const { name, description } = req.body;
  try {
    const role = await Role.findByPk(id);
    if (role) {
      role.name = name || role.name;
      role.description = description || role.description;
      await role.save();
      res.status(200).json(role);
    } else {
      res.status(404).json({ message: 'Role not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error updating role', error });
  }
};
export const deleteRole = async (req, res) => {
  const { id } = req.params;
  try {
    const role = await Role.findByPk(id);
    if (role) {
      await role.destroy();

      res.status(200).json({ message: 'Role deleted successfully' });
    } else {
      res.status(404).json({ message: 'Role not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error deleting role', error });
  }
};
