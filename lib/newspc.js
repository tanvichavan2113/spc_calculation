// const express = require('express');
// const cors = require('cors');
// const { Pool } = require('pg');
// const bodyParser = require('body-parser');

// const app = express();
// const port = 3000;

// app.use(cors());
// app.use(bodyParser.json());

// const pool = new Pool({
//     user: 'postgres',
//     host: 'localhost',
//     database: 'spc_calculations',
//     password: 'admin',
//     port: 5432,
// });

// app.get('/', (req, res) => {
//   res.send('Welcome to the SPC Result API');
// });

// app.post('/calculate-spc', async (req, res) => {
//   try {
//     // Insert into spc_result
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

// app.listen(port, () => {
//   console.log(`Server is running at http://localhost:${port}`);
// });


const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// Use CORS middleware
app.use(cors());

// Use bodyParser for JSON parsing
app.use(bodyParser.json());

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'spc_calculations',
    password: 'admin',
    port: 5432,
});

app.get('/', (req, res) => {
  res.send('Welcome to the SPC Result API');
});

app.post('/calculate-spc', async (req, res) => {
  try {
    // Insert into spc_result
    await pool.query(`
      INSERT INTO spc_result (xbar, sd)
      SELECT AVG(vm.value) AS xbar, STDDEV(vm.value)::numeric::decimal(10,3)
      FROM values_measurement vm;
    `);

    // Update USL, LSL, and pp
    await pool.query(`
      UPDATE spc_result
      SET USL = 525, LSL = 475, pp = (
        SELECT (usl - lsl) / (6 * sd))::numeric::decimal(10,3);
    `);

    // Update PPU
    await pool.query(`
      UPDATE spc_result
      SET PPU = ((USL - xbar) / (3 * sd))::numeric::decimal(10,3);
    `);

    // Update PPL
    await pool.query(`
      UPDATE spc_result
      SET PPL = ((xbar - LSL) / (3 * sd))::numeric::decimal(10,3);
    `);

    // Update Ppk
    await pool.query(`
      UPDATE spc_result
      SET Ppk = LEAST((USL - xbar) / (3 * sd), (xbar - LSL) / (3 * sd))::numeric::decimal(10,3);
    `);

    // Update RBAR
    await pool.query(`
      UPDATE spc_result
      SET RBAR = (
        SELECT SUM(MR) / COUNT(CASE WHEN MR >= 0 THEN 1 ELSE NULL END) AS Rbar
        FROM values_measurement)::numeric::decimal(10,3);
    `);

    // Update SD Within
    await pool.query(`
      UPDATE spc_result
      SET SDW = ((RBAR) / (1.128))::numeric::decimal(10,3);
    `);

    // Update CP
    await pool.query(`
      UPDATE spc_result
      SET CP = ((USL - LSL) / (6 * sd))::numeric::decimal(10,3);
    `);

    // Update CPU
    await pool.query(`
      UPDATE spc_result
      SET CPU = ((USL - xbar) / (3 * SDW))::numeric::decimal(10,3);
    `);

    // Update CPL
    await pool.query(`
      UPDATE spc_result
      SET CPL = ((xbar - LSL) / (3 * SDW))::numeric::decimal(10,3);
    `);

    // Update CPK
    await pool.query(`
      UPDATE spc_result
      SET CPK = LEAST(CPU, CPL)::numeric::decimal(10,3);
    `);

    // Update ucl and lcl
    await pool.query(`
      UPDATE spc_result
      SET 
        ucl = (xbar + (
          SELECT A2 FROM standardsample WHERE sample_size = 2
        ) * rbar)::numeric::decimal(10, 3),
        lcl = (xbar - (
          SELECT A2 FROM standardsample WHERE sample_size = 2
        ) * rbar)::numeric::decimal(10, 3);
    `);

    // Select all data from spc_result
    const result = await pool.query('SELECT * FROM spc_result');

    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
