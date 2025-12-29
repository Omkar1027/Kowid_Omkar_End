const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

router.post('/step1', userController.handleStep1);
router.post('/verify-otp', userController.handleOtpVerify);
router.post('/save-email', userController.handleEmailSave);
router.post('/security', userController.handleSecurity);
router.post('/finalize', userController.handleFinalize);

module.exports = router;