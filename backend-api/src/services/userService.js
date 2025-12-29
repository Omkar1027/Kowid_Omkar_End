const redisClient = require('../config/redis');
const pool = require('../config/db');
const bcrypt = require('bcrypt');

const SALT_ROUNDS = 10;

const userService = {
    // STEP 1: Save Initial Info
    saveStep1: async (phone, data) => {
        const key = `signup:${phone}`;
        const draft = { ...data, step: 1, isPhoneVerified: false };
        await redisClient.set(key, JSON.stringify(draft), { EX: 3600 }); // 1 hour expiry
        
        // FUTURE LOGIC: Generate 4-digit OTP, save to Redis 'otp:phone', and send SMS
        return { message: "Step 1 saved. OTP required." };
    },

    // STEP 2 & 4: Dummy OTP Verification logic
    verifyOtp: async (phone, otp, type) => {
        // STATIC DUMMY LOGIC
        if (otp !== "0000") throw new Error("Invalid OTP");

        const key = `signup:${phone}`;
        const draft = JSON.parse(await redisClient.get(key));
        if (!draft) throw new Error("Session expired. Start again.");

        if (type === 'phone') draft.isPhoneVerified = true;
        if (type === 'email') draft.isEmailVerified = true;
        
        await redisClient.set(key, JSON.stringify(draft), { EX: 3600 });
        return { message: `${type} verified successfully` };
    },

    // STEP 3: Save Optional Email
    saveEmail: async (phone, email) => {
        const key = `signup:${phone}`;
        const draft = JSON.parse(await redisClient.get(key));
        draft.email = email;
        draft.isEmailVerified = false;
        await redisClient.set(key, JSON.stringify(draft), { EX: 3600 });

        // FUTURE LOGIC: Send Email OTP here
        return { message: "Email saved. Verify OTP or skip." };
    },

    // STEP 5 & 6: Encrypt and Update
    updateSecurity: async (phone, field, value) => {
        const key = `signup:${phone}`;
        const draft = JSON.parse(await redisClient.get(key));
        
        // Encrypting Password or PIN before saving to Redis
        const hashedValue = await bcrypt.hash(value, SALT_ROUNDS);
        draft[field] = hashedValue;
        
        await redisClient.set(key, JSON.stringify(draft), { EX: 3600 });
        return { message: `${field} secured.` };
    },

    // FINAL STEP: Commit to Postgres (Neon)
    finalizeUser: async (phone) => {
        const key = `signup:${phone}`;
        const draft = JSON.parse(await redisClient.get(key));

        if (!draft || !draft.isPhoneVerified) {
            throw new Error("Phone must be verified before account creation.");
        }

        // EDGE CASE: Check if user already exists in Postgres
        const existingUser = await pool.query('SELECT * FROM users WHERE phone = $1', [phone]);
        if (existingUser.rows.length > 0) throw new Error("User already exists.");

        // DATABASE TRANSACTION: Final Save
        const query = `
            INSERT INTO users (first_name, last_name, phone, email, password, pin)
            VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;
        `;
        const values = [draft.firstName, draft.lastName, draft.phone, draft.email || null, draft.password, draft.pin];
        
        const result = await pool.query(query, values);

        // CLEANUP: Delete from Redis after successful save
        await redisClient.del(key);
        
        return { userId: result.rows[0].id, message: "Account Created Successfully! 🎉" };
    }
};

module.exports = userService;