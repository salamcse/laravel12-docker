# Laravel Docker Setup

This setup provides a complete Docker environment for your Laravel application with phpMyAdmin for database management.

## Services Included

- **Laravel Application**: PHP 8.2 with Nginx
- **MySQL 8.0**: Database server
- **phpMyAdmin**: Web-based MySQL administration tool
- **Redis**: Caching and session storage

## Quick Start

### 1. Setup Environment

Copy the Docker environment file to `.env`:
```bash
cp docker-env.example .env
```

### 2. Generate Application Key

Generate a new Laravel application key:
```bash
php artisan key:generate
```

Or add it manually to your `.env` file.

### 3. Build and Start Services

```bash
# Build and start all services
docker compose up -d --build

# View logs
docker compose logs -f

# Stop services
docker compose down
```

### 4. Install Dependencies

If you need to install PHP dependencies:
```bash
docker compose exec app composer install
```

If you need to install Node dependencies:
```bash
docker compose exec app npm install
docker compose exec app npm run build
```

### 5. Run Migrations

```bash
docker compose exec app php artisan migrate
```

## Access Points

- **Laravel Application**: http://localhost:8082
- **phpMyAdmin**: http://localhost:8081
- **MySQL Database**: localhost:3307

## Database Credentials

- **Database**: laravel
- **Username**: laravel_user
- **Password**: laravel_password
- **Root Password**: root_password

## Useful Commands

```bash
# Access the Laravel container
docker compose exec app bash

# Run Artisan commands
docker compose exec app php artisan [command]

# View container logs
docker compose logs [service_name]

# Restart a specific service
docker compose restart [service_name]

# Rebuild containers
docker compose up -d --build
```

## File Structure

```
├── docker/
│   ├── nginx/
│   │   └── default.conf          # Nginx configuration
│   ├── supervisor/
│   │   └── supervisord.conf       # Process management
│   ├── php/
│   │   └── local.ini             # PHP configuration
│   └── mysql/
│       └── my.cnf                # MySQL configuration
├── docker-compose.yml            # Docker services definition
├── Dockerfile                    # Laravel application container
└── .dockerignore                 # Docker build ignore file
```

## Troubleshooting

### Port Conflicts
If you encounter port conflicts, modify the ports in `docker-compose.yml`:
- Laravel: Change `8082:80` to `[your_port]:80`
- phpMyAdmin: Change `8081:80` to `[your_port]:80`
- MySQL: Change `3307:3306` to `[your_port]:3306`

### Permission Issues
```bash
# Fix storage permissions
docker compose exec app chown -R www-data:www-data /var/www/html/storage
docker compose exec app chmod -R 755 /var/www/html/storage
```

### Clear Laravel Cache
```bash
docker compose exec app php artisan config:clear
docker compose exec app php artisan cache:clear
docker compose exec app php artisan route:clear
docker compose exec app php artisan view:clear
``` 