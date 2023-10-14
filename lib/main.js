const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const app = express();
const port = 3001;
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'spc_calculations',
  password: 'admin',
  port: 5432,
});

app.use(cors());
app.use(express.json());

// Define routes

// Retrieve data
app.get('/data', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM values_measurement');
    const results = { 'results': (result) ? result.rows : null };
    res.json(results);
    client.release();
  } catch (err) {
    console.error(err);
    res.status(500).send("Internal Server Error");
  }
});

// Add data
app.post('/addData', async (req, res) => {
  const client = await pool.connect();

  try {
    const { value, timestamp } = req.body;

    // Start a transaction
    await client.query('BEGIN');

    // Insert the data into the values_measurement table
    await client.query('INSERT INTO values_measurement (value, timestamp) VALUES ($1, $2)', [value, timestamp]);

    // Calculate MR and update the mr column
    if (timestamp > 1) {
      const prevValueResult = await client.query('SELECT value FROM values_measurement WHERE timestamp = $1', [timestamp - 1]);
      const prevValue = prevValueResult.rows[0].value;
      const mr = Math.abs(value - prevValue);
      await client.query('UPDATE values_measurement SET mr = $1 WHERE timestamp = $2', [mr, timestamp]);
    }

    // Commit the transaction to persist the changes
    await client.query('COMMIT');

    res.status(200).send('Data added and committed');
  } catch (err) {
    // If there's an error, roll back the transaction to avoid partial updates
    await client.query('ROLLBACK');
    console.error(err);
    res.status(500).send("Internal Server Error");
  } finally {
    client.release();
  }
});

// Calculate SPC results
app.post('/calculate-spc', async (req, res) => {
    try {
        // Check if there's already a row in the spc_result table
        const existingResult = await pool.query('SELECT COUNT(*) FROM spc_result');
        const rowExists = existingResult.rows[0].count > 0;
    
        if (rowExists) {
          // Update the existing row in spc_result
          await pool.query(`
            UPDATE spc_result
            SET
              xbar = (SELECT AVG(vm.value) FROM values_measurement vm),
              sd = (SELECT STDDEV(vm.value)::numeric::decimal(10,3) FROM values_measurement vm),
              USL = 525, 
              LSL = 475, 
              pp = ((525 - 475) / (6 * (SELECT STDDEV(vm.value)::numeric::decimal(10,3) FROM values_measurement vm)))::numeric::decimal(10,3),
              PPU = ((525 - (SELECT AVG(vm.value) FROM values_measurement vm)) / (3 * (SELECT STDDEV(vm.value)::numeric::decimal(10,3) FROM values_measurement vm)))::numeric::decimal(10,3),
              PPL = (((SELECT AVG(vm.value) FROM values_measurement vm) - 475) / (3 * (SELECT STDDEV(vm.value)::numeric::decimal(10,3) FROM values_measurement vm)))::numeric::decimal(10,3),
              Ppk = LEAST(
                (525 - (SELECT AVG(vm.value) FROM values_measurement vm)) / (3 * (SELECT STDDEV(vm.value)::numeric::decimal(10,3) FROM values_measurement vm)),
                (((SELECT AVG(vm.value) FROM values_measurement vm) - 475) / (3 * (SELECT STDDEV(vm.value)::numeric::decimal(10,3) FROM values_measurement vm)))
              )::numeric::decimal(10,3),
              RBAR = (
                SELECT SUM(MR) / COUNT(CASE WHEN MR >= 0 THEN 1 ELSE NULL END) AS Rbar
                FROM values_measurement
              )::numeric::decimal(10,3),
              SDW = (
                (SELECT SUM(MR) / COUNT(CASE WHEN MR >= 0 THEN 1 ELSE NULL END) AS Rbar FROM values_measurement) / 1.128
              )::numeric::decimal(10,3),
              CP = ((525 - 475) / (6 * (SELECT STDDEV(vm.value)::numeric::decimal(10,3) FROM values_measurement vm)))::numeric::decimal(10,3),
              CPU = (
                (525 - (SELECT AVG(vm.value) FROM values_measurement vm)) /
                (3 * (
                  SELECT (
                    (SELECT SUM(MR) / COUNT(CASE WHEN MR >= 0 THEN 1 ELSE NULL END) AS Rbar FROM values_measurement) / 1.128
                  )::numeric::decimal(10,3)
                ))
              )::numeric::decimal(10,3),
              CPL = (
                ((SELECT AVG(vm.value) FROM values_measurement vm) - 475) /
                (3 * (
                  SELECT (
                    (SELECT SUM(MR) / COUNT(CASE WHEN MR >= 0 THEN 1 ELSE NULL END) AS Rbar FROM values_measurement) / 1.128
                  )::numeric::decimal(10,3)
                ))
              )::numeric::decimal(10,3),
              CPK = LEAST(
                (
                  (525 - (SELECT AVG(vm.value) FROM values_measurement vm)) /
                  (3 * (
                    SELECT (
                      (SELECT SUM(MR) / COUNT(CASE WHEN MR >= 0 THEN 1 ELSE NULL END) AS Rbar FROM values_measurement) / 1.128
                    )::numeric::decimal(10,3)
                  ))
                )::numeric::decimal(10,3),
                (
                  ((SELECT AVG(vm.value) FROM values_measurement vm) - 475) /
                  (3 * (
                    SELECT (
                      (SELECT SUM(MR) / COUNT(CASE WHEN MR >= 0 THEN 1 ELSE NULL END) AS Rbar FROM values_measurement) / 1.128
                    )::numeric::decimal(10,3)
                  ))
                )::numeric::decimal(10,3)
              ),
              ucl = (
                (SELECT AVG(vm.value) FROM values_measurement vm) +
                (
                  SELECT A2 FROM standardsample WHERE sample_size = 2
                ) *
                (
                  SELECT SUM(MR) / COUNT(CASE WHEN MR >= 0 THEN 1 ELSE NULL END) AS Rbar
                  FROM values_measurement
                )
              )::numeric::decimal(10, 3),
              lcl = (
                (SELECT AVG(vm.value) FROM values_measurement vm) -
                (
                  SELECT A2 FROM standardsample WHERE sample_size = 2
                ) *
                (
                  SELECT SUM(MR) / COUNT(CASE WHEN MR >= 0 THEN 1 ELSE NULL END) AS Rbar
                  FROM values_measurement
                )
              )::numeric::decimal(10, 3);
          `);
        } else {
          // If no row exists, insert a new one
          await pool.query(`
            INSERT INTO spc_result (xbar, sd)
            SELECT AVG(vm.value) AS xbar, STDDEV(vm.value)::numeric::decimal(10,3)
            FROM values_measurement vm;
          `);
        }
    
        // Select all data from spc_result
        const result = await pool.query('SELECT * FROM spc_result');
    
        res.json(result.rows);
      } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal Server Error' });
      }
  // Your SPC calculation logic here
  // You can use existingResult to check for the existence of data
  // Update existing data or insert new data as needed
  // Provide the calculated results in the response
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});