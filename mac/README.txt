WRITENOW FOR MAC
by Jelte van Schelven

This folder turns WriteNow into a real Mac app, with its own window and its
own icon in the Dock.

WHAT YOU NEED
- A Mac with macOS 11 (Big Sur) or newer.
- Apple's free Command Line Tools. If you don't have them yet, the script
  offers to install them (this takes a few minutes).

HOW TO MAKE THE APP
1. Put this whole folder on your Mac (USB stick, AirDrop or iCloud Drive).
2. Open Terminal (Applications > Utilities > Terminal).
3. Type:  bash   (followed by a space)
4. Drag the file "make-app.command" into the Terminal window and press Enter.
5. After about half a minute "WriteNow.app" appears in this folder. Drag it
   to your Applications folder. Done: open it with a double-click and keep it
   in your Dock if you like.

GOOD TO KNOW
- Opening a PDF: right-click a PDF in the Finder > Open With > WriteNow. You
  can also use File > Import File... The text of the PDF arrives as an
  editable document (scanned PDFs without text don't work).
- Your documents are kept inside the app (File > Save and Open...).
- For the real old-Mac feeling, go full screen with Control+Command+F.
- Without internet almost everything works. Courier, Helvetica and Times fall
  back to a standard font, and opening PDFs needs internet. The pixel fonts
  are built into the app.
- Want a newer version later? Replace index.html and repeat steps 3 and 4.

FILES
index.html         the program itself
main.swift         the small Mac program that opens the window
logo.png           the icon
make-app.command   the build script
