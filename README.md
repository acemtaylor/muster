# Muster

A self-hostable, open-source organizing CRM combining contact/CRM depth with a
multi-org dashboard structure — built for political parties, campaigns, and
advocacy organizations that want full control of their supporter data.

## Features

- **Multi-tenant org hierarchy** — arbitrary-depth nested organizations
  (national → state → electorate → branch) using PostgreSQL `ltree`, with
  scoped team member permissions that cascade down the tree
- **People / contacts** — full CRM records with custom properties (typed EAV),
  assessment status tracking, geolocation, and full-text search
- **CSV import** — bulk-import contacts with per-row error reporting
- **Filter / query-builder engine** — a JSON-based filter format that compiles
  to ActiveRecord queries, supporting nested AND/OR groups, custom property
  filters, PostGIS radius search, and org-descendant queries
- **Saved lists** — dynamic (live query) or frozen-snapshot contact lists
  built on the filter engine
- **Events & shifts** — single- or multi-day events with bookable shifts,
  capacity limits, RSVPs, and signups
- **Donations & membership dues** — one-off donations plus a full membership
  lifecycle (signup, renewal, lapsing, cancellation)
- **Turfs & canvassing** — PostGIS polygon turf-cutting with canvass attempt
  logging and knock-result tracking
- **Automations** — trigger-based step sequences (update a property, tag a
  contact, with email/SMS steps stubbed pending integration)
- **Pages & forms** — a block-based public page builder with form submission
  capture and duplicate-contact detection

## Tech stack

- **Ruby on Rails 8.1** with Hotwire (Turbo + Stimulus) and Tailwind CSS
- **PostgreSQL 16** with PostGIS, `ltree`, `citext`, and `pg_trgm` extensions
- **Sidekiq** + Redis for background jobs
- **MinIO** (S3-compatible) for file storage
- **Devise** for authentication

Every third-party integration in the broader roadmap (voice, SMS, email,
maps, video, analytics) has an open-source or self-hostable option, so the
whole stack can run without proprietary SaaS dependencies. See the
architecture notes below for the planned integration map.

## Getting started

### Prerequisites

- Ruby 3.3+ (managed via [mise](https://mise.jdx.dev) or similar)
- Docker + Docker Compose
- PostgreSQL client tools (`postgresql-client`)

### Setup

1. Clone the repo and install dependencies:

```bash
   git clone https://github.com/acemtaylor/muster.git
   cd muster
   bundle install
```

2. Start the backing services:

```bash
   docker compose up -d
```

3. Create the database and run migrations:

```bash
   bin/rails db:create db:migrate
```

4. Start the app:

```bash
   bin/dev
```

5. Visit `http://localhost:3000` and sign in (create a team member via
   `bin/rails console` if you don't have one yet — see below).

### Creating your first team member

```ruby
org = Organization.create!(name: "Your Org", slug: "your-org", kind: "organization")

TeamMember.create!(
  email: "you@example.org",
  password: "changeme123",
  organization: org,
  role: "admin",
  scope_org_ids: [org.id]
)
```

## Project status

This project is under active development. The core data model — orgs,
people, the filter engine, events, donations/memberships, canvassing,
automations, and forms — is built and tested. A basic dashboard UI covers
people and events management.

Not yet built:

- Email/SMS integration (Listmonk, Jambonz/Kannel)
- Voice/calling (Jambonz, Asterisk)
- Team chat + Kanban helpdesk board
- Reporting dashboards
- Public-facing page rendering for the page builder

## License

TBD
