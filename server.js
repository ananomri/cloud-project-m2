const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const os = require('os');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const DB_HOST = process.env.DB_HOST || 'localhost';
const DB_USER = process.env.DB_USER || 'admin';
const DB_PASS = process.env.DB_PASS || 'password';
const DB_NAME = process.env.DB_NAME || 'cloudapp';

// Health check pour l'ALB
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', instance: os.hostname() });
});

// API - Liste des messages
app.get('/api/messages', async (req, res) => {
  try {
    const connection = await mysql.createConnection({
      host: DB_HOST,
      user: DB_USER,
      password: DB_PASS,
      database: DB_NAME
    });
    const [rows] = await connection.execute('SELECT * FROM messages ORDER BY created_at DESC');
    await connection.end();
    res.json({ success: true, data: rows, instance: os.hostname() });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// API - Ajouter un message
app.post('/api/messages', async (req, res) => {
  try {
    const { content, author } = req.body;
    const connection = await mysql.createConnection({
      host: DB_HOST,
      user: DB_USER,
      password: DB_PASS,
      database: DB_NAME
    });
    const [result] = await connection.execute(
      'INSERT INTO messages (content, author) VALUES (?, ?)',
      [content, author || 'Anonyme']
    );
    await connection.end();
    res.json({ success: true, id: result.insertId });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// API - Info
app.get('/api/info', (req, res) => {
  res.json({
    app: 'Cloud Project API',
    version: '1.0.0',
    instance: os.hostname(),
    uptime: process.uptime()
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
