# Installing WriteNow

Pick your system:

- [Windows](#windows) · [macOS](#macos) · [Linux](#linux)
- After installing: [first steps](#first-steps) · [keyboard shortcuts](#keyboard-shortcuts) · [updating](#updating) · [troubleshooting](#troubleshooting)

None of the installers need administrator or root rights, and none of them change your default apps.

---

## Windows

**You need:** Windows 10 or 11. Microsoft Edge is used for the app window and is already part of Windows.

1. Download **[WriteNow-for-Windows.zip](https://github.com/jeltevanschelven8-afk/writenow/raw/main/dist/WriteNow-for-Windows.zip)**.
2. Right-click the zip, choose **Extract All…**, then **Extract**.
3. In the extracted folder, double-click **install.cmd**.
   - If a blue box says **"Windows protected your PC"**, click **More info**, then **Run anyway**. This appears for every file downloaded from the internet that is not signed by a company.
4. A black window shows *"WriteNow is installed"*. Press any key to close it.
5. Start **WriteNow** from the Start menu or from the new icon on your desktop.

> Use **install.cmd**, not install.ps1. Windows blocks PowerShell scripts that come from the internet (*"is not digitally signed"*); install.cmd starts the same script with permission for that one run, without changing any Windows settings.

What the installer does:

| | |
|---|---|
| Program files | `%LOCALAPPDATA%\Programs\WriteNow` |
| Shortcuts | Start menu and desktop |
| PDF files | adds **Open with › WriteNow** (your default PDF app stays the same) |
| App window | its own window through Edge, with its own profile, no address bar or tabs |
| Rights | no administrator rights needed |

**Uninstall:** double-click **uninstall.cmd** in the same folder. This removes the program, the shortcuts, the PDF entry and the documents saved inside WriteNow.

---

## macOS

**You need:** macOS 11 (Big Sur) or newer, on Intel or Apple silicon. The first time, macOS installs Apple's free *Command Line Tools* (about 5 minutes, done once).

The Mac version is a real app. It is built on your own Mac in about half a minute, so macOS trusts it and shows no "unidentified developer" warning.

1. Download **[WriteNow-for-Mac.zip](https://github.com/jeltevanschelven8-afk/writenow/raw/main/dist/WriteNow-for-Mac.zip)** and double-click it to unzip.
2. Open **Terminal** (Finder › Applications › Utilities › Terminal, or press ⌘ Space and type *Terminal*).
3. Type `bash` followed by a **space**. Do not press Enter yet.
4. Drag **make-app.command** from the unzipped folder into the Terminal window, then press **Enter**.
5. If macOS asks to install the *Command Line Tools*, click **Install**, wait until it is done, and repeat steps 3 and 4.
6. A Finder window opens with **WriteNow.app**. Drag it to **Applications**, then open it with a double-click. Right-click its Dock icon › Options › **Keep in Dock** if you like.

| | |
|---|---|
| Program | `/Applications/WriteNow.app` (wherever you put it) |
| PDF files | right-click a PDF › **Open With › WriteNow** |
| Full screen | Control ⌘ F, for the real 1984 feeling |

**Uninstall:** drag **WriteNow.app** to the Trash.

---

## Linux

**You need:** a desktop Linux (Ubuntu, Debian, Fedora, Mint, Arch, …) and a Chromium-based browser: Chrome, Chromium, Edge, Brave or Vivaldi. If you have none of them:

```
sudo apt install chromium        # Debian, Ubuntu, Mint
sudo dnf install chromium        # Fedora
sudo pacman -S chromium          # Arch
```

1. Download **[WriteNow-for-Linux.zip](https://github.com/jeltevanschelven8-afk/writenow/raw/main/dist/WriteNow-for-Linux.zip)** and unzip it.
2. Open a terminal in the unzipped folder (right-click › *Open in Terminal* in most file managers).
3. Run:
   ```
   bash install.sh
   ```
4. Open your applications menu and search for **WriteNow**.

| | |
|---|---|
| Program files | `~/.local/share/writenow` |
| Menu entry | `~/.local/share/applications/writenow.desktop` |
| PDF files | right-click a PDF › **Open With › WriteNow** |

**Uninstall:** `bash uninstall.sh` in the same folder.

---

## First steps

- Start WriteNow from the Start menu (Windows), the Applications folder (macOS) or your app menu (Linux).
- Click **Start writing** on the welcome box and type. The sample text explains the ruler and menus.
- **File › New** starts an empty document, **File › Save** keeps it, **File › Open…** brings it back.
- **File › Import File…** opens a text, HTML or PDF file as a new document. You can also drag a file onto the page.
- **View › Platinum** switches to the grey Mac OS 8 look; **View › Show Ruler** and **Show Invisibles** toggle the ruler and ¶ marks.

Your documents are stored on your own computer, inside WriteNow. They are not uploaded or shared between computers.

## Keyboard shortcuts

On Windows and Linux use **Ctrl**, on macOS use **⌘**. The menus show the right key for your system.

| Key | Action | Key | Action |
|---|---|---|---|
| S | Save | Shift H | Header |
| O | Open | Shift F | Footer |
| Z / Shift Z | Undo / Redo | Shift B | Page break |
| F / G | Find / Find again | ] / [ | Bigger / smaller text |
| B / I / U | Bold / Italic / Underline | Shift P | Plain text |

A few shortcuts, such as Ctrl N and Ctrl W on Windows and Linux, are reserved by the system window; the menus always work.

## Updating

Download the newest zip and run the installer again (Windows, Linux) or `make-app.command` again (macOS). Your saved documents are kept.

## Troubleshooting

| Problem | Solution |
|---|---|
| Windows: *"is not digitally signed"* or *"running scripts is disabled"* | Double-click **install.cmd** instead of install.ps1. |
| Windows: *"Windows protected your PC"* | Click **More info**, then **Run anyway**. |
| Windows: the shortcut still shows an old icon | Restart Windows; the icon cache refreshes. |
| macOS: `make-app.command` prints an error | [Open an issue](https://github.com/jeltevanschelven8-afk/writenow/issues) and paste the full Terminal output. |
| macOS: *"command not found: swiftc"* | Run `xcode-select --install`, then try again. |
| Linux: *"No Chromium-based browser found"* | Install Chromium (see [Linux](#linux)) and run `bash install.sh` again. |
| *"WriteNow is a desktop program"* appears | You opened `index.html` directly. Install WriteNow with the installer and start it from the menu instead. |
| A PDF does not open | Check the internet connection (the PDF reader loads on first use). Scanned PDFs contain no text and cannot be imported. |
| *"Storage is full"* | Delete old documents with **File › Open… › Delete**. |
| Courier, Helvetica or Times look different | Without internet, similar fonts from your system are used. The pixel fonts are always built in. |

Still stuck? [Open an issue](https://github.com/jeltevanschelven8-afk/writenow/issues) and say which system you use.
