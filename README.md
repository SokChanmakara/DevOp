# Laravel Deployment with Ansible

This Ansible project sets up 2 Laravel websites (staging and production) on a remote server.

## Prerequisites

1. Ansible installed on your local machine
2. SSH access to the remote server
3. Target server should be Ubuntu/Debian based

## Configuration

### 1. Update Inventory
Edit `inventory.ini` to match your server details:
```ini
[myservers]
your-server ansible_host=your-server-ip ansible_user=root ansible_ssh_pass=your-password ansible_port=22
```

### 2. Update Git Repository
In `playbook.yml`, update the `git_repo` variable to point to your actual Laravel repository:
```yaml
git_repo: "https://github.com/your-username/your-laravel-repo.git"
```

### 3. Update Email Configuration
In `playbook.yml`, update the email address in the "Send email with deployment results" task:
```yaml
to: your-email@domain.com
```

## What the Playbook Does

### Environment Checkup:
- ✅ Checks if Apache2 is running (installs if missing)
- ✅ Configures Apache2 virtual hosts for both websites
- ✅ Sets up proper directory structure

### Website 1 (Staging):
- ✅ Creates `/var/www/html/staging` directory
- ✅ Clones/updates from Git repository
- ✅ Copies `.env.example` to `.env`
- ✅ Configures `.env` with:
  - DB_HOST: localhost
  - DB_DATABASE: staging_db
  - APP_ENV: staging
- ✅ Runs `composer install`
- ✅ Runs `npm install` and `npm run build`
- ✅ Sets proper permissions

### Website 2 (Production):
- ✅ Creates `/var/www/html/production` directory
- ✅ Clones/updates from Git repository
- ✅ Copies `.env.example` to `.env`
- ✅ Configures `.env` with:
  - DB_HOST: localhost
  - DB_DATABASE: prod_db
  - APP_ENV: production
- ✅ Runs `composer install --optimize-autoloader --no-dev`
- ✅ Runs `npm install` and `npm run build`
- ✅ Sets proper permissions

### Results:
- ✅ Sends email with deployment results
- ✅ Displays deployment summary

## Usage

### Option 1: Use the deployment script
```bash
cd ansible
./deploy.sh
```

### Option 2: Run manually
```bash
cd ansible

# Test connection
ansible myservers -m ping

# Run the playbook
ansible-playbook playbook.yml -v
```

## Virtual Host Configuration

The playbook creates two Apache virtual hosts:

1. **Staging**: `staging.gici4d2025.com` → `/var/www/html/staging/public`
2. **Production**: `gici4d2025.com` → `/var/www/html/production/public`

## Notes

- The playbook uses `www-data` as the Apache user (standard for Ubuntu/Debian)
- All tasks run with proper user permissions
- Laravel storage and cache directories get proper permissions (775)
- Production environment uses optimized composer install
- Both sites will have proper Laravel .env configuration

## Troubleshooting

1. **Connection issues**: Check your inventory.ini file and SSH credentials
2. **Permission errors**: Ensure the ansible user has sudo privileges
3. **Git issues**: Make sure the repository URL is accessible from the remote server
4. **Email issues**: Configure proper SMTP settings on the remote server for email functionality