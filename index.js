const express = require('express');
const cors = require('cors');
const app = express();
require('dotenv').config();

// Firebase
require('./config/firebase');

// Middleware
app.use(cors());
app.use(express.json());

// Routes
const schoolRoutes = require('./routes/schools');
const reportRoutes = require('./routes/reports');
const renovationRoutes = require('./routes/renovations');
const uploadRoutes = require('./routes/upload');


app.use('/api/upload', uploadRoutes);
app.use('/api/schools', schoolRoutes);
app.use('/api/reports', reportRoutes);
app.use('/api/renovations', renovationRoutes);

// Port
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
