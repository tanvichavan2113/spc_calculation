// // ... (previous Node.js code)
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
// app.use(express.json());

// app.get('/data', async (req, res) => {
//     try {
//         const client = await pool.connect();
//         const result = await client.query('SELECT * FROM values_measurement');
//         const results = { 'results': (result) ? result.rows : null };
//         res.json(results);
//         client.release();
//     } catch (err) {
//         console.error(err);
//         res.status(500).send("Internal Server Error");
//     }
// });

// app.post('/addData', async (req, res) => {
//     try {
//         const { value, timestamp } = req.body;
//         const client = await pool.connect();

//         // Insert the data into the values_measurement table
//         await client.query('INSERT INTO values_measurement (value, timestamp) VALUES ($1, $2)', [value, timestamp]);

//         // Calculate MR and update the mr column
//         if (timestamp > 1) {
//             const prevValueResult = await client.query('SELECT value FROM values_measurement WHERE timestamp = $1', [timestamp - 1]);
//             const prevValue = prevValueResult.rows[0].value;
//             const mr = Math.abs(value - prevValue);

//             await client.query('UPDATE values_measurement SET mr = $1 WHERE timestamp = $2', [mr, timestamp]);
//         }

//         res.sendStatus(200);
//         client.release();
//     } catch (err) {
//         console.error(err);
//         res.status(500).send("Internal Server Error");
//     }
// });

// app.listen(port, () => {
//     console.log(`Server is running on port ${port}`);
// });

// app.post('/addData', async (req, res) => {
//     try {
//         const { value, timestamp } = req.body;
//         const client = await pool.connect();

//         // Insert the data into the values_measurement table
//         await client.query('INSERT INTO values_measurement (value, timestamp) VALUES ($1, $2)', [value, timestamp]);

//         // Calculate MR and update the mr column
//         if (timestamp > 1) {
//             const prevValueResult = await client.query('SELECT value FROM values_measurement WHERE timestamp = $1', [timestamp - 1]);
//             const prevValue = prevValueResult.rows[0].value;
//             const mr = Math.abs(value - prevValue);

//             await client.query('UPDATE values_measurement SET mr = $1 WHERE timestamp = $2', [mr, timestamp]);
//         }

//         res.sendStatus(200);
//         client.release();
//     } catch (err) {
//         console.error(err);
//         res.status(500).send("Internal Server Error");
//     }
// });

// app.get('/calculateMetrics', async (req, res) => {
//     try {
//         const client = await pool.connect();

//         // Perform calculations here and update the necessary columns in the values_measurement table
//         // For simplicity, let's assume X bar, Stdev Overall, Pp, Ppu, Ppl, Ppk, Rbar, Stdev Within, Cp, Cpu, Cpl, Cpk are calculated and updated in the table

//         // ...

//         res.sendStatus(200);
//         client.release();
//     } catch (err) {
//         console.error(err);
//         res.status(500).send("Internal Server Error");
//     }
// });

// // ... (remaining Node.js code)



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

app.post('/addData', async (req, res) => {
    try {
        const { value, timestamp } = req.body;
        const client = await pool.connect();

        // Insert the data into the values_measurement table
        await client.query('INSERT INTO values_measurement (value, timestamp) VALUES ($1, $2)', [value, timestamp]);

        // Calculate MR and update the mr column
        if (timestamp > 1) {
            const prevValueResult = await client.query('SELECT value FROM values_measurement WHERE timestamp = $1', [timestamp - 1]);
            const prevValue = prevValueResult.rows[0].value;
            const mr = Math.abs(value - prevValue);

            await client.query('UPDATE values_measurement SET mr = $1 WHERE timestamp = $2', [mr, timestamp]);
        }

        res.sendStatus(200);
        client.release();
    } catch (err) {
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

app.get('/calculateMetrics', async (req, res) => {
    try {
        const client = await pool.connect();

        // Calculate X bar and Stdev Overall
        const xbarAndSdResult = await client.query('UPDATE spc_result SET xbar = AVG(value)::numeric::decimal(10,3), sd = STDDEV(value)::numeric::decimal(10,3) FROM values_measurement');

        // Update USL, LSL, pp based on your requirements
        await client.query('UPDATE spc_result SET USL = 525, LSL = 475, pp = (USL - LSL) / (6 * sd)::numeric::decimal(10,3)');

        // Update PPU, PPL, Ppk
        await client.query('UPDATE spc_result SET PPU = ((USL - xbar) / (3 * sd))::numeric::decimal(10,3), PPL = ((xbar - LSL) / (3 * sd))::numeric::decimal(10,3), Ppk = LEAST((USL - xbar) / (3 * sd), (xbar - LSL) / (3 * sd))::numeric::decimal(10,3)');

        // Update RBAR
        const rbarResult = await client.query('UPDATE spc_result SET RBAR = (SELECT SUM(MR) / COUNT(CASE WHEN MR >= 0 THEN 1 ELSE NULL END) AS Rbar FROM values_measurement)::numeric::decimal(10,3)');

        // Update SDW
        await client.query('UPDATE spc_result SET SDW = (RBAR / 1.128)::numeric::decimal(10,3)');

        // Update CP, CPU, CPL, CPK
        await client.query('UPDATE spc_result SET CP = ((USL - LSL) / (6 * sd))::numeric::decimal(10,3), CPU = ((USL - xbar) / (3 * SDW))::numeric::decimal(10,3), CPL = ((xbar - LSL) / (3 * SDW))::numeric::decimal(10,3), CPK = LEAST(CPU, CPL)::numeric::decimal(10,3)');

        // Update ucl and lcl
        await client.query('UPDATE spc_result SET ucl = (xbar + (SELECT A2 FROM standardsample WHERE sample_size = 2) * rbar)::numeric::decimal(10,3), lcl = (xbar - (SELECT A2 FROM standardsample WHERE sample_size = 2) * rbar)::numeric::decimal(10,3)');

        res.sendStatus(200);
        client.release();
    } catch (err) {
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
