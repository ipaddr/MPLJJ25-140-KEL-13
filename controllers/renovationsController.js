// Placeholder for renovationsController.js
const { db } = require('../config/firebase');

// Tambah proyek renovasi
exports.createRenovation = async (req, res) => {
  try {
    const { schoolId, startDate, plannedEndDate, note } = req.body;
    const renovation = {
      schoolId,
      startDate,
      plannedEndDate,
      note: note || '',
      progress: 0,
      photos: [],
      isCompleted: false,
      createdAt: new Date().toISOString()
    };

    const docRef = await db.collection('Renovations').add(renovation);
    res.status(201).json({ id: docRef.id, ...renovation });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Update progres renovasi (upload foto, catatan)
exports.updateRenovation = async (req, res) => {
  try {
    const id = req.params.id;
    const { progress, photoUrl, note, isCompleted } = req.body;

    const doc = await db.collection('Renovations').doc(id).get();
    if (!doc.exists) return res.status(404).json({ message: 'Not found' });

    const renovation = doc.data();
    const updatedPhotos = renovation.photos || [];
    if (photoUrl) updatedPhotos.push(photoUrl);

    await db.collection('Renovations').doc(id).update({
      progress: progress ?? renovation.progress,
      photos: updatedPhotos,
      note: note ?? renovation.note,
      isCompleted: isCompleted ?? false,
    });

    res.json({ message: 'Renovation updated successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Ambil semua renovasi
exports.getAllRenovations = async (req, res) => {
  try {
    const snapshot = await db.collection('Renovations').get();
    const data = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Ambil berdasarkan ID
exports.getRenovationById = async (req, res) => {
  try {
    const doc = await db.collection('Renovations').doc(req.params.id).get();
    if (!doc.exists) return res.status(404).json({ message: 'Not found' });
    res.json({ id: doc.id, ...doc.data() });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Hapus
exports.deleteRenovation = async (req, res) => {
  try {
    await db.collection('Renovations').doc(req.params.id).delete();
    res.json({ message: 'Renovation deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
