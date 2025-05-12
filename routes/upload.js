// Placeholder for upload.js
const express = require('express');
const router = express.Router();
const upload = require('C:\Users\dhiyo\OneDrive\Dokumen\GitHub\MPLJJ25-140-KEL-13\edubuild-backend\middleware\upload.js');
const { uploadFile } = require('C:\Users\dhiyo\OneDrive\Dokumen\GitHub\MPLJJ25-140-KEL-13\edubuild-backend\services\storageService.js');

// Upload foto
router.post('/', upload.single('file'), async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ message: 'No file uploaded' });

    const imageUrl = await uploadFile(req.file, 'images');
    res.status(200).json({ imageUrl });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
