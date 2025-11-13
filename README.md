# ZornFC

## About
ZornFC is a full-stack e-commerce website for a mock soccer team called ZornFC

## Features
This website features user authentication, an admin dashboard for CRUD operations (uploading and deleting products), and moderating product comments. Additionally, it includes product discovery with a search bar and a category filter (e.g., Jackets, Pants). Sorting by name or type (e.g., on sale, new). It also includes a shopping cart function  with checkout that collects customer details and processes payments via Stripe.

## Tech Stack
* Ruby-On-Rails (7.2.1)
* SQlite3 (1.4)
* BootStrap

## Setup
```bash
# Navigate to project root
cd ZornFC-ecommerce
# Install dependencies
bundle install
# Create DB, load schema, and seed (creates dev admin)
bin/rails db:setup
# Start the server
bin/rails server
# Open in browser
http://localhost:3000
```


