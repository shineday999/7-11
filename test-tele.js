
const https = require('https');

console.log('Testing connection to api.telegram.org...');

const options = {
  hostname: 'api.telegram.org',
  port: 443,
  path: '/',
  method: 'GET',
  family: 6 // 強制使用 IPv4 測試
};

const req = https.request(options, (res) => {
  console.log(`Status Code: ${res.statusCode}`);
  res.on('data', (d) => {
    process.stdout.write(d);
  });
});

req.on('error', (e) => {
  console.error('Error with IPv4:', e.message);
});

req.end();
