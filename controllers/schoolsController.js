const { db } = require('../config/firebase');

exports.getAllSchools = async (req, res) => {
  try {
    const snapshot = await db.collection('Schools').get();
    const schools = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(schools);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getSchoolById = async (req, res) => {
  try {
    const doc = await db.collection('Schools').doc(req.params.id).get();
    if (!doc.exists) return res.status(404).json({ message: 'School not found' });
    res.json({ id: doc.id, ...doc.data() });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.createSchool = async (req, res) => {
  try {
    const { name, location, studentCount, logoUrl } = req.body;

    const newSchool = {
      name,
      location,
      studentCount: parseInt(studentCount),
      logoUrl: logoUrl || '',
      score: 100,
      status: 'Baik', // default
      createdAt: new Date().toISOString()
    };

    const docRef = await db.collection('Schools').add(newSchool);
    res.status(201).json({ id: docRef.id, ...newSchool });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateSchool = async (req, res) => {
  try {
    const schoolId = req.params.id;
    const data = req.body;
    await db.collection('Schools').doc(schoolId).update(data);
    res.json({ message: 'School updated successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.deleteSchool = async (req, res) => {
  try {
    const schoolId = req.params.id;
    await db.collection('Schools').doc(schoolId).delete();
    res.json({ message: 'School deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
