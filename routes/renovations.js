// Placeholder for renovations.js
const express = require('express');
const router = express.Router();
const renovationsController = require('C:\Users\dhiyo\OneDrive\Dokumen\GitHub\MPLJJ25-140-KEL-13\edubuild-backend\controllers\renovationsController.js');

// Tambah proyek renovasi
router.post('/', renovationsController.createRenovation);

// Update progres
router.put('/:id', renovationsController.updateRenovation);

// Ambil semua renovasi
router.get('/', renovationsController.getAllRenovations);

// Ambil berdasarkan ID
router.get('/:id', renovationsController.getRenovationById);

// Hapus renovasi (opsional)
router.delete('/:id', renovationsController.deleteRenovation);

module.exports = router;
