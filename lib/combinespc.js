// const express = require('express');
// const { Pool } = require('pg');
// const cors = require('cors');

// const app = express();
// const port = 3001;

// const pool = new Pool({
//     user: 'postgres',
//     host: 'localhost',
//     database: 'spc_calculations',
//     password: 'admin',
//     port: 5432,
// });

// app.use(cors());

// app.get('/', (req, res) => {
//   res.send('Welcome to the SPC Result API');
// });

// app.post('/calculate-spc', async (req, res) => {
//   try {
//     await pool.query(`
//       INSERT INTO spc_result (xbar, sd)
//       SELECT AVG(vm.value) AS xbar, STDDEV(vm.value)::numeric::decimal(10,3)
//       FROM values_measurement vm;
//     `);

//     // Update USL, LSL, and pp
//     await pool.query(`
//       UPDATE spc_result
//       SET USL = 525, LSL = 475, pp = (
//         SELECT (usl - lsl) / (6 * sd))::numeric::decimal(10,3);
//     `);

//     // Update PPU
//     await pool.query(`
//       UPDATE spc_result
//       SET PPU = ((USL - xbar) / (3 * sd))::numeric::decimal(10,3);
//     `);

//     // Update PPL
//     await pool.query(`
//       UPDATE spc_result
//       SET PPL = ((xbar - LSL) / (3 * sd))::numeric::decimal(10,3);
//     `);

//     // Update Ppk
//     await pool.query(`
//       UPDATE spc_result
//       SET Ppk = LEAST((USL - xbar) / (3 * sd), (xbar - LSL) / (3 * sd))::numeric::decimal(10,3);
//     `);

//     // Update RBAR
//     await pool.query(`
//       UPDATE spc_result
//       SET RBAR = (
//         SELECT SUM(MR) / COUNT(CASE WHEN MR >= 0 THEN 1 ELSE NULL END) AS Rbar
//         FROM values_measurement)::numeric::decimal(10,3);
//     `);

//     // Update SD Within
//     await pool.query(`
//       UPDATE spc_result
//       SET SDW = ((RBAR) / (1.128))::numeric::decimal(10,3);
//     `);

//     // Update CP
//     await pool.query(`
//       UPDATE spc_result
//       SET CP = ((USL - LSL) / (6 * sd))::numeric::decimal(10,3);
//     `);

//     // Update CPU
//     await pool.query(`
//       UPDATE spc_result
//       SET CPU = ((USL - xbar) / (3 * SDW))::numeric::decimal(10,3);
//     `);

//     // Update CPL
//     await pool.query(`
//       UPDATE spc_result
//       SET CPL = ((xbar - LSL) / (3 * SDW))::numeric::decimal(10,3);
//     `);

//     // Update CPK
//     await pool.query(`
//       UPDATE spc_result
//       SET CPK = LEAST(CPU, CPL)::numeric::decimal(10,3);
//     `);

//     // Update ucl and lcl
//     await pool.query(`
//       UPDATE spc_result
//       SET 
//         ucl = (xbar + (
//           SELECT A2 FROM standardsample WHERE sample_size = 2
//         ) * rbar)::numeric::decimal(10, 3),
//         lcl = (xbar - (
//           SELECT A2 FROM standardsample WHERE sample_size = 2
//         ) * rbar)::numeric::decimal(10, 3);
//     `);
//     // Select all data from spc_result
//     const result = await pool.query('SELECT * FROM spc_result');

//     res.json(result.rows);
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ error: 'Internal Server Error' });
//   }
// });

// app.get('/data', async (req, res) => {
//   try {
//     const client = await pool.connect();
//     const result = await client.query('SELECT * FROM spc_result');
//     const results = { 'results': (result) ? result.rows : null };
//     res.json(results);
//     client.release();
//   } catch (err) {
//     console.error(err);
//     res.send("Error " + err);
//   }
// });

// app.listen(port, () => {
//     console.log(`Server is running on port ${port}`);
// });
// /////////////successfully runned above code 


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

app.get('/', (req, res) => {
  res.send('Welcome to the SPC Result API');
});

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
});


app.get('/data', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM spc_result');
    const results = { 'results': (result) ? result.rows : null };
    res.json(results);
    client.release();
  } catch (err) {
    console.error(err);
    res.send("Error " + err);
  }
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
