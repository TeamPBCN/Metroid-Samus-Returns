# btxt.py
Binary text tool.
```
usage: btxt.py [-h] (-x | -c) [-b BINARY] [-p PLAIN]

Binary text tool for Metroid: Samus Returns. Create by LITTOMA, TeamPB,
2018.12

optional arguments:
  -h, --help            show this help message and exit
  -x, --export          Export messages.
  -c, --create          Convert plain text to binary text.
  -b BINARY, --binary BINARY
                        Set binary text file.
  -p PLAIN, --plain PLAIN
                        Set plain text file.
```

# pkg.py
Package tool.
```
usage: pkg.py [-h] (-x | -c) [-f FILE] [-d DIR]

Package tool for Metroid: Samus Returns. Create by LITTOMA, TeamPB, 2018.12

optional arguments:
  -h, --help            show this help message and exit
  -x, --extract         Extract package.
  -c, --create          Create package.
  -f FILE, --file FILE  Set package file.
  -d DIR, --dir DIR     Set dir.
```

# fnt.py
Font tool.
```
usage: fnt.py [-h] --width WIDTH [WIDTH ...] --height HEIGHT [HEIGHT ...] -c
              CHARSET -g GROUPS [GROUPS ...] -t TABLE -x TEXTURE

Metroid: Samus Returns font generator by LITTOMA, TeamPB, 2018.12

optional arguments:
  -h, --help            show this help message and exit
  --width WIDTH [WIDTH ...]
                        Set font texture width.
  --height HEIGHT [HEIGHT ...]
                        Set font texture height.
  -c CHARSET, --charset CHARSET
                        Set charset file path. The file must stored in utf-16
                        encoding.
  -g GROUPS [GROUPS ...], --groups GROUPS [GROUPS ...]
                        Set groups. Group string format: "name=GROUP_NAME:font
                        =FONT_NAME:size=FONT_SIZE:filter=FILTER_PATH"
  -t TABLE, --table TABLE
                        Set table file path.
  -x TEXTURE, --texture TEXTURE
                        Set texture file path.
```
