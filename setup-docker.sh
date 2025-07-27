#!/bin/bash

# Laravel Docker Setup Script
echo "🐳 Setting up Laravel Docker Environment..."

# Check if .env exists
if [ ! -f .env ]; then
    echo "📄 Creating .env file from docker-env.example..."
    cp docker-env.example .env
else
    echo "📄 .env file already exists."
fi

# Generate application key if not set
if ! grep -q "APP_KEY=base64:" .env; then
    echo "🔐 Generating Laravel application key..."
    # We'll generate this after the container is running
    GENERATE_KEY=true
else
    echo "🔐 Application key already set."
    GENERATE_KEY=false
fi

# Build and start containers
echo "🏗️  Building and starting Docker containers..."
docker compose down
docker compose up -d --build

# Wait for containers to be ready
echo "⏳ Waiting for containers to be ready..."
sleep 30

# Generate application key if needed
if [ "$GENERATE_KEY" = true ]; then
    echo "🔐 Generating application key..."
    docker compose exec app php artisan key:generate
fi

# Install dependencies
echo "📦 Installing Composer dependencies..."
docker compose exec app composer install --no-dev --optimize-autoloader

# Run migrations
echo "🗄️  Running database migrations..."
docker compose exec app php artisan migrate --force

# Clear and cache config
echo "🧹 Clearing and caching configuration..."
docker compose exec app php artisan config:clear
docker compose exec app php artisan cache:clear
docker compose exec app php artisan config:cache

# Set permissions
echo "🔒 Setting proper permissions..."
docker compose exec app chown -R www-data:www-data /var/www/html/storage
docker compose exec app chmod -R 755 /var/www/html/storage

echo "✅ Setup complete!"
echo ""
echo "🌐 Your Laravel application is now running at:"
echo "   - Laravel App: http://localhost:8082"
echo "   - phpMyAdmin:  http://localhost:8081"
echo ""
echo "🗄️  Database credentials:"
echo "   - Host: localhost:3307"
echo "   - Database: laravel"
echo "   - Username: laravel_user"
echo "   - Password: laravel_password"
echo ""
echo "📊 To view logs: docker compose logs -f"
echo "🛑 To stop: docker compose down" 