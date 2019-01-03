# btxt.py
Binary text tool.
```
usage: btxt.py [-h] (-x | -c) [-b BINARY] [-p PLAIN]

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
usage: fnt.py [-h] --width WIDTH --height HEIGHT -c CHARSET -g GROUPS
              [GROUPS ...] -t TABLE -x TEXTURE --inner-tex-path INNER_TEX_PATH
              --inner-tbl-path INNER_TBL_PATH

optional arguments:
  -h, --help            show this help message and exit
  --width WIDTH         Set font texture width.
  --height HEIGHT       Set font texture height.
  -c CHARSET, --charset CHARSET
                        Set charset file path. The file must stored in utf-16
                        encoding.
  -g GROUPS [GROUPS ...], --groups GROUPS [GROUPS ...]
                        Set groups. Group string format: "path=GROUP_PATH:font
                        =FONT_NAME:size=FONT_SIZE:filter=FILTER_PATH"
  -t TABLE, --table TABLE
                        Set table file path.
  -x TEXTURE, --texture TEXTURE
                        Set texture file path.
  --inner-tex-path INNER_TEX_PATH
                        Set texture path inside mfnt files.
  --inner-tbl-path INNER_TBL_PATH
                        Set table path inside mfnt files.
```
