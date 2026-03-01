const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Health check endpoint — ALB checks this to know if your container is alive
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Main endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'ECS Fargate App is running!',
    environment: process.env.NODE_ENV || 'development',
    // This shows secrets are injected (don't actually log real secret values in prod)
    db_password_set: !!process.env.DB_PASSWORD,
    api_key_set: !!process.env.API_KEY
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});