const express = require('express');
const app = express();
app.use(express.json());

const PORT = process.env.PORT || 8001;

// 4 Official UNTIDAR Officers + Student Secretariat
const USERS = [
  {
    id: 'usr-1',
    role: 'sekretaris',
    name: 'Hanif Abdillah Alatas',
    idNum: 'NPM. 2420506041',
    title: 'Sekretaris Panitia DigitalWave 2026',
    email: 'hanif.abdillah@students.untidar.ac.id'
  },
  {
    id: 'usr-2',
    role: 'ketua_pelaksana',
    name: 'Emannuel Henji Pratama Putra',
    idNum: 'NPM. 2505060012',
    title: 'Ketua Panitia Pelaksana',
    email: 'emannuel.henji@students.untidar.ac.id'
  },
  {
    id: 'usr-3',
    role: 'ketua_himatif',
    name: 'Naufal Miftakhul Siddiq',
    idNum: 'NPM. 2440506060',
    title: 'Ketua Umum HIMATIF UNTIDAR',
    email: 'naufal.miftakhul@students.untidar.ac.id'
  },
  {
    id: 'usr-4',
    role: 'wadek',
    name: 'Dr. Sigit Iswahyudi, S.T., M.T.',
    idNum: 'NIP. 197510302021211005',
    title: 'Wakil Dekan Bidang Akademik & Kemahasiswaan FT UNTIDAR',
    email: 'sigit.iswahyudi@untidar.ac.id'
  }
];

// Health check
app.get('/health', (req, res) => res.json({ status: 'healthy', service: 'auth-service' }));

// Login
app.post('/api/v1/auth/login', (req, res) => {
  const { role } = req.body;
  const user = USERS.find(u => u.role === role) || USERS[0];
  const token = `token_untidar_${user.role}_${Date.now()}`;

  res.json({
    status: 'success',
    data: {
      user,
      token,
      expiresIn: '24h'
    }
  });
});

// Profile & Validate Token
app.get('/api/v1/auth/me', (req, res) => {
  const authHeader = req.headers.authorization || '';
  const role = authHeader.includes('wadek') ? 'wadek' : (authHeader.includes('ketua_himatif') ? 'ketua_himatif' : 'sekretaris');
  const user = USERS.find(u => u.role === role);
  res.json({ status: 'success', data: user });
});

app.listen(PORT, () => {
  console.log(`[Auth Service] Running on port ${PORT}`);
});
