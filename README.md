# 《密特罗德：萨姆斯回归》汉化项目

## 简介

《密特罗德：萨姆斯回归（*Metroid: Samus Returns*）》是 SFC  《密特罗德2（*Metroid 2*）》的重制版，本项目是其汉化项目。你可以使用本项目提供的工具对游戏的文本进行编辑，并生成修改补丁。

## 开始

### 运行环境

* .NET Framework 4.6

* Python 2.7

### #0 准备工作

1. 安装 Python 第三方包： [python-fire](https://github.com/google/python-fire)、[rectpack](https://github.com/secnot/rectpack)

   ```bash
   python -m pip install fire rectpack
   ```

2. 安装 [devkitPro](https://devkitpro.org/wiki/Getting_Started)（Windows 系统下推荐使用 msys2 安装），并将devkitPro添加到PATH变量。安装完成后执行以下命令以确保所需工具已安装：

   ```bash
   
   tex3ds -v
   
   输出：
   
    tex3ds v1.0.0
    
    Copyright (c) 2017 Michael Theall (mtheall)
    tex3ds is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    tex3ds is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with tex3ds. If not, see <http://www.gnu.org/licenses/>.
   ```

### #1 导出所需资源文件（文本、LOGO图像）

1. 导出RomFS。

   你可以使用`3dstool`或`ctrtool`解包本游戏的`RomFS`并将其放到本项目的`cia`目录下。或者使用`fuse-3ds`直接将游戏`ROM`挂载到本项目下的`cia`目录。

2. 导出文本。

   ```bash
   make plain_txt
   ```

3. 导出LOGO。

### #2 编辑

* 使用文本编辑器编辑文本

* 使用图像编辑工具编辑LOGO

### #3 生成补丁

```bash
make luma.zip
```

## 脚本使用说明

### btxt.py

二进制<->文本转换工具。

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
