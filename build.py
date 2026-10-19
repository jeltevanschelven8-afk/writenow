"""Builds the WriteNow desktop packages from writenow.html.

    python build.py

Writes index.html into windows/, mac/ and linux/, and the downloads to dist/.
The packaged index.html only starts when it is opened by the installed program
(see the check at the top of the script in writenow.html).
"""
import os, re, zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
os.chdir(HERE)

page = open('writenow.html', encoding='utf-8').read()
assert page.startswith('<title>'), 'writenow.html must start with <title>; do not save a built file over it'

icon = open('windows/WriteNow.ico', 'rb').read()
import base64
fav = '<link rel="icon" type="image/x-icon" href="data:image/x-icon;base64,' + base64.b64encode(icon).decode() + '">\n'

html = ('<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n'
        '<meta name="viewport" content="width=device-width, initial-scale=1">\n' + fav +
        '<script>window.WN_REQUIRE_APP=true</script>\n' + page + '\n</html>\n')

def write(path, text):
    open(path, 'w', encoding='utf-8', newline='\n').write(text)

for folder in ('windows', 'mac', 'linux'):
    write(folder + '/index.html', html)

def zip_folder(folder, out):
    with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
        for f in sorted(os.listdir(folder)):
            path = os.path.join(folder, f)
            if os.path.isdir(path):
                continue
            data = open(path, 'rb').read()
            if f.endswith(('.command', '.swift', '.txt', '.sh', '.ps1')):
                data = data.replace(b'\r\n', b'\n')
            zi = zipfile.ZipInfo(os.path.basename(out)[:-4] + '/' + f)
            zi.compress_type = zipfile.ZIP_DEFLATED
            zi.external_attr = (0o100755 if f.endswith(('.command', '.sh')) else 0o100644) << 16
            z.writestr(zi, data)

os.makedirs('dist', exist_ok=True)
for name in os.listdir('dist'):
    os.remove(os.path.join('dist', name))
zip_folder('windows', 'dist/WriteNow-for-Windows.zip')
zip_folder('mac', 'dist/WriteNow-for-Mac.zip')
zip_folder('linux', 'dist/WriteNow-for-Linux.zip')
print('built')
