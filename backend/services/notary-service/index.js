const express = require('express');
const crypto = require('crypto');
const app = express();
app.use(express.json());

const PORT = process.env.PORT || 8003;

// Health check
app.get('/health', (req, res) => res.json({ status: 'healthy', service: 'notary-service' }));

// Generate SHA-256 Digest & QR Token
app.post('/api/v1/notary/sign', (req, res) => {
  const { documentId, signerRole, payloadText } = req.body;
  const hash = crypto.createHash('sha256').update(payloadText || documentId + Date.now()).digest('hex');
  const qrToken = crypto.randomUUID();

  res.json({
    status: 'success',
    data: {
      documentId,
      signerRole,
      hashSha256: hash,
      qrToken: qrToken,
      stampedAt: new Date().toISOString(),
      notarySeal: 'DEKANAT_FT_UNTIDAR_VALIDATED'
    }
  });
});

app.listen(PORT, () => {
  console.log(`[Notary Service] Running on port ${PORT}`);
});
