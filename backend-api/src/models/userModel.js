const db = require('../config/db');

const createUser = async (firstName, lastName, phone) => {
  const query = `
    INSERT INTO users (first_name, last_name, phone)
    VALUES ($1, $2, $3)
    RETURNING *;
  `;
  const values = [firstName, lastName, phone];
  const { rows } = await db.query(query, values);
  return rows[0];
};

module.exports = { createUser };