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

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
