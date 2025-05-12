// Placeholder for upload.js
const multer = require('multer');

// Gunakan memory storage agar bisa langsung dikirim ke Firebase Storage
const storage = multer.memoryStorage();
const upload = multer({ storage });

module.exports = upload;
