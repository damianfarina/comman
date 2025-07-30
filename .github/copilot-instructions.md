# GitHub Copilot Instructions

This file provides guidelines and best practices for using GitHub Copilot in this repository.

## Ruby
- Follow Rubocop conventions for Ruby code
- Use Rails conventions and best practices
- Follow the existing codebase patterns for consistency

## Database Schema
- Refer to `db/schema.rb` for the current database structure
- Use proper Rails migrations for schema changes
- Follow ActiveRecord conventions for model associations and validations

## Testing
- Write short, focused RSpec tests for new features
- Follow the existing test patterns in `spec/` directory
- Use FactoryBot for test data generation
- Include both unit and integration tests

## Models
- Use proper ActiveRecord validations and associations
- Include audit trails where appropriate using the `Auditable` concern
- Follow the established naming conventions (e.g., `Sales::Order::Item` for sales order items)

## Controllers
- Follow Rails RESTful conventions
- Use proper HTTP status codes
- Handle errors appropriately with user-friendly messages
- Include authentication and authorization checks

## Views
- Use Rails view helpers and partials for reusability
- Follow the established UI patterns and styling
- Ensure accessibility and responsive design

## Code Style
- Use descriptive variable and method names
- Keep methods focused and single-purpose
- Use appropriate Ruby idioms and patterns
