// Placeholder for storageService.js
const { bucket } = require('../config/firebase');
const { v4: uuidv4 } = require('uuid');

// Upload ke Firebase Storage dan kembalikan URL publik
async function uploadFile(file, folder = 'uploads') {
  const filename = `${folder}/${Date.now()}_${file.originalname}`;
  const fileUpload = bucket.file(filename);

  const stream = fileUpload.createWriteStream({
    metadata: {
      contentType: file.mimetype
    }
  });

  return new Promise((resolve, reject) => {
    stream.on('error', reject);
    stream.on('finish', async () => {
      // Atur file menjadi publik
      await fileUpload.makePublic();
      resolve(`https://storage.googleapis.com/${bucket.name}/${filename}`);
    });

    stream.end(file.buffer);
  });
}

module.exports = { uploadFile };
