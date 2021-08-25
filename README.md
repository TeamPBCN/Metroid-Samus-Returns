# 《密特罗德：萨姆斯回归》汉化项目

## 简介

《密特罗德：萨姆斯回归（*Metroid: Samus Returns*）》是 GB  《密特罗德2（*Metroid 2*）》的重制版，本项目是其汉化项目。你可以使用本项目提供的工具对游戏的文本进行编辑，并生成修改补丁。

## 开始

### 运行环境

* .NET Framework 4.6

* Python 2.7

### #0 准备工作

安装 Python 第三方包： [python-fire](https://github.com/google/python-fire)、[pygame](https://github.com/pygame/pygame)

   ```bash
   python -m pip install fire pygame
   ```

### #1 导出所需资源文件（文本、LOGO图像）

1. 导出RomFS。

   你可以使用`3dstool`或`ctrtool`解包本游戏的`RomFS`并将其放到本项目的`cia`目录下。或者使用 [fuse-3ds](https://github.com/ihaveamac/fuse-3ds) 直接将游戏`ROM`挂载到本项目下的`cia`目录。

2. 导出文本。

   ```bash
   make plain_txt
   ```

3. 导出LOGO。

   ```bash
   python texdump.py mtxtdmp <logo文件路径>
   ```


### #2 编辑

* 使用文本编辑器编辑文本

* 使用图像编辑工具编辑LOGO

### #3 生成补丁

```bash
make luma.zip
```

## 脚本使用说明

### btxt.py

二进制文本 <-> 普通文本转换工具。

```
使用方法: btxt.py [-h] (-x | -c) [-b BINARY] [-p PLAIN]

选项:
  -h, --help            显示帮助
  -x, --export          导出文本
  -c, --create          将文本转换为游戏支持的二进制格式
  -b BINARY, --binary BINARY
                        设置二进制文件路径
  -p PLAIN, --plain PLAIN
                        设置文本文件路径
```

### pkg.py

解包/打包工具。

```
使用方法: pkg.py [-h] (-x | -c) [-f FILE] [-d DIR]

选项:
  -h, --help            显示帮助
  -x, --extract         解包文件包
  -c, --create          创建文件包
  -f FILE, --file FILE  设置文件包路径
  -d DIR, --dir DIR     设置将打包的目录
```

### fnt.py

字库生成工具。

```
使用方法: fnt.py [-h] --width WIDTH --height HEIGHT -c CHARSET -g GROUPS
              [GROUPS ...] -t TABLE -x TEXTURE --inner-tex-path INNER_TEX_PATH
              --inner-tbl-path INNER_TBL_PATH

选项:
  -h, --help            显示帮助
  --width WIDTH         设置字库图像宽度
  --height HEIGHT       设置字库图像高度
  -c CHARSET, --charset CHARSET
                        设置字符集文件路径。字符集必须是UTF-16编码
  -g GROUPS [GROUPS ...], --groups GROUPS [GROUPS ...]
                        设置组。组的描述格式: "path=组输出路径:font=组渲染字体
                        :size=字体大小:filter=字符集过滤表"
  -t TABLE, --table TABLE
                        设置字符表文件路径
  -x TEXTURE, --texture TEXTURE
                        设置图像文件路径
  --inner-tex-path INNER_TEX_PATH
                        设置mfnt文件内部的图像文件路径
  --inner-tbl-path INNER_TBL_PATH
                        设置mfnt文件内部的字符表文件路径
```
