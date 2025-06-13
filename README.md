# ⚽ FM_MM – Football Manager Mod Manager (Windows, PowerShell 7+)

A simple, flexible mod installer for Football Manager 2024 resources like **skins, kits, faces, logos**, and more.  
Built in PowerShell, designed for automation and easy updates.

---

## ✅ Features

- 🧠 **Interactive or fully automatic** installs with `-auto`
- 🔍 **Category-based filtering** (`-install kits,faces`)
- 📂 **Auto-creates folder structure** if missing
- ⬇️ **Downloads files** and extracts `.zip` or `.rar` using 7-Zip
- 💾 **Manual downloads** supported via browser link + pattern matching
- 🧾 Tracks installed mods in `installed_resources.json`

> 🧪 Currently in early development
> 
> Supports CLI usage, scripting, or just click-and-run. Ideal for power users and newcomers alike.

---

## 📁 Folder Structure

Resources are installed into:

```
Documents
└── Sports Interactive/
    └── Football Manager 2024/
        ├── skins/
        ├── graphics/
        │   ├── logos/
        │   ├── faces/
        │   └── kits/
        └── ...
```

---

## 🚀 How to Use

### 🖥️ Clone and run:

```powershell
git clone https://github.com/PatrickSolberg/FM_MM.git
cd FM_MM
.\Install-FMResource.ps1
```

Or use arguments for automation:

```powershell
# Install all resources without prompts
.\Install-FMResource.ps1 -auto

# Install only kits and faces
.\Install-FMResource.ps1 -auto -install kits,faces
```

---

### 🌐 One-liner (from anywhere):

```powershell
irm "https://raw.githubusercontent.com/PatrickSolberg/FM_MM/master/Install-FMResource.ps1" | iex
```

---

## 🧱 `resources.json` Format

All installable resources are stored in a JSON file:

```json
{
  "resources": [
    {
      "id": "df11_faces",
      "name": "DF11 Faces Megapack",
      "category": "faces",
      "type": "manual",
      "url": "https://df11faces.com",
      "expectedFilePattern": "DF11*Faces*.zip",
      "installPath": "graphics\\faces",
      "credit": "DF11 (https://df11faces.com)"
    }
  ]
}
```

Supports:
- `type`: `manual`, `manual_browser`, or `direct`
- `expectedFilePattern`: for auto-detecting local file downloads
- `installPath`: relative to FM folder (like `graphics\\kits`)

---

## 🧰 Requirements

- ✅ Windows 10 or 11
- ✅ PowerShell 7+ (install via [Microsoft Docs](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell))
- ✅ Internet connection
- ✅ [7-Zip](https://www.7-zip.org/) if using `.rar` resources

---

## 🗺️ Roadmap

- [x] Modular `resources.json` with credits
- [x] CLI flags: `-auto`, `-install`
- [x] 7-Zip `.rar` extraction
- [x] Manual browser download support
- [ ] Hash checking (integrity)
- [ ] Backup/reinstall existing resources
- [ ] GitHub release installer / EXE wrapper

---

## 🤝 Contribute

Pull requests welcome!

Ideas:
- Add a resource browser menu
- Improve retry/downloader
- Add new mod support (tactics, databases, etc.)

---

## 📜 License

MIT License — open source, use it freely, just don’t sell it as your own.  
Respect mod creators' rules when linking/distributing.

---

## ⚠️ Disclaimer

This project is not affiliated with SEGA or Sports Interactive.  
Third-party resources belong to their respective authors.  
Please follow each creator's terms of use.
