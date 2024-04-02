const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);
const port = 3000;

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', (socket) => {
  socket.on('tree', (arg, callback) => {
    socket.broadcast.timeout(1000).emit('tree', JSON.parse(arg), () => {
      callback();
    });
  });
  socket.on('factory', (arg, callback) => {
    socket.broadcast.timeout(1000).emit('factory', arg, () => {
      callback();
    });
  });
  socket.on('image', (arg, callback) => {
    socket.broadcast.timeout(2000).emit('image', arg, (err, responses) => {
      if (responses[0] && responses[0] instanceof Buffer) {
        callback(responses[0]);
      }
    });
  });
});

server.listen(port, () => {
  console.log('http://localhost:' + port);
});
