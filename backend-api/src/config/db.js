//MONGODB CONNECTION SETUP (OLD CODE)


// const { Pool } = require('pg');
// require('dotenv').config();

// const pool = new Pool({
//   user: process.env.DB_USER || 'postgres',
//   host: process.env.DB_HOST || 'localhost',
//   database: process.env.DB_NAME || 'kowid_db',
//   password: process.env.DB_PASSWORD || 'password',
//   port: process.env.DB_PORT || 5432,
// });

// module.exports = {
//   query: (text, params) => pool.query(text, params),
// };


//NEON POSTGRESQL CONNECTION SETUP (NEW CODE)

const path = require('path');
const { Pool } = require('pg');

// This line is the magic fix. It tells Node to go UP out of 'src', 
// UP out of 'backend-api', and find the .env in the KOWID folder.
require('dotenv').config({ path: path.resolve(__dirname, '../../../.env') });

console.log("Checking DATABASE_URL:", process.env.DATABASE_URL ? "URL Found ✅" : "URL NOT FOUND ❌");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false,
  },
});

pool.query('SELECT NOW()', (err, res) => {
  if (err) {
    console.error('❌ Database Connection Error:', err.message);
  } else {
    console.log('✅ DATABASE CONNECTED TO NEON:', res.rows[0].now);
  }
});

module.exports = {
  query: (text, params) => pool.query(text, params),
};