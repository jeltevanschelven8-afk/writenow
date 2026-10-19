WRITENOW FOR LINUX
by Jelte van Schelven

WHAT YOU NEED
- Any desktop Linux (Ubuntu, Debian, Fedora, Arch, Mint, ...).
- A Chromium-based browser: Chrome, Chromium, Edge, Brave or Vivaldi.
  (Debian/Ubuntu:  sudo apt install chromium    Fedora:  sudo dnf install chromium)

INSTALL
1. Unzip this folder.
2. Open a terminal in the folder and run:
       bash install.sh
3. Search for "WriteNow" in your applications menu.

OPEN A PDF
Right-click a PDF > Open With > WriteNow. You can also use File > Import File...
The text of the PDF arrives as an editable document (scans without text don't
work, and opening PDFs needs internet).

NO INSTALL
Double-click index.html: it opens in your normal browser. That works with
Firefox too, but Firefox has no app window, and saved documents stay in that
browser.

REMOVE
    bash uninstall.sh

GOOD TO KNOW
- Shortcuts use Ctrl (Ctrl+S save, Ctrl+B bold, Ctrl+Z undo, Ctrl+F find).
- Your documents are kept inside the app's own browser profile
  (~/.local/share/writenow/profile).
- Courier, Helvetica and Times use Liberation or DejaVu fonts when the
  originals are missing. The pixel fonts are built in.

FILES
index.html      the program itself
writenow.png    the icon
install.sh      installs it
uninstall.sh    removes it
