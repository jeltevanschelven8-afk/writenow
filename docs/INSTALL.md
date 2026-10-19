# Installation guide

Download or clone this repository first. On GitHub choose **Code > Download ZIP** and unzip it.

## Windows

Requires Windows 10 or 11 with Microsoft Edge (already installed on Windows).

1. Open the `windows` folder.
2. Right-click `install.ps1` and choose **Run with PowerShell**.
3. Find **WriteNow** in the Start menu and on your desktop.

No administrator rights are needed. WriteNow opens in its own Edge window without an address bar, using its own profile, and is offered under **Open with** for PDF files.

If PowerShell refuses to run the script, open PowerShell in the folder and run:

```
powershell -ExecutionPolicy Bypass -File install.ps1
```

To remove it, run `uninstall.ps1` the same way.

## macOS

Requires macOS 11 (Big Sur) or newer and Apple's free Command Line Tools. The script offers to install them if they are missing.

1. Open the `mac` folder.
2. Open **Terminal** (Applications > Utilities).
3. Type `bash ` (with a space), drag `make-app.command` into the window and press Enter.
4. After about half a minute `WriteNow.app` appears in the folder. Drag it to **Applications**.

The app is built on your own Mac, so macOS does not show an "unidentified developer" warning. Right-click a PDF and choose **Open With > WriteNow** to import it. For the old-Mac feeling, press Control+Command+F for full screen.

## Linux

Requires a desktop Linux and a Chromium-based browser (Chrome, Chromium, Edge, Brave or Vivaldi).

```
sudo apt install chromium      # Debian / Ubuntu
sudo dnf install chromium      # Fedora
```

1. Open a terminal in the `linux` folder.
2. Run `bash install.sh`.
3. Search for **WriteNow** in your applications menu.

The files go to `~/.local/share/writenow` and no root access is needed. Right-click a PDF and choose **Open With > WriteNow**. Remove it with `bash uninstall.sh`.

## Web

- **Single file:** run `python build.py`, then double-click `dist/WriteNow.html`. It opens in any browser.
- **Host it:** upload the `website/` folder to any static host (Netlify Drop, Cloudflare Pages, GitHub Pages). Visitors can install it as an app: Safari **File > Add to Dock** on macOS, the install icon in the address bar of Edge or Chrome, or **Add to Home Screen** on a phone.

## Using WriteNow

- Shortcuts use **Ctrl** on Windows and Linux and **Command** on macOS: S save, O open, Z undo, F find, B / I / U bold, italic, underline.
- Some browsers keep a few shortcuts for themselves (such as Ctrl+N or Ctrl+W). The menu always works.
- Use **File > Import File** to open a text, HTML or PDF file. Opening PDFs needs internet access the first time.
- Documents are stored in the app or browser profile on that computer; they are not uploaded anywhere.

## Troubleshooting

| Problem | What to do |
|---|---|
| Windows: nothing happens after install | Open the Start menu and search for WriteNow; check that Microsoft Edge is installed |
| macOS: `make-app.command` shows a compile error | Open an issue and paste the output |
| Linux: "No Chromium-based browser found" | Install Chromium, or double-click `index.html` to use any browser |
| A PDF does not open | Check your internet connection; scanned PDFs without text cannot be imported |
