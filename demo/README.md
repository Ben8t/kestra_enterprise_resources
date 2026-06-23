# Demo support assets

Everything in here exists to make local demos of the Kestra flows in
`../resources/flows/` work. None of it is deployed — it's wired in via
`../docker-compose.yml` or invoked manually.

## Contents

- **`ftp-ui/`** — Flask app that exposes a small upload page on
  `http://localhost:8088` and drops files into the `ftp` service. Mounted
  into the `ftp-ui` container in `docker-compose.yml`.
- **`local_api/`** — FastAPI service that serves `data/data.json` on
  `http://localhost:28080/data`. Consumed by
  `../resources/flows/local_etl.yaml` via `host.docker.internal:28080`.
  See `local_api/README.md` for how to run it.
- **`samples/`** — Sample PDFs (`sample.pdf`, `sample1.pdf`) used as inputs
  for demo flows (uploaded through the FTP UI).
- **`seed_demo_data.sql`** — SQL to seed the demo database with starter data.
