// Placeholder for auth.js
const admin = require('C:\Users\dhiyo\OneDrive\Dokumen\GitHub\MPLJJ25-140-KEL-13\edubuild-backend\config\firebase.js').admin;

const auth = async (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Unauthorized: No token provided' });
  }

  const idToken = authHeader.split(' ')[1];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedToken; // bisa akses UID, email, dsb
    next();
  } catch (err) {
    console.error('Error verifying Firebase ID token:', err);
    res.status(401).json({ message: 'Unauthorized: Invalid token' });
  }
};

module.exports = auth;
