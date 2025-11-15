const express = require('express');
const cors = require('cors');
const db = require('./config/database'); 

const app = express();

app.use(cors());
app.use(express.json()); 
app.use('/uploads', express.static('public/uploads'));

const authRoutes = require('./routes/auth');
const laporanRoutes = require('./routes/laporan');
const beritaRoutes = require('./routes/berita');
const adminRoutes = require('./routes/admin');
const uploadRoutes = require('./routes/upload');

app.use('/auth', authRoutes);
app.use('/laporan', laporanRoutes);
app.use('/berita', beritaRoutes);
app.use('/admin', adminRoutes);
app.use('/upload', uploadRoutes);

app.get('/', (req, res) => {
  res.send('API Lapor Balongmojo sedang berjalan...');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server berjalan di port ${PORT}`);
});