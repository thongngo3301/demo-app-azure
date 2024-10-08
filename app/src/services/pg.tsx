import { Pool } from "pg";

const pgConfig = {
  host: process.env.PG_HOST,
  port: parseInt(process.env.PG_PORT ?? "5432"),
  database: process.env.PG_DATABASE,
  user: process.env.PG_USER,
  password: process.env.PG_PASSWORD,
  ssl: {
    rejectUnauthorized: false,
  },
};

const pgConnectionPool = new Pool(pgConfig);

export default pgConnectionPool;
