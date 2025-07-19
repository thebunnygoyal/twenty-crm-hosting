# Twenty CRM Hosting Setup

This repository contains everything needed to host Twenty CRM using Azure services with automated deployment via GitHub Actions.

## 🚀 Quick Start Options

### Option 1: Azure Container Instances (Recommended)
- ✅ Fully managed containers
- ✅ Pay-per-use pricing
- ✅ Easy scaling
- ✅ Built-in load balancing

### Option 2: Azure Virtual Machine
- ✅ Full control over environment
- ✅ Docker Compose support
- ✅ More cost-effective for continuous use

### Option 3: Local Docker Deployment
- ✅ Development and testing
- ✅ Full control
- ✅ No cloud costs

## 📋 Prerequisites

1. **Azure Account** with active subscription
2. **GitHub Account** for repository and CI/CD
3. **Domain** (optional, via Namecheap)
4. **Local Docker** (for local development)

## 🔧 Setup Instructions

### Step 1: Azure Resource Setup

Using Azure CLI (via Azure MCP):

```bash
# 1. Login to Azure
az login

# 2. Create resource group
az group create --name twenty-crm-rg --location eastus

# 3. Create PostgreSQL database
az postgres flexible-server create \
  --resource-group twenty-crm-rg \
  --name twenty-crm-db \
  --admin-user twentyadmin \
  --admin-password 'SecurePassword123!' \
  --sku-name Standard_B1ms

# 4. Create Redis cache
az redis create \
  --resource-group twenty-crm-rg \
  --name twenty-crm-redis \
  --sku Basic
```

### Step 2: GitHub Repository Setup

1. **Create repository** using GitHub MCP
2. **Push configuration files** to repository
3. **Set up GitHub secrets** for deployment

Required GitHub Secrets:
```
AZURE_CREDENTIALS={...}
SERVER_URL=http://your-domain.com
PG_DATABASE_URL=postgres://user:pass@host:port/db
REDIS_URL=redis://host:port
APP_SECRET=your_64_char_secret
ACCESS_TOKEN_SECRET=your_secret
LOGIN_TOKEN_SECRET=your_secret  
REFRESH_TOKEN_SECRET=your_secret
```

### Step 3: Security Configuration

Generate secure secrets:
```bash
# Generate random secrets (64 characters each)
openssl rand -base64 48
```

Update `.env` file with your generated secrets.

### Step 4: Domain Setup (Optional)

Using Namecheap DNS MCP:
1. **Point domain** to Azure Container Instance IP
2. **Set up SSL** via Azure Application Gateway
3. **Update SERVER_URL** in configuration

## 🚀 Deployment Methods

### Method 1: GitHub Actions (Automated)
1. Push changes to `main` branch
2. GitHub Actions automatically deploys to Azure
3. Check deployment URL in Actions logs

### Method 2: Azure CLI (Manual)
```bash
# Run the deployment script
bash azure-deploy.sh
```

### Method 3: Local Docker
```bash
# Generate secrets first
openssl rand -base64 32

# Update .env with your secrets
cp .env.example .env
nano .env

# Start services
docker-compose up -d

# Access at http://localhost:3000
```

## 📊 Cost Estimation

### Azure Container Instances
- **Container**: ~$30-50/month (2 vCPU, 4GB RAM)
- **PostgreSQL**: ~$25-40/month (Basic tier)
- **Redis**: ~$15-25/month (Basic tier)
- **Total**: ~$70-115/month

### Azure Virtual Machine
- **VM**: ~$35-70/month (B2s instance)
- **Storage**: ~$10-20/month
- **Database**: Same as above
- **Total**: ~$80-130/month

## 🔍 Monitoring & Management

### Health Checks
- **Application**: `http://your-url:3000/health`
- **Database**: Azure Portal monitoring
- **Redis**: Azure Portal monitoring

### Scaling
- **Horizontal**: Increase container instances
- **Vertical**: Increase CPU/memory allocation

### Backups
- **Database**: Automatic Azure backups
- **Files**: Azure Storage sync
- **Configuration**: Git repository

## 🛠️ Troubleshooting

### Common Issues

1. **Container startup failed**
   - Check environment variables
   - Verify database connectivity
   - Review container logs

2. **Database connection issues**
   - Verify firewall rules
   - Check connection string
   - Ensure SSL requirements

3. **Memory/CPU issues**
   - Increase container resources
   - Monitor usage in Azure Portal

### Useful Commands

```bash
# Check container status
az container show --resource-group twenty-crm-rg --name twenty-crm-app

# View container logs
az container logs --resource-group twenty-crm-rg --name twenty-crm-app

# Restart container
az container restart --resource-group twenty-crm-rg --name twenty-crm-app

# Scale resources
az container create --cpu 4 --memory 8  # Update deployment
```

## 🔐 Security Best Practices

1. **Secrets Management**
   - Use Azure Key Vault for production
   - Never commit secrets to repository
   - Rotate secrets regularly

2. **Network Security**
   - Configure proper firewall rules
   - Use private endpoints where possible
   - Enable SSL/TLS encryption

3. **Access Control**
   - Use Azure RBAC
   - Implement least privilege principle
   - Monitor access logs

## 📚 Additional Resources

- [Twenty CRM Documentation](https://twenty.com/developers)
- [Azure Container Instances Docs](https://docs.microsoft.com/azure/container-instances/)
- [GitHub Actions for Azure](https://github.com/Azure/actions)

## 🤝 Support

- **Twenty CRM**: [Discord Community](https://discord.gg/cx5n4Jzs57)
- **Azure Support**: Azure Portal support tickets
- **GitHub Issues**: Repository issue tracker
