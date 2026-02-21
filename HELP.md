# 《逃出精神病院》环境搭建说明（技术文档）

## 目录
1. [开发环境概览](#1-开发环境概览)
2. [基础环境配置](#2-基础环境配置)
3. [Godot引擎安装](#3-godot引擎安装)
4. [项目获取与导入](#4-项目获取与导入)
5. [安卓打包环境](#5-安卓打包环境)
6. [项目运行测试](#6-项目运行测试)
7. [常见问题排查](#7-常见问题排查)
8. [附录：环境变量配置](#8-附录环境变量配置)
9. [联系方式](#9-联系方式)

---

## 1. 开发环境概览

### 1.1 环境总览表

| 组件 | 版本 | 用途 | 必要性 | 安装难度 |
|------|------|------|--------|----------|
| Windows系统 | 10/11 (64位) | 基础操作系统 | 必需 | - |
| Git | 2.40.0+ | 代码版本控制 | 必需 | 低 |
| Godot引擎 | 4.6.1 | 游戏开发引擎 | 必需 | 中 |
| JDK | 17+ | 安卓编译工具链 | 安卓必需 | 中 |
| Android SDK | 35+ | 安卓开发工具包 | 安卓必需 | 高 |
| Gradle | 8.2+ | 安卓构建系统 | 安卓必需 | 中 |
| VSCode | 最新版 | 代码编辑器 | 推荐 | 低 |
| Python | 3.9+ | 构建辅助脚本 | 推荐 | 中 |
| Android NDK | r28b | 原生代码编译 | 可选 | 中 |
| CMake | 3.10.2+ | 编译工具 | 可选 | 中 |

---

## 2. 基础环境配置

### 2.1 Git安装（必需）

用途：从GitHub获取项目代码、版本管理、协同开发

下载地址：https://git-scm.com/download/win

安装步骤：
1. 运行安装包 Git-2.42.0-64-bit.exe
2. 组件选择：默认即可（建议勾选"Git GUI Here"）
3. 默认编辑器：选择 "Use Visual Studio Code as Git's default editor"（如果已安装VSCode）
4. 分支名称：选择 "Override the default branch name for new repositories" → 输入 main
5. PATH环境：选择 "Git from the command line and also from 3rd-party software"
6. HTTPS传输：选择 "Use the OpenSSL library"
7. 行尾转换：选择 "Checkout Windows-style, commit Unix-style line endings"
8. 终端模拟器：选择 "Use MinTTY"
9. 其他选项：默认即可

验证安装：
```bash
git --version
# 输出示例：git version 2.42.0.windows.1
```

### 2.2 VSCode安装（推荐）

用途：编写GDScript代码、编辑配置文件、查看项目结构

下载地址：https://code.visualstudio.com/download

必要插件：
- Godot Tools：Godot语言支持
- GDScript：语法高亮
- GitLens：Git增强
- EditorConfig：统一代码风格

安装命令：
```bash
code --install-extension geequlim.godot-tools
code --install-extension dragonglass.gdscript
```

---

## 3. Godot引擎安装

### 3.1 下载Godot（必需）

用途：游戏开发核心引擎、场景编辑、脚本编写、打包导出

版本选择：Godot 4.6.1 stable（与项目兼容）

下载地址：https://godotengine.org/download/archive/4.6.1-stable/

选择文件：Godot_v4.6.1-stable_win64.exe.zip

### 3.2 安装步骤

方法一：手动安装
```bash
mkdir D:\DevTools\Godot
# 将 Godot_v4.6.1-stable_win64.exe.zip 解压到 D:\DevTools\Godot\
```

方法二：使用winget（Windows 10 1709+）
```bash
winget search godot
winget install --id=GodotEngine.GodotEngine -v 4.6.1
```

方法三：Steam安装
- 打开Steam客户端
- 搜索 "Godot Engine"
- 点击安装

### 3.3 验证安装

```bash
cd D:\DevTools\Godot
.\Godot_v4.6.1-stable_win64.exe --version
# 输出：4.6.1
```

### 3.4 添加到系统PATH（可选）

用途：可以在任意目录通过命令行启动Godot

操作步骤：
1. 右键 此电脑 → 属性 → 高级系统设置
2. 点击 环境变量
3. 在 系统变量 中找到 Path，双击编辑
4. 点击 新建，添加 D:\DevTools\Godot
5. 点击确定保存

验证：
```bash
godot --version
# 输出：4.6.1
```

---

## 4. 项目获取与导入

### 4.1 克隆项目（必需）

用途：获取游戏源代码到本地

```bash
mkdir D:\Projects
cd D:\Projects
git clone https://github.com/xuchengyu20130704/EscapeAsylum.git
cd EscapeAsylum
git branch -a
git checkout develop
```

### 4.2 项目结构验证

```bash
tree /F
```

预期输出：
```
EscapeAsylum/
├── .git/
├── .gitignore
├── .gitattributes
├── README.md
├── LICENSE
├── CHANGELOG.md
├── project.godot
├── Main.gd
├── Main.tscn
├── icon.svg
├── modules/
│   ├── 基础模块.gd
│   ├── 反派线.gd
│   ├── 正派线.gd
│   └── 回归线.gd
└── saves/
```

### 4.3 在Godot中导入项目

1. 双击Godot图标打开项目管理器
2. 点击左侧"导入"标签
3. 点击"浏览"按钮
4. 导航到：D:\Projects\EscapeAsylum
5. 选择 project.godot 文件
6. 点击"打开"
7. 点击项目右侧的"编辑"

验证项目加载：
- 场景面板：应显示 Main.tscn
- 文件系统面板：应显示所有项目文件
- 输出面板：按F3打开，查看是否有错误信息

---

## 5. 安卓打包环境

### 5.1 JDK安装（安卓必需）

用途：安卓应用编译、打包、签名

版本要求：JDK 17+（Godot 4.x要求）

下载地址：https://adoptium.net/（Eclipse Temurin 17 LTS）

安装步骤：
```bash
# 安装路径：C:\Program Files\Eclipse Adoptium\jdk-17.0.9.9-hotspot\

# 设置JAVA_HOME环境变量
# 系统变量 → 新建 → 变量名：JAVA_HOME
# 变量值：C:\Program Files\Eclipse Adoptium\jdk-17.0.9.9-hotspot\

# 添加到PATH：%JAVA_HOME%\bin
```

验证安装：
```bash
java -version
# 输出示例：
# openjdk version "17.0.9" 2023-10-17
# OpenJDK Runtime Environment Temurin-17.0.9+9 (build 17.0.9+9)
# OpenJDK 64-Bit Server VM Temurin-17.0.9+9 (build 17.0.9+9, mixed mode)
```

### 5.2 Android SDK安装（安卓必需）

用途：安卓开发工具包、模拟器管理、设备调试

下载地址：https://developer.android.com/studio#command-line-tools-only

安装步骤：

```bash
mkdir D:\Android\sdk
cd D:\Android\sdk
# 下载 commandlinetools-win-11076708_latest.zip
# 解压后目录结构：D:\Android\sdk\cmdline-tools\latest\bin\

cd D:\Android\sdk\cmdline-tools\latest\bin

# 接受许可证
.\sdkmanager --licenses

# 安装平台工具
.\sdkmanager "platform-tools" "platforms;android-35"

# 安装构建工具
.\sdkmanager "build-tools;35.0.0"

# 安装NDK（可选）
.\sdkmanager "ndk;28.1.13356709"

# 安装CMake（可选）
.\sdkmanager "cmake;3.10.2.4988404"
```

### 5.3 设置Android环境变量

```bash
# ANDROID_HOME = D:\Android\sdk
# PATH添加：%ANDROID_HOME%\platform-tools
# PATH添加：%ANDROID_HOME%\cmdline-tools\latest\bin
```

验证安装：
```bash
adb --version
# 输出：Android Debug Bridge version 35.0.0

sdkmanager --list
```

### 5.4 Gradle配置（安卓必需）

用途：安卓项目的构建系统

Godot 4.x会自动下载Gradle。如果需要手动配置：

```bash
# 下载地址：https://gradle.org/releases/
# 下载 gradle-8.5-bin.zip
# 解压到：D:\DevTools\gradle-8.5

# GRADLE_HOME = D:\DevTools\gradle-8.5
# PATH添加：%GRADLE_HOME%\bin

gradle --version
# 输出：Gradle 8.5
```

### 5.5 Godot安卓导出配置

1. Godot编辑器 → 编辑器 → 编辑器设置
2. 左侧选择 Export → Android
3. 配置：
   ```
   Android SDK Path: D:\Android\sdk
   Debug Keystore: （自动生成）
   ```
4. 项目 → 导出 → 添加 → Android
5. 点击"管理导出模板" → "下载并安装导出模板"

---

## 6. 项目运行测试

### 6.1 桌面平台测试

```bash
# 在Godot编辑器中按F5
```

预期结果：
- 游戏窗口打开
- 开场文字逐条显示
- 出现选择选项
- 点击选项后剧情推进

### 6.2 安卓设备测试

准备工作：
1. 安卓设备开启开发者模式
2. 开启USB调试
3. 用USB线连接电脑
4. 设备上允许调试授权

一键部署：
```bash
# Godot中：导出 → Android → 点击"一键部署"
```

预期结果：
```
BUILD SUCCESSFUL in 2m 30s
57 actionable tasks: 57 executed
# 设备上自动启动游戏
```

---

## 7. 常见问题排查

### 7.1 Git相关问题

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| git 不是内部命令 | Git未安装或未添加到PATH | 重新安装Git，勾选"Add to PATH" |
| failed to push | 远程有本地没有的提交 | git pull origin main --rebase |
| LF will be replaced | 行尾符号转换警告 | 添加 .gitattributes 文件 |

### 7.2 Godot相关问题

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| 打开项目空白 | 版本不兼容 | 确认使用Godot 4.6.1 |
| 脚本错误红色波浪线 | 语法错误 | 检查代码，参考现有模块格式 |
| Parse Error | 场景文件格式错误 | 删除 Main.tscn，在编辑器中重新创建 |
| Unable to load | 文件路径错误 | 检查文件名和路径，Godot区分大小写 |

### 7.3 安卓打包问题

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| Java not found | JDK未安装或PATH错误 | 检查 JAVA_HOME 环境变量 |
| SDK not found | Android SDK路径错误 | 在编辑器设置中配置正确的SDK路径 |
| Gradle build failed | 依赖下载失败 | 设置Gradle代理，或手动下载依赖 |
| INSTALL_FAILED | 设备上已安装旧版本 | 卸载设备上的旧版本APK |
| 打包速度慢 | 首次需要下载依赖 | 等待完成，或使用代理加速 |

### 7.4 代理配置

Git代理：
```bash
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890

# 取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

Gradle代理：
创建 C:\Users\用户名\.gradle\gradle.properties：
```
systemProp.http.proxyHost=127.0.0.1
systemProp.http.proxyPort=7890
systemProp.https.proxyHost=127.0.0.1
systemProp.https.proxyPort=7890
```

Android SDK代理：
```bash
sdkmanager --no_https --sdk_root=%ANDROID_HOME% "platform-tools"
```

---

## 8. 附录：环境变量配置

### 8.1 完整环境变量配置脚本

创建 setup_env.bat：

```batch
@echo off
echo 正在配置环境变量...

:: Java环境
setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-17.0.9.9-hotspot" /M

:: Android环境
setx ANDROID_HOME "D:\Android\sdk" /M

:: Godot路径（可选）
setx GODOT_HOME "D:\DevTools\Godot" /M

:: 更新PATH
for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH') do set "syspath=%%b"
setx PATH "%syspath%;%JAVA_HOME%\bin;%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\cmdline-tools\latest\bin;%GODOT_HOME%" /M

echo 环境变量配置完成！
echo 请重新打开命令提示符使配置生效。
pause
```

### 8.2 环境检查脚本

创建 check_env.bat：

```batch
@echo off
echo ========== 环境检查 ==========
echo.

echo [Git]
git --version
echo.

echo [Godot]
godot --version
echo.

echo [Java]
java -version
echo.

echo [Android SDK]
echo ANDROID_HOME=%ANDROID_HOME%
adb --version
echo.

echo [Gradle]
gradle --version
echo.

echo ========== 检查完成 ==========
pause
```

---

## 9. 联系方式

### 开发者联系方式

| 方式 | 账号 | 用途 |
|------|------|------|
| 微信 | FHCAP43 | 即时沟通、问题反馈 |
| QQ | 1541523162 | 技术交流、文件传输 |
| 邮箱 | duskbloomwork@outlook.com | 正式咨询、合作洽谈 |

### 问题反馈渠道

环境搭建问题：
- 环境配置报错
- 依赖安装失败
- 打包异常

游戏开发问题：
- 剧情模块编写
- 资源导入问题
- 性能优化建议

合作交流：
- 项目合作
- 代码贡献
- 创意建议

### 回复时间

| 时间段 | 响应速度 |
|--------|----------|
| 工作日 9:00-18:00 | 1-2小时内回复 |
| 其他时间 | 24小时内回复 |
| 紧急问题 | 请备注【紧急】 |

### 问题反馈格式

```
【问题类型】：环境搭建 / 游戏运行 / 打包问题
【操作系统】：Windows 10/11
【Godot版本】：4.6.1
【问题描述】：详细说明遇到的问题
【错误截图】：（如有）
【已尝试的解决方式】：
```

---

文档版本：help-doc v0.0.1
最后更新：2026-2-21