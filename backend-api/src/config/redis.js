const { createClient } = require('redis');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../../.env') });

const redisClient = createClient({
    url: process.env.REDIS_URL,
    socket: { tls: true, rejectUnauthorized: false }
});

redisClient.on('error', (err) => console.error('❌ Redis Error:', err));

(async () => {
    if (!redisClient.isOpen) await redisClient.connect();
    console.log('✅ Connected to Upstash Redis');
})();

module.exports = redisClient;