const http = require('http');
const host = "localhost";
const port = 8000;

const requestListener = function (req,res) {
    res.setHeader("content-Type", "application/json");
    res.writeHead(200);
    res.end(JSON.stringify({
        Name: "Vantur siringoringo",
        Email: "2111112210@students.mikroskil.ac.id",
        Nim: "211111221",
        Birthday: "24/03/03",
        Ipk: "3.0"
    }))    
}

const server = http.createServer(requestListener);
server.listen(port, host, () => {
    console.log(`Server is running on http://${host}:${8000}`); 
});