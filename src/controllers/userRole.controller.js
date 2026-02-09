import {  Role, User, UserRole } from '../models/index.js';
import { Op} from 'sequelize';

export const getAllUserRoles = async (req, res) => {
  try {
    const { search, paginate = 'false', page = 1, pageSize = 20 } = req.query;

    const isPaginate = paginate.toLowerCase() === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

    const whereClause = search
      ? {
          [Op.or]: [
            { userId: { [Op.iLike]: `%${search}%` } },
            { roleId: { [Op.iLike]: `%${search}%` } },
          ],
        }
      : {};

    const findOptions = {
      where: whereClause,
    };

    if (isPaginate) {
      const { rows, count } = await UserRole.findAndCountAll({
        ...findOptions,
        limit,
        offset,
      });

      return res.status(200).json({
        data: rows,
        total: count,
        currentPage,
        totalPages: Math.ceil(count / limit),
      });
    } else {
      const UserRoles = await UserRole.findAll(findOptions);

      return res.status(200).json({
        data: UserRoles,
        total: UserRoles.length,
        currentPage: 1,
        totalPages: 1,
      });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error retrievingUserRoles', error });
  }
};

export const getUserRoleById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid UserRole ID' });
    }

    const UserRoleItem = await UserRole.findOne({
      where: {
        userId: id,
      },
    });

    if (!UserRoleItem) {
      return res.status(404).json({ message: 'UserRole not found' });
    }

    res.status(200).json({
      data: UserRoleItem,
      message: 'UserRole retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrievingUserRole', error });
  }
};

export const createUserRoles = async (req, res) => {

    const usersRoles = req.body;

  if (!Array.isArray( usersRoles) ||  usersRoles.length === 0) {
    return res.status(400).json({ message: "Veuillez fournir un tableau de roles  d'utilisateurs." });
  }

 
  try {

     const createdRoleUsers = [];
   for (const roleData of usersRoles){
      const { userId, roleId } = roleData;
         const userExist = await User.findOne({
      where: { id: userId },
    });
    const roleExist = await Role.findOne({
      where: { id: roleId },
    });

    if (!userExist || !roleExist) {
      return res.status(409).json({
        message: !userExist ? 'This user  does not  exit sorry' : 'This role  does not  exit sorry',
      });
    }

     const UserRoleItem = await UserRole.create({
      userId,
      roleId,
    });

    createdRoleUsers.push({
       userId :  UserRoleItem.userId,
       roleId : UserRoleItem.roleId
    })

    }
   

    res.status(201).json({
      message: 'UserRole added successfully',
      data: createdRoleUsers,
    });
  } catch (error) {
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(409).json({
        message: 'UserRole already exists',
      });
    }

    res.status(500).json({ message: error.message });
  }
};

export const updateUserRole = async (req, res) => {
  try {
    const { id } = req.params;

    const UserRoleItem = await UserRole.findOne({
      where: {
        userId: id,
      },
    });
    if (!UserRoleItem) {
      return res.status(404).json({ message: 'UserRole not found' });
    }

    const response = await UserRoleItem.update(req.body);

    res.status(200).json({
      message: 'UserRole updated successfully',
      data: response,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteUserRole = async (req, res) => {
  try {
    const { id } = req.params;

    const UserRoleItem = await UserRole.findOne({
      where: {
        userId: id,
      },
    });
    if (!UserRoleItem) {
      return res.status(404).json({ message: 'UserRole not found' });
    }

    await UserRoleItem.destroy();

    res.status(200).json({
      message: 'UserRole deleted successfully',
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
