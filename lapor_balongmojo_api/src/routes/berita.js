const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { verifyToken, isPerangkat } = require('../middleware/auth');

router.post('/', [verifyToken, isPerangkat], async (req, res) => {
  try {
    const { judul, isi } = req.body;
    const author_id = req.user.id;

    await db.execute(
      'INSERT INTO berita (author_id, judul, isi) VALUES (?, ?, ?)',
      [author_id, judul, isi]
    );
    
    res.status(201).json({ message: 'Berita berhasil dipublikasikan.' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.get('/', async (req, res) => {
  try {
    const [berita] = await db.execute(
      'SELECT b.*, u.nama_lengkap AS author_name FROM berita b JOIN users u ON b.author_id = u.id ORDER BY b.created_at DESC'
    );
    res.json(berita);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;