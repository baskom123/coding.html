const http = require("http");

const host = 'localhost';
const port = 8000;

const requestListener = function (req, res) {
    res.setHeader("Content-Type", "application/json");
    res.writeHead(200);
    res.end(`{"message": "nama saya Vantur"}`);
};

const server = http.createServer(requestListener);
server.listen(port, host,() => {
    console.log(`server is running on http://${host}:${port}`);
});