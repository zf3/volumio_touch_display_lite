const express = require('express')
const path = require('path')

const app = express()
const port = 3000

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
  if (cacheid && p) {
    res.sendFile(path.resolve(__dirname, 'albumart.jpg'))
  } else {
    res.send('No album art')
  }
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})