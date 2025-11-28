# ⚠️ IMPORTANT: Data File Conversion Required

## Issue Detected

The file `models/expanded_synthetic_crop_dataset_300k.csv` is actually an **Apple Numbers file** (`.numbers`), not a CSV file, despite its `.csv` extension.

```
File type: Zip archive data (Apple Numbers format)
```

## Required Action

You need to convert the Numbers file to actual CSV format.

### Option 1: Using Numbers App (Recommended)

1. Open `expanded_synthetic_crop_dataset_300k.numbers` in Apple Numbers
2. Click **File** → **Export To** → **CSV...**
3. Save as: `expanded_synthetic_crop_dataset_300k.csv`
4. Move the exported CSV to `/Users/keerthanshetty/Documents/GitHub/FarmAura_application/models/`
5. Replace the existing file

### Option 2: Using Python Script

I can create a conversion script, but it requires additional libraries. Let me know if you want this option.

### Option 3: Use Excel

1. Open the `.numbers` file in Excel (if you have it)
2. Save As → CSV (Comma delimited)
3. Save to the models/ directory

## After Conversion

Once you have a proper CSV file, the server should start successfully:

```bash
cd backend
source venv/bin/activate
python app.py
```

## Verification

To verify the file is correct CSV:
```bash
cd models
file expanded_synthetic_crop_dataset_300k.csv
# Should show: "CSV text" or "ASCII text"
# NOT: "Zip archive data"
```

---

**Current Status**: Server cannot start until this file is converted to CSV format.

**Next Step**: Please convert the Numbers file to CSV using one of the options above.
