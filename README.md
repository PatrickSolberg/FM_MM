# ⚽ FM_MM – Football Manager Mod Manager (Windows)

A simple PowerShell-based installer for Football Manager 2024 resources like skins, logos, kits, and facepacks. Designed to automate the setup process with prompts and minimal user effort.

## ✅ Features

- Prompts the user for what to install
- Downloads selected mods/resources
- Automatically creates required folder structure
- Extracts archives to the correct FM directory
- Compatible with **PowerShell 7+ (pwsh)** on Windows

> 🧪 Currently in early development — starting with skin installation as proof of concept.

---

## 📂 Folder Structure

All downloads are placed in:

Documents/
└── Sports Interactive/
└── Football Manager 2024/
└── graphics/
├── skins/
├── logos/
├── faces/
└── kits/


These folders are automatically created if missing.

---

## 🛠️ How to Use

1. **Clone or download this repo**

    ```bash
    git clone https://github.com/YOUR_USERNAME/FM_MM.git
    cd FM_MM
    ```

2. **Run the script in PowerShell 7+**

    ```powershell
    .\Install-FMResource.ps1
    ```

3. **Follow the on-screen prompts**

---

## 🔧 Requirements

- Windows 10/11
- PowerShell 7+ (`pwsh`)
- Internet connection
- Archive support (built-in `Expand-Archive`)

---

## 🚧 Roadmap

- [x] Base installer script
- [ ] Menu for selecting resource types (faces, kits, logos, skins)
- [ ] Source selection (SortitoutSI, FMScout, DF11)
- [ ] Download progress with ETA
- [ ] Dynamic scraping or config-driven download links
- [ ] `.exe` wrapper (optional for non-PowerShell users)

---

## 📄 License

MIT License — feel free to use, fork, and contribute.

---

## 🤝 Contribute

Pull requests are welcome!  
Feel free to improve:
- Resource selection UI
- Error handling
- Support for more mods/sources

---

## ⚠️ Disclaimer

This project is community-made and **not affiliated** with Sports Interactive or SEGA.  
All third-party content belongs to their respective creators.  
Please respect their terms of use and licenses.
