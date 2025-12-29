const userService = require('../services/userService');

exports.handleOtpVerify = async (req, res) => {
    try {
        const result = await userService.verifyOtp(req.body.phone, req.body.otp, req.body.type);
        
        // If phone is verified, create a token and send it to the frontend
        if (req.body.type === 'phone') {
            const token = jwt.sign(
                { phone: req.body.phone }, 
                process.env.JWT_SECRET, 
                { expiresIn: '1h' }
            );
            return res.status(200).json({ ...result, token });
        }
        
        res.status(200).json(result);
    } catch (err) { res.status(400).json({ error: err.message }); }
};

exports.handleStep1 = async (req, res) => {
    try {
        const result = await userService.saveStep1(req.body.phone, req.body);
        res.status(200).json(result);
    } catch (err) { res.status(400).json({ error: err.message }); }
};

exports.handleOtpVerify = async (req, res) => {
    try {
        const result = await userService.verifyOtp(req.body.phone, req.body.otp, req.body.type);
        res.status(200).json(result);
    } catch (err) { res.status(400).json({ error: err.message }); }
};

exports.handleEmailSave = async (req, res) => {
    try {
        const result = await userService.saveEmail(req.body.phone, req.body.email);
        res.status(200).json(result);
    } catch (err) { res.status(400).json({ error: err.message }); }
};

exports.handleSecurity = async (req, res) => {
    try {
        const { phone, type, value } = req.body; // type is 'password' or 'pin'
        const result = await userService.updateSecurity(phone, type, value);
        res.status(200).json(result);
    } catch (err) { res.status(400).json({ error: err.message }); }
};

exports.handleFinalize = async (req, res) => {
    try {
        const result = await userService.finalizeUser(req.body.phone);
        res.status(201).json(result);
    } catch (err) { res.status(400).json({ error: err.message }); }
};