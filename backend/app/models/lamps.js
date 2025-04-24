'use strict';
module.exports = (sequelize, DataTypes) => {
  const Lamp = sequelize.define(
    'Lamp',
    {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
      },
      state: {
        type: DataTypes.BOOLEAN,
        allowNull: false
      }
    },
    {
      tableName: 'lamps'
    }
  );

  return Lamp;
};
