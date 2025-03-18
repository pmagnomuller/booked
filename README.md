# Booked

A simple Airbnb clone built with Ruby on Rails 8.0.1, PostgreSQL, and Tailwind CSS.

## Features

- User authentication (signup, login, logout)
- Property listings
- Property search by location and price
- Booking system
- Review system
- Image uploads for properties and user avatars

## Requirements

- Ruby 3.2.2
- PostgreSQL
- Node.js and Yarn (for Tailwind CSS)

## Setup

1. Clone the repository:
   ```
   git clone https://github.com/your-username/booked.git
   cd booked
   ```

2. Install dependencies:
   ```
   bundle install
   ```

3. Create and setup the database:
   ```
   rails db:create db:migrate
   ```

4. Start the Rails server:
   ```
   bin/dev
   ```

5. Open your browser and navigate to:
   ```
   http://localhost:3000
   ```

## Testing

Run the test suite:
```
rails test
```

## Learning Ruby and Ruby on Rails

This project is a great way to learn Ruby and Ruby on Rails. Here are some useful resources:

- [Official Ruby Website](https://www.ruby-lang.org/)
- [Ruby Documentation](https://ruby-doc.org/)
- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [Ruby on Rails API](https://api.rubyonrails.org/)
- [The Odin Project](https://www.theodinproject.com/) - Free web development curriculum that includes Ruby and Rails

## Database Schema

- **Users**: Store user information and credentials
- **Properties**: Store information about properties available for booking
- **Bookings**: Store booking information
- **Reviews**: Store reviews for properties

## License

This project is open source and available under the [MIT License](LICENSE).
