const express = require("express");
const mysql = require("mysql2/promise");

const app = express();
const PORT = 3000;

/*
Database configuration using environment variables
These will be injected from ECS task definition or GitHub secrets
*/

const dbConfig = {
  host: process.env.DB_HOST,
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
};

/*
Create MySQL connection pool
Better for production because it reuses connections
*/

let pool;

async function initializeDatabase() {
  try {
    pool = mysql.createPool({
      ...dbConfig,
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0,
    });

    const connection = await pool.getConnection();
    console.log("Connected to MySQL database successfully");
    connection.release();
  } catch (error) {
    console.error("Database connection failed:", error);
  }
}

/*
Root endpoint
*/

app.get("/", async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT NOW() AS current_time");

    res.json({
      message: "Hello from ECS Fargate DevOps Project",
      database_time: rows[0].current_time,
    });
  } catch (error) {
    console.error("Query failed:", error);
    res.status(500).send("Database query failed");
  }
});

/*
Health check endpoint
ALB health checks will use this
*/

app.get("/health", async (req, res) => {
  try {
    await pool.query("SELECT 1");
    res.status(200).send("OK");
  } catch (error) {
    res.status(500).send("Database unhealthy");
  }
});

/*
Start server after DB initialization
*/

initializeDatabase().then(() => {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
});
