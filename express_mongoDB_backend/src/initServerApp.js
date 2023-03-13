import express from 'express'
import connectDB from "./config/connect_db.js";
import usersRouterController from "./routes_controller/users_router_controller.js";


const initServerApp = express();
const port = process.env.PORT || '8000';
const DATABASE_URL = process.env.DATABASE_URL || "mongodb://127.0.0.1:27017";

// Database Connection
connectDB(DATABASE_URL);

// JSON
initServerApp.use(express.json());

// Load Routes
initServerApp.use('/api', usersRouterController);

initServerApp.get('/', function (req, res) {
  res.send('Hello World');
});

initServerApp.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`)
 })












