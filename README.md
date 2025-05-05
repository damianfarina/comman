# Comman

**Comman** (short for "Company Manager") is a web application designed to streamline manufacturing, inventory, and sales operations for companies that produce and sell industrial products such as grinding stones, cutting discs, and hardware supplies.

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

#### Run the server
```bash
bin/rails s
```
#### Run tests
```bash
bin/rspec
```

#### Set environment variables
```bash
cp .env.sample .env
```
Adjust the variables in .env to fit your needs.

#### Deploy to production
```bash
dotenv kamal deploy
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

## Future Roadmap

- Client request → Order flow:
  - Create orders from client requests
  - Automatically calculate stock availability
  - Trigger Making Orders for missing stock
- Billing and invoicing
- Supplier price list importer
- Quick access to resources using mobile camera + QR codes
- Dashboard with production charts
- Role-based access for administrators, salespeople, and operators
