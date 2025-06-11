# Laravel Deployment with Ansible

This project sets up 2 Laravel websites (staging and production) using Ansible automation in Docker containers.

## 🚀 Quick Start (Next Time)

**Just run this one command:**

```bash
cd /mnt/mint-extra/DevOp/TP6
./start.sh
```

That's it! The script will automatically:

- Stop any existing containers
- Build and start new containers
- Run Ansible deployment
- Set up both staging and production environments
- Test everything for you

## 🌐 How to Access in Browser

### Method 1: Modify Hosts File (Recommended)

**On Linux:**

```bash
sudo nano /etc/hosts
```

**Add these lines:**

```
127.0.0.1   gici4d2025.com
127.0.0.1   staging.gici4d2025.com
```

**Save and exit, then access:**

- Production: http://gici4d2025.com
- Staging: http://staging.gici4d2025.com

### Method 2: Browser Developer Tools

1. Open http://localhost in your browser
2. Open Developer Tools (F12)
3. Go to Network tab
4. Refresh the page
5. Right-click on the request → "Edit and Resend"
6. Add header: `Host: gici4d2025.com` (for production) or `Host: staging.gici4d2025.com` (for staging)

### Method 3: Browser Extensions

Install a "Host Header" extension for Chrome/Firefox to easily switch between environments.

### Method 4: Command Line Testing

```bash
# Test production
curl -H "Host: gici4d2025.com" http://localhost

# Test staging
curl -H "Host: staging.gici4d2025.com" http://localhost
```

## 📁 Manual Steps (If Needed)

If you prefer to run manually instead of using `./start.sh`:

### 1. Start Containers

```bash
docker compose down
docker compose up --build -d
```

### 2. Test Ansible Connection

```bash
docker compose exec control-machine-i4d sh -c "cd /ansible && ansible myservers -m ping"
```

### 3. Run Deployment

```bash
docker compose exec control-machine-i4d sh -c "cd /ansible && ansible-playbook playbook.yml -v"
```

### 4. Access Websites

Follow the browser access methods above.

## 🐛 Troubleshooting

### If websites show "File not found":

```bash
# Restart nginx
docker compose exec server1-i4d-tp06 sh -c "nginx -t && pkill nginx || true && nginx"
```

### If containers won't start:

```bash
# Clean up and rebuild
docker compose down --volumes
docker system prune -f
docker compose up --build -d
```

### Check container status:

```bash
docker compose ps
docker compose logs server1-i4d-tp06
```

## 🏗️ What This Setup Includes

✅ **Infrastructure:**

- Ansible control machine (Alpine Linux)
- Target server with PHP 8.3 + Nginx
- SSH connectivity between containers

✅ **Applications:**

- Production Laravel site (`/var/www/html/production`)
- Staging Laravel site (`/var/www/html/staging`)
- Proper nginx virtual hosts
- Environment-specific configurations

✅ **Deployment:**

- Automated Git repository cloning
- Composer dependency installation
- Laravel environment configuration
- Proper file permissions

## 📊 Container Details

| Container                  | Purpose                      | Ports        |
| -------------------------- | ---------------------------- | ------------ |
| `control-machine-i4d-tp06` | Ansible controller           | -            |
| `server1-i4d-tp06`         | Web server (Nginx + PHP-FPM) | 80:80, 22:22 |

## 🔧 Configuration Files

- `docker-compose.yml` - Container orchestration
- `ansible/playbook.yml` - Deployment automation
- `ansible/inventory.ini` - Server inventory
- `laravel-image/` - Web server Docker image
- `start.sh` - One-command startup script

## 💡 Development Workflow

1. **Make changes** to your Laravel code
2. **Run deployment**: `./start.sh` or manual Ansible commands
3. **Test both environments** using different hostnames
4. **Deploy to real servers** by updating `inventory.ini` with actual server IPs

---

**Pro Tip:** Bookmark both `http://gici4d2025.com` and `http://staging.gici4d2025.com` after adding them to your hosts file for easy access!
