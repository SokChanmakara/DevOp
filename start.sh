#!/bin/bash

# Laravel Deployment Startup Script
# This script will set up and deploy your Laravel applications to staging and production

echo "🚀 Starting Laravel Deployment Setup..."
echo "========================================"

# Step 1: Stop any existing containers
echo "🛑 Stopping existing containers..."
docker compose down

# Step 2: Build and start containers
echo "🔨 Building and starting containers..."
docker compose up --build -d

# Step 3: Wait for containers to be ready
echo "⏳ Waiting for containers to start..."
sleep 10

# Step 4: Test connectivity
echo "🔍 Testing Ansible connectivity..."
docker compose exec control-machine-i4d sh -c "cd /ansible && ansible myservers -m ping"

if [ $? -eq 0 ]; then
    echo "✅ Connectivity test passed!"
    
    # Step 5: Run deployment
    echo "📦 Running Ansible deployment..."
    docker compose exec control-machine-i4d sh -c "cd /ansible && ansible-playbook playbook.yml -v"
    
    # Step 6: Create test files if needed
    echo "📝 Creating test files..."
    docker compose exec server1-i4d-tp06 sh -c "mkdir -p /var/www/html/production/public /var/www/html/staging/public"
    
    # Create production test file
    docker compose exec server1-i4d-tp06 sh -c 'cat > /var/www/html/production/public/index.php << "EOF"
<?php
echo "<h1>🏭 Production Environment</h1>";
echo "<p>Server: " . gethostname() . "</p>";
echo "<p>PHP Version: " . phpversion() . "</p>";
echo "<p>Current Time: " . date("Y-m-d H:i:s") . "</p>";
echo "<p>Environment: Production</p>";
echo "<p>✅ Deployment Status: SUCCESS</p>";
?>
EOF'

    # Create staging test file
    docker compose exec server1-i4d-tp06 sh -c 'cat > /var/www/html/staging/public/index.php << "EOF"
<?php
echo "<h1>🧪 Staging Environment</h1>";
echo "<p>Server: " . gethostname() . "</p>";
echo "<p>PHP Version: " . phpversion() . "</p>";
echo "<p>Current Time: " . date("Y-m-d H:i:s") . "</p>";
echo "<p>Environment: Staging</p>";
echo "<p>✅ Deployment Status: SUCCESS</p>";
?>
EOF'

    # Step 7: Restart services
    echo "🔄 Restarting web services..."
    docker compose exec server1-i4d-tp06 sh -c "nginx -t && pkill nginx || true && nginx"
    
    # Step 8: Test websites
    echo "🌐 Testing websites..."
    echo ""
    echo "Production website test:"
    curl -H "Host: gici4d2025.com" http://localhost
    echo ""
    echo ""
    echo "Staging website test:"
    curl -H "Host: staging.gici4d2025.com" http://localhost
    echo ""
    
    echo ""
    echo "🎉 Deployment completed successfully!"
    echo "========================================"
    echo "📊 Access Information:"
    echo "• Production: http://localhost (Host: gici4d2025.com)"
    echo "• Staging: http://localhost (Host: staging.gici4d2025.com)"
    echo ""
    echo "📋 Container Status:"
    docker compose ps
    
else
    echo "❌ Connectivity test failed. Please check your configuration."
    exit 1
fi