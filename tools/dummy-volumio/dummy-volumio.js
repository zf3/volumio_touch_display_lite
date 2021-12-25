// https://socket.io/get-started/chat

const express = require('express')
const fs = require('fs')
const path = require('path')

const app = express()
const http = require('http');
const server = http.createServer(app);
const io = require('socket.io')(server, {});

const port = 3000;

app.get('/', (req, res) => {
  res.send('Fake Volumio API server. See https://volumio.github.io/docs/API/REST_API.html')
})

app.get('/api/v1/browse', (req, res) => {
    var uri = req.query.uri;
    // res.send('Browsing: ' + uri);
    if (!uri || uri == '/') {
        res.setHeader('Accept', 'application/json');
        res.setHeader('Access-Control_Allow_Origin', '*');
        res.sendFile(path.resolve(__dirname, 'root.json'));
    } else if (uri == 'music-library') {
      res.sendFile(path.resolve(__dirname, "library.json"))
    } else {
        res.setHeader('Accept', 'application/json');
        res.setHeader('Access-Control_Allow_Origin', '*');
        res.send('{"navigation": { "lists": []}}')
    }
})

app.get('/api/v1/getState', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'state.json'))
})

app.get('/albumart', (req, res) => {
  var cacheid = req.query.cacheid
  var p = req.query.path
  console.log(`albumart: cacheid=${cacheid}, p=${p}`)
  res.set('Access-Control-Allow-Origin', '*');
  if (cacheid && p) {
    console.log('Sending albumart.jpg')
    res.sendFile(path.resolve(__dirname, 'albumart.jpg'))
  } else {
    res.send('No album art')
  }
})

var rootJson = JSON.parse(fs.readFileSync(path.resolve(__dirname, 'root.json')))
var libraryJson = JSON.parse(fs.readFileSync(path.resolve(__dirname, 'library.json')))
var emptyDir = JSON.parse('{"navigation": { "lists": []}}')
var stateJson = JSON.parse(fs.readFileSync(path.resolve(__dirname, 'state.json')))

// console.log('rootJson: '+JSON.stringify(rootJson))

io.on('connection', (socket) => {
  console.log('A user connected');
  socket.on('getBrowseSources', (msg) => {
    console.log('pushBrowseSources: ' + rootJson);
    socket.emit('pushBrowseSources', rootJson);
  })
  socket.on('browseLibrary', (msg) => {
    var uri = msg.uri
    console.log("browseLibrary: "+uri)
    if (uri == 'music-library') {
      socket.emit('pushBrowseLibrary', libraryJson)
    } else {
      socket.emit('pushBrowseLibrary', emptyDir)
    }
  })
  socket.on('getState', (msg) => {
    console.log('getState');
    socket.emit('pushState', stateJson)
  })
})

server.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})