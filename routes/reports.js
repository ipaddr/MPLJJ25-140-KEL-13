const express = require('express');
const router = express.Router();

// Tambah laporan baru
router.post('/', reportController.createReport);

module.exports = router;
const express = require('express');
const auth = require('C:\Users\dhiyo\OneDrive\Dokumen\GitHub\MPLJJ25-140-KEL-13\edubuild-backend\middleware\auth.js');
const reportController = require('C:\Users\dhiyo\OneDrive\Dokumen\GitHub\MPLJJ25-140-KEL-13\edubuild-backend\controllers\reportsController.js');

router.post('/', auth, reportController.createReport);
