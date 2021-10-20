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
python btxt.py -xb romfs\system\localization\<要翻译的语言>.txt -p 导出.txt
```

3. 导出LOGO。

```batch
python texdump.py mtxtdmp romfs\gui\textures\gamelogo.bctex . 
```


### 2 编辑

* 使用文本编辑器编辑文本

* 使用图像编辑工具编辑LOGO

### 3 生成汉化文件
* 生成文本二进制
```batch
md build\romfs\system\localization
python btxt.py -cb build\romfs\system\localization\<要翻译的语言>.txt -p 导出.txt
```
* 生成logo
```batch
md build\romfs\gui\textures
.\bin\tex3ds.exe -f rgba8 --raw -z none -o build\gamelogo.tex gamelogo.png
copy textures\gamelogo\gamelogo.bctex.hdr build\romfs\gui\textures\gamelogo.bctex
python texcopy.py build\gamelogo.tex build\romfs\gui\textures\gamelogo.bctex 0x100
```
* 生成字库
```batch
.\build_font.bat
```
