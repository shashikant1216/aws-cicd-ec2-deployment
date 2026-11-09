const {test} = require('node:test');
const assert = require('node:assert/strict');
const {server} = require('./server');
test('HTTP endpoints', async () => {
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  try {
    const base = `http://127.0.0.1:${server.address().port}`;
    const health = await fetch(base + '/health');
    assert.equal(health.status, 200);
    assert.equal((await health.json()).status, 'healthy');
    assert.equal((await fetch(base + '/')).status, 200);
    assert.equal((await fetch(base + '/missing')).status, 404);
  } finally { await new Promise(resolve => server.close(resolve)); }
});
