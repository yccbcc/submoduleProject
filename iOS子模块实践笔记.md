# iOS 子模块实践笔记

记录在 iOS 项目中使用 Git 子模块（Submodule）的完整流程与知识点。

## 一句话总结

1. 主项目执行 `git submodule add` 挂载子模块
2. 进入子模块目录编写代码并推送到子模块远程仓库
3. 回到主项目更新子模块指针提交
4. 在 Xcode 中将子模块目录加入项目

---

## 基本概念

Git 子模块允许在一个 Git 仓库中引用另一个 Git 仓库的特定版本。

- `.gitmodules` 文件记录子模块的远程地址和本地路径（类比 Podfile）
- 主项目不保存子模块文件内容，只保存一个 Commit ID（类比 Podfile.lock）
- 子模块自身是一个独立的 Git 仓库，有自己的 remote 和分支

---

## 步骤

### 0. 预备条件

- 主项目必须已经是 Git 仓库（`git init` 过）
- 子模块的远程仓库在 GitHub 上已创建（可以是空仓库）
- SSH 已配置好，能正常推送代码

### 1. 挂载子模块

```bash
# 在主项目根目录执行
git submodule add git@github.com:用户名/仓库名.git Libs/仓库名
```

执行效果：
- 自动生成 `.gitmodules` 文件，记录远程 URL 和本地路径
- 创建 `Libs/仓库名/` 目录
- 如果远程是空仓库，目录内容为空；如果有代码则克隆下来

### 2. 提交挂载配置 

```bash
# 把第一步的 .gitmodules 和 Libs/仓库名 提交到远程仓库
git add .gitmodules Libs/仓库名
git commit -m "feat: 新增子模块 仓库名"
git push origin master
```

> `.gitmodules` 类比 Podfile，记录了子模块的源和路径。

### 3. 在子模块中编写代码

进入子模块目录：

```bash
cd Libs/仓库名
```

子模块刚拉下来时处于游离 HEAD 状态，需要先切到主分支：

```bash
git checkout -b main    # 如果还没有分支
# 或者
git checkout master     # 如果已有 master 分支
```

然后在目录中创建代码文件。

### 4. 推送子模块代码到远程

```bash
git add .
git commit -m "feat: 实现 XXX 功能"
git push origin master
```

> 类比 Pod：相当于改完 Pod 库代码，提交到 Pod 自己的远程仓库。

### 5. 更新主项目指向子模块最新提交

```bash
# 回到主项目根目录
cd /Users/zhaohongbin/Desktop/submoduleProject

# 记录子模块的新 Commit ID
git add Libs/仓库名
git commit -m "chore: 更新子模块 仓库名 指向最新提交"
git push origin master
```

> `git add Libs/仓库名` 添加的不是文件内容，而是**子模块当前指向的 Commit ID**。类比 Podfile.lock 记录版本号。

### 6. Xcode 集成

**方式 A：通过 Xcode 手动添加（推荐）**

1. 在 Xcode 左侧 Project Navigator 中，右键点击顶层项目文件夹
2. 选择 **Add Files to '项目名...'**
3. 选择 `Libs/仓库名` 目录
4. 勾选 **Create folder references**
5. 勾选目标 target，点击 Add

**方式 B：直接修改 project.pbxproj**

新增 `PBXFileSystemSynchronizedRootGroup` 条目，并在 target 的 `fileSystemSynchronizedGroups` 中添加引用。

### 7. 在代码中调用子模块

```objc
#import "ZHBCommonKit.h"   // 引入子模块头文件

// 调用子模块方法
[ZHBCommonKit sayHello];
```

如果编译时报头文件找不到，在 Build Settings 的 `HEADER_SEARCH_PATHS` 中添加：

```
$(SRCROOT)/Libs/仓库名
```

---

## 多人协作：拉取含子模块的项目

首次克隆包含子模块的项目：

```bash
git clone <主项目地址>
git submodule init          # 初始化子模块配置
git submodule update        # 拉取子模块到指定版本
```

> 场景一：首次克隆，本地还没有子模块代码，需要 init 初始化配置 + update 拉取代码。
> 一条命令替代：`git clone --recurse-submodules <主项目地址>`

> 场景二：已有仓库，子模块之前已 init 过，只需把子模块同步到主项目记录的新版本。
> 如果子模块目录为空，则仍需先执行 `git submodule init`。

```bash
git pull                    # 拉取主项目更新
git submodule update        # 更新子模块到最新记录的 Commit
```

---

## 遇到的问题与解决

### Q1: fatal: A git directory for 'Libs/XXX' is found locally with remote(s)

原因：上一次 `git submodule add` 执行中途失败或被中断，` .git/modules/Libs/XXX/` 目录下残留了子模块的 Git 数据。

解法：

```bash
rm -rf .git/modules/Libs
git submodule add git@github.com:用户名/仓库名.git Libs/仓库名
```

### Q2: SSH 连接时提示 host key verification failed

解法：使用 `-o StrictHostKeyChecking=accept-new` 自动接受主机密钥，或手动连接一次确认。

---

## 常用命令备忘

| 命令 | 作用 |
|------|------|
| `git submodule add <地址> <路径>` | 添加子模块 |
| `git submodule status` | 查看子模块当前 Commit ID |
| `git submodule update` | 更新子模块到主项目记录的版本 |
| `git submodule init` | 初始化子模块配置 |
| `git clone --recurse-submodules <地址>` | 克隆项目同时拉取子模块 |
| `git add Libs/XXX` | 记录子模块的新 Commit ID |
