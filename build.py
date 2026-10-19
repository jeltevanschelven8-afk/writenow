"""Builds every WriteNow package from writenow.html.

Output: index.html in windows/, mac/, linux/ and website/, plus dist/ with
the zip files and the single-file WriteNow.html.

    python build.py

Writes index.html into the Windows, Mac, Linux and website folders, the
single-file WriteNow.html, and the zip files. Icons and scripts that live in
those folders are left alone.
"""
import os, re, zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
os.chdir(HERE)

page = open('writenow.html', encoding='utf-8').read()
fav = re.search(r'<link rel="icon"[^>]+>\n', open('windows/index.html', encoding='utf-8').read()).group(0)
base = ('<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n'
        '<meta name="viewport" content="width=device-width, initial-scale=1">\n')

def write(path, text):
    open(path, 'w', encoding='utf-8', newline='\n').write(text)

plain = base + fav + page + '\n</html>\n'
for folder in ('windows', 'mac', 'linux'):
    write(folder + '/index.html', plain)
os.makedirs('dist', exist_ok=True)
write('dist/WriteNow.html', plain)

site_head = (base +
    '<meta name="description" content="WriteNow: a quiet word processor in the style of the classic Macintosh, made by Jelte van Schelven. Beta.">\n'
    '<meta name="theme-color" content="#000000">\n<meta name="apple-mobile-web-app-title" content="WriteNow">\n'
    '<link rel="manifest" href="manifest.webmanifest">\n<link rel="apple-touch-icon" href="apple-touch-icon.png">\n' + fav)
sw = ('<script>if("serviceWorker" in navigator&&location.protocol==="https:")'
      'navigator.serviceWorker.register("sw.js").catch(function(){});</script>\n')
write('website/index.html', site_head + page + '\n' + sw + '</html>\n')

# Linux icon = the 512 px website icon
open('linux/writenow.png', 'wb').write(open('website/icon-512.png', 'rb').read())

def zip_folder(folder, out, executable=()):
    with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
        for f in sorted(os.listdir(folder)):
            path = os.path.join(folder, f)
            if os.path.isdir(path):
                continue
            data = open(path, 'rb').read()
            if f.endswith(('.command', '.swift', '.txt', '.sh', '.ps1')):
                data = data.replace(b'\r\n', b'\n')
            zi = zipfile.ZipInfo(folder + '/' + f)
            zi.compress_type = zipfile.ZIP_DEFLATED
            zi.external_attr = (0o100755 if f in executable or f.endswith(('.command', '.sh')) else 0o100644) << 16
            z.writestr(zi, data)

with zipfile.ZipFile('dist/WriteNow.zip', 'w', zipfile.ZIP_DEFLATED) as z:
    z.write('dist/WriteNow.html', 'WriteNow.html')
os.makedirs('dist', exist_ok=True)
zip_folder('mac', 'dist/WriteNow-for-Mac.zip')
zip_folder('linux', 'dist/WriteNow-for-Linux.zip')
zip_folder('windows', 'dist/WriteNow-for-Windows.zip')
print('built')
