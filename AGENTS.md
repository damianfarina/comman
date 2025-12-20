# Repository Guidelines

## Project Structure & Module Organization
- `app/`: Rails MVC code, views, jobs, mailers, and `app/javascript/` Stimulus controllers.
- `app/assets/`: stylesheets (Tailwind + CSS) and images; `public/` for static error pages.
- `db/`: schema, migrations, seeds, and SQL helpers.
- `spec/`: RSpec specs and factories; `test/`: Rails/Minitest + system tests.
- `config/`: environment, routes, initializers, and deployment (`config/deploy*.yml`).
- `docs/`: product and brand assets.

## Build, Test, and Development Commands
- `bin/setup`: install gems, prepare DB, and run migrations.
- `bin/rails s` or `bin/dev`: run the local server.
- `bin/rspec`: run RSpec suites under `spec/`.
- `bin/rails test` and `bin/rails test:system`: run Minitest and system tests.
- `bin/ci`: full CI flow (setup, RuboCop, security scans, tests, seeds).
- `bin/rubocop`: Ruby style linting.
- `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`: security scan.
- `bin/importmap audit`: JS dependency audit for importmap.

## Coding Style & Naming Conventions
- Ruby: follow RuboCop Omakase; 2-space indentation; double quotes.
- JavaScript/CSS: Prettier, 2 spaces, trailing commas where supported.
- File naming: Rails conventions (`*_controller.rb`, `*_spec.rb`, `test_*`).
- Factories live in `spec/factories/`; use explicit, domain-oriented names.

## Testing Guidelines
- RSpec is the primary test framework (`spec/`); name specs `*_spec.rb`.
- Minitest is used for Rails and system tests (`test/`), run via `bin/rails test`.
- Keep new features covered in both request/model specs and relevant system flows when UI is affected.

## Commit & Pull Request Guidelines
- Commit messages are short, imperative summaries (e.g., “Fix ambiguity when joining tables”).
- Dependency bumps typically use “Bump <gem> from <old> to <new>”.
- PRs should describe the change, link related issues, and include screenshots for UI changes.

## Configuration & Secrets
- Copy `.env.sample` to `.env` and adjust as needed; use environment-specific variants.
- Production deploys use `dotenv -f .env.<env> kamal deploy -d <env>`.
