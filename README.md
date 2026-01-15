# COMMAN

**COMMAN** (short for "Company Manager") is a web application designed to streamline manufacturing, inventory, and sales operations for companies that produce and sell industrial products such as grinding stones, cutting discs, and hardware supplies.

## Features

- Client, Product, and Order management
- Manufacturing tracking and formula management
- Inventory control and supplier handling
- Optimized for desktop and mobile usage

## Tech Stack

- Ruby on Rails 8
- PostgreSQL
- TailwindCSS
- Hotwire (Turbo + Stimulus)
- RSpec for testing

## Setup Instructions

#### Clone the repository
```bash
git clone https://github.com/damianfarina/comman.git && cd comman
```
#### Setup dependencies and database
```bash
bin/setup && bin/rails db:seed
```
- bin/setup installs Ruby gems, prepares the database, and runs migrations.
- bin/rails db:seed populates the database with essential initial data, including:
  - Default user
  - Default discounts
  - Default in-house supplier

#### Setup environment variables
```bash
cp .env.sample .env
```
Edit .env and set the environment variables as needed.

You can also create environment-specific files:
- .env.dev
- .env.staging
- .env.production
- .env.demo

To use them, specify it with the -f flag. For example:
```bash
dotenv -f .env.staging kamal deploy --destination staging
```

#### Run the server
```bash
bin/rails s
```
#### Run tests
```bash
bin/rspec
```

#### Deploy to production
```bash
dotenv -f .env.production kamal deploy
```

#### Proxy SSL with Cloudflare Origin Certificates
If the app sits behind Cloudflare, you can use a Cloudflare Origin Certificate for Kamal proxy SSL.

```yaml
proxy:
  ssl:
    certificate_pem: CERTIFICATE_PEM
    private_key_pem: PRIVATE_KEY_PEM
  host: example.com
```

In your `.kamal/secrets*` file, load the origin cert and key from disk:

```bash
CERTIFICATE_PEM=$(cat config/certificates/cert.pem)
PRIVATE_KEY_PEM=$(cat config/certificates/private.key)
```

### Deploying to a New Instance
Each deployment environment (e.g. a specific client or demo instance) uses its own config/deploy.[newserver].yml file.

#### To set up a new instance:
```bash
cp config/deploy.yml config/deploy.newserver.yml
cp .env.sample .env.newserver
```

#### Customize the new file with environment-specific values:
- Server IP or hostname
- Docker image tag
- Volumes, environment variables, secrets, etc.

#### Setup and deploy the new instance
```bash
dotenv -f .env.newserver kamal setup -d newserver
dotenv -f .env.newserver kamal deploy -d newserver
```

## Monitoring

This project uses [AppSignal](https://appsignal.com/) for error tracking and performance monitoring.

To enable AppSignal, set the following environment variables in your `.env` or environment-specific file:

- `APPSIGNAL_APP_NAME` (required): Your AppSignal project name
- `APPSIGNAL_ACTIVE` (optional): Set to 'true' to enable, 'false' to disable (default: true in production)
- `APPSIGNAL_APP_ENV` (optional): The environment name (e.g. production, staging)
- `APPSIGNAL_PUSH_API_KEY` (required): Your AppSignal project API key
- `APPSIGNAL_FRONTEND_API_KEY` (required): Your AppSignal frontend API key

For more details, see the [AppSignal documentation](https://docs.appsignal.com/).

## Future Roadmap

- Billing and invoicing
- Supplier price list importer
- Quick access to resources using mobile camera + QR codes
- Dashboard with production charts
- Role-based access for administrators, salespeople, and operators
- Public facing online store
