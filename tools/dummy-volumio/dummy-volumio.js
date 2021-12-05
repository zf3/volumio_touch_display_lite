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
    } else {
        res.setHeader('Accept', 'application/json');
        res.setHeader('Access-Control_Allow_Origin', '*');
        res.send('{"navigation": { "lists": []}}')
    }
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})