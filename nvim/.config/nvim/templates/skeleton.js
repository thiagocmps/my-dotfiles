const http = require("http");
require("dotenv").config();
const app = require("./app"); // Import the configured Express app
const server = http.createServer(app); // Create an HTTP server using the Express app
const PORT = process.env.PORT || 3000;
// Start the server and listen on the specified port
server.listen(PORT, () => {
  console.log(`Server running on port: ${PORT}`);
});
