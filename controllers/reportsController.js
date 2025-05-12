const { db } = require('../config/firebase');
const calculateScore = require('../utils/score');

exports.createReport = async (req, res) => {
  try {
    const { schoolId, roofLeak, brokenToilet, photoUrl } = req.body;

    const score = calculateScore({ roofLeak, brokenToilet });

    await db.collection('Reports').add({
      schoolId,
      roofLeak,
      brokenToilet,
      photoUrl,
      createdAt: new Date().toISOString()
    });

    // Update skor sekolah
    await db.collection('Schools').doc(schoolId).update({ score });

    res.status(201).json({ message: 'Report submitted and score updated.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
