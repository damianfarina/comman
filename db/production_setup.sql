-- db/production_setup.sql

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM pg_database WHERE datname = 'comman_production'
  ) THEN
    PERFORM dblink_exec('postgres', 'CREATE DATABASE comman_production');
  END IF;

  IF NOT EXISTS (
    SELECT FROM pg_database WHERE datname = 'comman_production_cache'
  ) THEN
    PERFORM dblink_exec('postgres', 'CREATE DATABASE comman_production_cache');
  END IF;

  IF NOT EXISTS (
    SELECT FROM pg_database WHERE datname = 'comman_production_queue'
  ) THEN
    PERFORM dblink_exec('postgres', 'CREATE DATABASE comman_production_queue');
  END IF;

  IF NOT EXISTS (
    SELECT FROM pg_database WHERE datname = 'comman_production_cable'
  ) THEN
    PERFORM dblink_exec('postgres', 'CREATE DATABASE comman_production_cable');
  END IF;
END $$;
