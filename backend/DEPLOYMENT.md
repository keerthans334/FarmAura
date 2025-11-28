# FarmAura Auto Detect - Deployment Guide

## 🚀 Deployment Options

Choose the deployment option that best fits your needs:

---

## Option 1: Local Development Server (Quickest)

**Best for**: Testing, development, local demos  
**Cost**: Free  
**Setup time**: 5 minutes

### Steps:
```bash
# 1. Install dependencies
cd backend
pip3 install -r requirements.txt

# 2. Start server
python3 app.py
```

### Access:
- From same machine: `http://localhost:5000`
- From Flutter app on same network: `http://YOUR_LOCAL_IP:5000`

### Find your local IP:
```bash
# macOS/Linux
ifconfig | grep "inet " | grep -v 127.0.0.1

# Output example: inet 192.168.1.100
# Use: http://192.168.1.100:5000
```

### Pros:
- ✅ Instant setup
- ✅ Free
- ✅ Easy debugging

### Cons:
- ❌ Only works on local network
- ❌ Server must stay running
- ❌ Not suitable for production

---

## Option 2: Google Cloud Run (Recommended for Production)

**Best for**: Production deployment, auto-scaling  
**Cost**: Free tier available, then pay-per-use  
**Setup time**: 30 minutes

### Prerequisites:
- Google Cloud account
- gcloud CLI installed

### Steps:

#### 1. Create Dockerfile
Already created! See below.

#### 2. Build and deploy
```bash
# Install gcloud CLI if needed
# https://cloud.google.com/sdk/docs/install

# Login
gcloud auth login

# Set project
gcloud config set project YOUR_PROJECT_ID

# Build and deploy
cd backend
gcloud run deploy farmaura-backend \
  --source . \
  --platform managed \
  --region asia-south1 \
  --allow-unauthenticated \
  --memory 4Gi \
  --timeout 300
```

#### 3. Get URL
After deployment, you'll get a URL like:
```
https://farmaura-backend-xxxxx-as.a.run.app
```

Use this in your Flutter app!

### Pros:
- ✅ Auto-scaling
- ✅ HTTPS by default
- ✅ Pay only for what you use
- ✅ Free tier available
- ✅ Easy updates

### Cons:
- ❌ Cold start delay (~10-15 seconds)
- ❌ Requires Google Cloud account

### Cost Estimate:
- Free tier: 2 million requests/month
- After that: ~$0.40 per million requests
- Typical usage: $5-20/month for small app

---

## Option 3: AWS EC2 (Full Control)

**Best for**: Custom requirements, full control  
**Cost**: ~$10-30/month  
**Setup time**: 1-2 hours

### Steps:

#### 1. Launch EC2 instance
- Instance type: t3.medium (4 GB RAM minimum)
- OS: Ubuntu 22.04 LTS
- Security group: Allow port 5000 (or 80/443)

#### 2. SSH into instance
```bash
ssh -i your-key.pem ubuntu@YOUR_EC2_IP
```

#### 3. Install dependencies
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Python 3.10+
sudo apt install python3 python3-pip -y

# Install git
sudo apt install git -y

# Clone your repo (or upload files)
git clone https://github.com/YOUR_USERNAME/FarmAura_application.git
cd FarmAura_application/backend

# Install Python packages
pip3 install -r requirements.txt
```

#### 4. Run with Gunicorn
```bash
# Install Gunicorn
pip3 install gunicorn

# Run server
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

#### 5. (Optional) Setup systemd service
Create `/etc/systemd/system/farmaura.service`:
```ini
[Unit]
Description=FarmAura Backend
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/FarmAura_application/backend
ExecStart=/usr/local/bin/gunicorn -w 4 -b 0.0.0.0:5000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl enable farmaura
sudo systemctl start farmaura
```

#### 6. (Optional) Setup Nginx reverse proxy
```bash
sudo apt install nginx -y

# Create config
sudo nano /etc/nginx/sites-available/farmaura
```

Add:
```nginx
server {
    listen 80;
    server_name YOUR_DOMAIN_OR_IP;

    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Enable:
```bash
sudo ln -s /etc/nginx/sites-available/farmaura /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### Access:
- `http://YOUR_EC2_IP:5000` (direct)
- `http://YOUR_EC2_IP` (with Nginx)

### Pros:
- ✅ Full control
- ✅ Predictable pricing
- ✅ No cold starts
- ✅ Can customize everything

### Cons:
- ❌ Manual scaling
- ❌ Need to manage server
- ❌ Need to setup SSL manually

---

## Option 4: Heroku (Easiest Cloud)

**Best for**: Quick cloud deployment, minimal config  
**Cost**: $7/month (Eco Dynos)  
**Setup time**: 15 minutes

### Steps:

#### 1. Install Heroku CLI
```bash
# macOS
brew tap heroku/brew && brew install heroku

# Or download from https://devcenter.heroku.com/articles/heroku-cli
```

#### 2. Create Procfile
Already created! See below.

#### 3. Deploy
```bash
# Login
heroku login

# Create app
cd backend
heroku create farmaura-backend

# Add buildpack
heroku buildpacks:set heroku/python

# Deploy
git init
git add .
git commit -m "Initial commit"
git push heroku main

# Scale up
heroku ps:scale web=1

# Get URL
heroku open
```

### Access:
- `https://farmaura-backend.herokuapp.com`

### Pros:
- ✅ Very easy setup
- ✅ Automatic SSL
- ✅ Git-based deployment
- ✅ Good documentation

### Cons:
- ❌ More expensive than Cloud Run
- ❌ Slower than EC2
- ❌ Limited free tier

---

## Required Files for Deployment

### Dockerfile (for Cloud Run / Docker)
```dockerfile
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy requirements first (for caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Copy models directory from parent
COPY ../models ./models

# Expose port
EXPOSE 5000

# Run application
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "--timeout", "300", "app:app"]
```

### Procfile (for Heroku)
```
web: gunicorn -w 4 -b 0.0.0.0:$PORT --timeout 300 app:app
```

### .dockerignore
```
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
env/
venv/
.env
.git/
.gitignore
*.md
test_*.py
```

---

## Environment Variables Setup

For all deployment options, set these environment variables:

### Cloud Run:
```bash
gcloud run services update farmaura-backend \
  --set-env-vars GEMINI_API_KEY=your_key_here \
  --set-env-vars GEMINI_MODEL=gemini-2.0-flash-exp
```

### Heroku:
```bash
heroku config:set GEMINI_API_KEY=your_key_here
heroku config:set GEMINI_MODEL=gemini-2.0-flash-exp
```

### EC2:
Create `.env` file in the backend directory:
```bash
echo "GEMINI_API_KEY=your_key_here" > .env
echo "GEMINI_MODEL=gemini-2.0-flash-exp" >> .env
```

---

## Post-Deployment Checklist

After deploying, verify everything works:

### 1. Health Check
```bash
curl https://YOUR_DEPLOYMENT_URL/api/health
```

Expected response:
```json
{
  "status": "healthy",
  "model_loaded": true,
  "data_loaded": true
}
```

### 2. Test Auto Detect
```bash
curl -X POST https://YOUR_DEPLOYMENT_URL/api/auto-detect-crop \
  -H "Content-Type: application/json" \
  -d '{
    "state": "Jharkhand",
    "district": "Dhanbad",
    "frequent_grown_crop": "rice",
    "land_size": 2.5
  }'
```

### 3. Update Flutter App
In `CropRecommendationService`:
```dart
static const String baseUrl = 'https://YOUR_DEPLOYMENT_URL';
```

### 4. Test from Flutter
- Build and run Flutter app
- Tap "Auto Detect"
- Verify recommendations appear

---

## Monitoring & Maintenance

### Logs

#### Cloud Run:
```bash
gcloud run services logs read farmaura-backend --limit 50
```

#### Heroku:
```bash
heroku logs --tail
```

#### EC2:
```bash
# If using systemd
sudo journalctl -u farmaura -f

# If running manually
tail -f /path/to/log/file
```

### Performance Monitoring

Add basic monitoring:
```python
# In app.py, add before each endpoint
import time

@app.before_request
def before_request():
    request.start_time = time.time()

@app.after_request
def after_request(response):
    if hasattr(request, 'start_time'):
        elapsed = time.time() - request.start_time
        logger.info(f"{request.method} {request.path} - {response.status_code} - {elapsed:.2f}s")
    return response
```

### Alerts

Set up alerts for:
- High error rates (>5%)
- Slow responses (>10 seconds)
- High memory usage (>80%)
- API quota exceeded (Gemini)

---

## Scaling Considerations

### When to Scale Up:

#### Vertical Scaling (More RAM/CPU)
- If requests are timing out
- If memory usage is >80%
- If CPU usage is >70%

#### Horizontal Scaling (More Instances)
- If response time is >5 seconds consistently
- If you have >100 concurrent users

### Optimization Tips:

1. **Use Database**: Move CSVs to PostgreSQL for faster queries
2. **Add Caching**: Cache common location+crop combinations with Redis
3. **Optimize Data Loading**: Load only required columns, use Parquet instead of CSV
4. **Batch Requests**: Allow multiple crops to be recommended in one request
5. **CDN**: Serve static content via CDN

---

## Security Best Practices

### 1. Environment Variables
- ✅ Never commit `.env` to git
- ✅ Use secrets management (Cloud Secret Manager, AWS Secrets Manager)
- ✅ Rotate API keys regularly

### 2. API Security
- ✅ Add rate limiting (Flask-Limiter)
- ✅ Add authentication (API keys, JWT)
- ✅ Enable CORS only for your Flutter app domain
- ✅ Use HTTPS (SSL/TLS)

### 3. Input Validation
- ✅ Validate all user inputs
- ✅ Sanitize strings to prevent injection
- ✅ Set max request size limits

### Example Rate Limiting:
```python
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(
    app=app,
    key_func=get_remote_address,
    default_limits=["100 per hour"]
)

@app.route('/api/auto-detect-crop', methods=['POST'])
@limiter.limit("10 per minute")
def auto_detect_crop():
    # ... existing code
```

---

## Cost Optimization

### Cloud Run:
- Set min instances to 0 (cold starts OK for MVP)
- Set max instances to 10 (prevent runaway costs)
- Use smaller memory if possible (2 GB instead of 4 GB)

### Heroku:
- Use Eco Dynos ($7/month) for MVP
- Upgrade to Basic ($25/month) when needed

### EC2:
- Use Reserved Instances (save 30-50%)
- Use Spot Instances for non-critical workloads (save 70-90%)
- Set up auto-shutdown during off-hours

---

## Troubleshooting Deployment Issues

### Issue: "Out of memory"
**Solution**: Increase memory allocation or optimize data loading

### Issue: "Cold start too slow"
**Solution**: 
- Use Cloud Run min instances = 1
- Or use EC2/Heroku (no cold starts)

### Issue: "Gemini API quota exceeded"
**Solution**: 
- Upgrade Gemini API plan
- Add caching for explanations
- Implement fallback to template-based explanations

### Issue: "Model file not found"
**Solution**: 
- Ensure models/ directory is copied in Dockerfile
- Check file paths are absolute, not relative

---

## Recommended Setup for Production

**For MVP (0-1000 users)**:
- Platform: Google Cloud Run
- Memory: 4 GB
- Instances: 0-3 (auto-scale)
- Cost: ~$10-20/month

**For Growth (1000-10000 users)**:
- Platform: Google Cloud Run or AWS EC2
- Memory: 4-8 GB
- Instances: 1-10 (auto-scale)
- Database: PostgreSQL (instead of CSV)
- Cache: Redis
- Cost: ~$50-100/month

**For Scale (10000+ users)**:
- Platform: Kubernetes (GKE/EKS)
- Load balancer: Yes
- Database: PostgreSQL with read replicas
- Cache: Redis cluster
- CDN: CloudFlare
- Cost: $200-500/month

---

## Next Steps After Deployment

1. ✅ Deploy backend to chosen platform
2. ✅ Update Flutter app with deployment URL
3. ✅ Test end-to-end from Flutter
4. ✅ Set up monitoring and alerts
5. ✅ Add rate limiting and security
6. ✅ Optimize based on usage patterns
7. ✅ Collect user feedback
8. ✅ Iterate and improve!

---

**Need help?** Check the main README.md or contact the development team.

**Happy deploying!** 🚀
