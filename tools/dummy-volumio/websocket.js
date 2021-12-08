var io=require('socket.io-client');

var socket = io.connect('ws://192.168.1.96:3000');

socket.emit('volume', 100);

console.log('Setting up WebSocket');

//Report successful connection
socket.on('connect', function () {
    console.log('Client Connected');
});

//Report disconnection
socket.on('disconnect', function () {
    console.log('Client Disconnected');
});

//Notify on player state changes, this includes volume changes, songs etc
socket.on('pushState', function (data) {
    console.log(data);
});

socket.on('pushBrowseLibrary', function (data) {
    console.log(data);
});

//socket.emit('volume', 15);
socket.emit('browseLibrary', {"uri": "music-library"});
