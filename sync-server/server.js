const { WebSocketServer } = require('ws');

const wss = new WebSocketServer({ port: 3000 });
const clients = new Map();

wss.on('connection', (ws) => {
  const id = Date.now().toString(36) + Math.random().toString(36).slice(2);
  clients.set(ws, { id, role: null });

  ws.on('message', (raw) => {
    try {
      const msg = JSON.parse(raw);
      if (msg.type === 'role') {
        clients.get(ws).role = msg.role;
      } else if (msg.type === 'state') {
        for (const [client] of clients) {
          if (client !== ws && client.readyState === 1) {
            client.send(JSON.stringify(msg));
          }
        }
      }
    } catch {}
  });

  ws.on('close', () => clients.delete(ws));
});

console.log('Sync server running on port 3000');
