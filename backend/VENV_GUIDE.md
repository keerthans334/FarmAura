# Virtual Environment Setup - Quick Reference

## ✅ Virtual Environment Created!

Your Python virtual environment is now set up and all dependencies are installed.

---

## 🚀 Quick Start

### Option 1: Use the Startup Script (Easiest)
```bash
cd backend
./start_server.sh
```

This script will:
- ✅ Activate the virtual environment automatically
- ✅ Check if dependencies are installed
- ✅ Start the Flask server

---

### Option 2: Manual Activation

#### Activate Virtual Environment
```bash
cd backend
source venv/bin/activate
```

You'll see `(venv)` in your terminal prompt when activated.

#### Start the Server
```bash
python app.py
```

#### Deactivate When Done
```bash
deactivate
```

---

## 📦 Installed Packages

All dependencies from `requirements.txt` are installed:

- ✅ **Flask 3.0.0** - Web framework
- ✅ **flask-cors 4.0.0** - CORS support
- ✅ **pandas 2.1.4** - Data processing
- ✅ **numpy 1.24.3** - Numerical computing
- ✅ **catboost 1.2.2** - ML model
- ✅ **scikit-learn 1.3.2** - ML utilities
- ✅ **google-generativeai 0.3.2** - Gemini API
- ✅ **python-dotenv 1.0.0** - Environment variables
- ✅ **requests 2.31.0** - HTTP library

---

## 🧪 Testing

### Run the Test Suite
```bash
# Make sure virtual environment is activated
source venv/bin/activate

# Run tests
python test_api.py
```

---

## 🔧 Common Commands

### Check Python Version
```bash
source venv/bin/activate
python --version
```

### List Installed Packages
```bash
source venv/bin/activate
pip list
```

### Update a Package
```bash
source venv/bin/activate
pip install --upgrade package-name
```

### Reinstall All Dependencies
```bash
source venv/bin/activate
pip install -r requirements.txt --force-reinstall
```

---

## 📁 Virtual Environment Structure

```
backend/
├── venv/                    # Virtual environment (gitignored)
│   ├── bin/                 # Executables (python, pip, etc.)
│   ├── lib/                 # Installed packages
│   └── ...
├── app.py                   # Your Flask app
├── requirements.txt         # Dependencies
├── start_server.sh          # Startup script
└── ...
```

---

## ⚠️ Important Notes

### 1. Always Activate Before Running
```bash
# ❌ Wrong (without activation)
python app.py

# ✅ Correct (with activation)
source venv/bin/activate
python app.py

# ✅ Or use the script
./start_server.sh
```

### 2. Virtual Environment is Gitignored
The `venv/` directory is excluded from git (added to `.gitignore`).

When cloning the repo on another machine, recreate it:
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 3. Deactivate When Done
```bash
deactivate
```

This returns you to your system Python.

---

## 🐛 Troubleshooting

### "command not found: python"
Use `python3` instead:
```bash
python3 app.py
```

### "No module named 'flask'"
Activate the virtual environment first:
```bash
source venv/bin/activate
```

### "Permission denied: ./start_server.sh"
Make it executable:
```bash
chmod +x start_server.sh
```

### Virtual Environment Not Working
Delete and recreate:
```bash
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

---

## 🎯 Next Steps

1. **Start the server**:
   ```bash
   ./start_server.sh
   ```

2. **Run tests** (in another terminal):
   ```bash
   cd backend
   source venv/bin/activate
   python test_api.py
   ```

3. **Integrate with Flutter**:
   - See `flutter_integration_example.dart`

4. **Deploy to production**:
   - See `DEPLOYMENT.md`

---

## 📚 Additional Resources

- **Main Documentation**: `README.md`
- **Quick Start**: `QUICKSTART.md`
- **Deployment**: `DEPLOYMENT.md`
- **Architecture**: `architecture_diagram.py`

---

**Your virtual environment is ready to use!** 🎉

Just run `./start_server.sh` to get started!
