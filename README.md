# 《密特罗德：萨姆斯回归》汉化项目

## 简介

《密特罗德：萨姆斯回归（*Metroid: Samus Returns*）》是 GB  《密特罗德2（*Metroid 2*）》的重制版，本项目是其汉化项目。你可以使用本项目提供的工具对游戏的文本进行编辑，并生成修改补丁。

## 开始

### 运行环境

* .NET Framework 4.6

* Python 2.7

### 0 准备工作

安装 Python 第三方包： [python-fire](https://github.com/google/python-fire)、[pygame](https://github.com/pygame/pygame)

   ```bash
   python -m pip install fire pygame
   ```

### 1 导出所需资源文件（文本、LOGO图像）

1. 导出RomFS。

   你可以使用`3dstool`或`ctrtool`解包本游戏的`RomFS`并将其放到本项目的`cia`目录下。或者使用 [fuse-3ds](https://github.com/ihaveamac/fuse-3ds) 直接将游戏`ROM`挂载到本项目下的`cia`目录。

2. 导出文本。

```batch
python btxt.py -xb RomFS\system\localization\要翻译的语言.txt -p 导出.txt
```

3. 导出LOGO。

```batch
python texdump.py mtxtdmp RomFS\gui\textures\gamelogo.bctex . 
```


### 2 编辑

* 使用文本编辑器编辑文本

* 使用图像编辑工具编辑LOGO

### 3 生成汉化文件
* 生成文本二进制
```batch
python btxt.py -cb <生成目录>\要翻译的语言.txt -p 导出.txt
```
* 生成logo
```batch
.\bin\tex3ds.exe -f rgba8 --raw -z none -o <生成目录>\gamelogo.tex gamelogo.png
copy textures\gamelogo\gamelogo.bctex.hdr <生成目录>\gamelogo.bctex
python texcopy.py <生成目录>\gamelogo.tex <生成目录>\gamelogo.bctex 0x100
```
* 生成字库
```batch
.\build_font.bat
```
