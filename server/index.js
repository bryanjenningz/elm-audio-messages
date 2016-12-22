const express = require('express')
const app = express()
const server = require('http').createServer(app)
const io = require('socket.io')(server)

app.use(express.static('.'))

io.on('connection', socket => {
  socket.on('sendText', text => io.emit('receiveText', text))
  socket.on('sendAudio', audio => io.emit('receiveAudio', audio))
})

server.listen(3000, () => console.log('Listening on port 3000'))
