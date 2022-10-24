const http = require('http');

const host = "localhost";
const port = 8000;

const requestListener = function (req, res) {
    res.setHeader("Content-Type", "application/json");
    res.writeHead(200);
    res.end('{: nama = "vantur roganda siringoringo", nim = "211111221", ttl = 24/03/03}');
};

const server = http.createServer(requestListener);
server.listen(port, host,() => {
    console.log(`server is running on http://${host}:${port}`);
});