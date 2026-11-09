const http = require('node:http');
function handler(req, res) {
  if (req.url === '/health') {
    res.writeHead(200, {'Content-Type': 'application/json'});
    return res.end(JSON.stringify({status: 'healthy'}));
  }
  if (req.url !== '/') { res.writeHead(404); return res.end('Not found'); }
  res.writeHead(200, {'Content-Type': 'application/json'});
  res.end(JSON.stringify({message: 'Shashikant AWS DevOps Demo', version: process.env.APP_VERSION || '1.0.0'}));
}
const server = http.createServer(handler);
if (require.main === module) {
  server.listen(Number(process.env.PORT || 3000), '0.0.0.0');
  process.on('SIGTERM', () => server.close(() => process.exit(0)));
}
module.exports = {server};
