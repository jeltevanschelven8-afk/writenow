# WriteNow

A quiet word processor in the style of the classic Macintosh. It runs in your browser or as a small desktop app on Windows, macOS and Linux.

WriteNow is a tribute to the fast, simple word processors of the early Mac era: a white sheet of paper, a menu bar, a ruler, and nothing else in the way. It is one HTML file with no dependencies, and everything you write stays on your own computer.

> **Beta.** Made by Jelte van Schelven. An independent tribute, not affiliated with or endorsed by T/Maker, Apple or anyone behind the original WriteNow. See [NOTICE.md](NOTICE.md).

## Features

- Classic Mac look: menu bar, title bar, scroll bars and dialogs, in black and white or grey "Platinum"
- Pixel fonts rebuilt from the original bitmap specimens (Chicago, Geneva, Monaco, New York, Athens, London, Los Angeles, San Francisco, Venice), plus Courier, Helvetica, Palatino and Times
- Ruler with draggable indents, alignment and line spacing
- Headers, footers, numbered footnotes, tables, page numbers, date and time, lines and page breaks
- Find and Change, undo and redo, word count
- Import text, HTML and PDF files (a PDF becomes an editable document)
- Works offline; documents are saved in your browser or app profile

## Install

| Platform | Steps | Guide |
|---|---|---|
| Windows 10 / 11 | run `install.ps1` | [Windows](docs/INSTALL.md#windows) |
| macOS 11+ | run `make-app.command` once to build `WriteNow.app` | [macOS](docs/INSTALL.md#macos) |
| Linux | run `install.sh` | [Linux](docs/INSTALL.md#linux) |
| Any browser | open `windows/index.html`, or host the `website/` folder | [Web](docs/INSTALL.md#web) |

## Repository layout

```
writenow.html   the whole program (the source of everything)
build.py        builds every package from writenow.html
windows/        install.ps1, uninstall.ps1, icon
mac/            main.swift (native wrapper), make-app.command, icon
linux/          install.sh, uninstall.sh, icon
website/        static site with web app manifest and offline support
tests/          browser-based stress tests
docs/           installation guide
```

The `index.html` files in the platform folders are generated. Edit `writenow.html`, then run `python build.py`.

## Tests

```
python -m http.server 8794
```

Open <http://localhost:8794/tests/stress.html>. The summary should read `N / N passed`. The PDF tests need internet access.

## Known limitations

- No printing or columns (shown disabled in the menus, like the original).
- PDF import keeps text, headings and page breaks, not images or layout, and cannot read scanned PDFs.
- The macOS app has not been tested on a real Mac and the Linux installer has not been tested on a real Linux desktop. Please open an issue if something fails.
- Only Chromium-based browsers have been tested.
