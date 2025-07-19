# Azure Container Instance Deployment Script for Twenty CRM
# Run these commands using the Azure MCP

# 1. Create Resource Group
az group create --name twenty-crm-rg --location eastus

# 2. Create Azure Container Registry (Optional - for custom images)
az acr create --resource-group twenty-crm-rg --name twentycrmregistry --sku Basic --admin-enabled true

# 3. Create Azure Database for PostgreSQL
az postgres flexible-server create \
  --resource-group twenty-crm-rg \
  --name twenty-crm-db \
  --location eastus \
  --admin-user twentyadmin \
  --admin-password 'SecurePassword123!' \
  --sku-name Standard_B1ms \
  --tier Burstable \
  --storage-size 32 \
  --version 16

# 4. Create Redis Cache
az redis create \
  --resource-group twenty-crm-rg \
  --name twenty-crm-redis \
  --location eastus \
  --sku Basic \
  --vm-size c0

# 5. Deploy Twenty CRM Container
az container create \
  --resource-group twenty-crm-rg \
  --name twenty-crm-app \
  --image twentycrm/twenty:latest \
  --dns-name-label twenty-crm-unique \
  --ports 3000 \
  --cpu 2 \
  --memory 4 \
  --environment-variables \
    NODE_PORT=3000 \
    SERVER_URL=http://twenty-crm-unique.eastus.azurecontainer.io:3000 \
    PG_DATABASE_URL="postgres://twentyadmin:SecurePassword123!@twenty-crm-db.postgres.database.azure.com:5432/postgres?sslmode=require" \
    REDIS_URL="redis://twenty-crm-redis.redis.cache.windows.net:6380?ssl=true" \
    APP_SECRET="your_generated_secret_here" \
    ACCESS_TOKEN_SECRET="your_access_token_secret" \
    LOGIN_TOKEN_SECRET="your_login_token_secret" \
    REFRESH_TOKEN_SECRET="your_refresh_token_secret"

# 6. Get the public IP and URL
az container show --resource-group twenty-crm-rg --name twenty-crm-app --query ipAddress

# 7. Configure firewall rules for database
az postgres flexible-server firewall-rule create \
  --resource-group twenty-crm-rg \
  --name twenty-crm-db \
  --rule-name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0