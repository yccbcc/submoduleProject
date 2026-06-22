# Git 仓库创建笔记

记录在给主项目创建 Git 仓库过程中遇到的知识点。

## 一句话总结

1. 在 GitHub 上创建空仓库
2. 本地 `git init` + `git add .` + `git commit`
3. 配置 SSH（如有公钥则添加至 GitHub，如没有则先生成）
4. `git remote add` + `git push` 推送到远端

---

## 步骤

### 0. 在 GitHub 上创建空仓库

1. 打开 https://github.com/new
2. 填写仓库名（如 `submoduleProject`）
3. **不要勾选** "Add a README" / ".gitignore" / "license"，保持完全空仓
4. 点击 **Create repository**
5. 创建成功后，复制 SSH 地址：`git@github.com:用户名/仓库名.git`

> 之所以要先在远程建空仓，是因为后面 `git remote add` 需要指向一个已存在的仓库地址。

### 1. 初始化本地仓库

```bash
git init                              # 创建 .git 文件夹，项目变成 Git 仓库
git add .                             # 将项目所有文件加入暂存区
git commit -m "chore: 初始化主项目"   # 提交到本地仓库
```

### 2. 配置 SSH（如需）

> 如果使用 HTTPS 地址推送时会报 `Authentication failed`，说明需要改用 SSH。

确认本地是否有 SSH 公钥：

```bash
ls ~/.ssh/id_rsa.pub
```

如果有，查看并复制：

```bash
cat ~/.ssh/id_rsa.pub
```

把输出的内容添加到 GitHub：https://github.com/settings/ssh/new

### 3. 关联远程仓库

```bash
git remote add origin <SSH地址>       # 关联远程仓库（地址在 GitHub 创建后复制）
git push -u origin master             # 推送并建立上游跟踪，后续可直接 git push
```

---

## 遇到的问题与解决

### Q1: 本地项目还没有 Git 仓库怎么办？

如果项目还在本地文件夹里，没有 Git 管理，执行 `git init` 即可。

### Q2: 执行 `git push -u origin main` 报错 "src refspec main does not match any"

原因：本地还没有任何提交，或者默认分支名是 `master` 不是 `main`。

解法：
```bash
# 查看本地分支
git branch

# 如果是 master，直接推 master
git push -u origin master

# 或者重命名为 main 再推
git branch -m master main
git push -u origin main
```

### Q3: HTTPS 推送报错 "Authentication failed"

GitHub 从 2021 年起不再支持 HTTPS 密码认证，只能用 Personal Access Token 或 SSH。

### Q4: 如何改用 SSH 方式推送？

三步搞定：

1. **确认已有 SSH key**
   ```bash
   ls ~/.ssh/id_rsa.pub
   ```

2. **查看并复制公钥**
   ```bash
   cat ~/.ssh/id_rsa.pub
   ```
   把输出的内容添加到 GitHub：https://github.com/settings/ssh/new

3. **切换远程地址为 SSH 格式**
   ```bash
   git remote set-url origin git@github.com:yccbcc/submoduleProject.git
   git push -u origin master
   ```

---

## 常用 Git 命令备忘

| 命令 | 作用 |
|------|------|
| `git init` | 初始化本地 Git 仓库 |
| `git remote add origin <地址>` | 给远程仓库地址设置别名为 origin |
| `git remote set-url origin <新地址>` | 修改 origin 指向的目标地址 |
| `git branch -m <旧名> <新名>` | 重命名当前分支 |
| `git push -u origin <分支名>` | 推送并建立上游关联 |

> 实战例子：一开始配的是 HTTPS 地址，后来发现推不了，换成 SSH 地址
> `git remote set-url origin git@github.com:yccbcc/submoduleProject.git`

## Git 地址格式

SSH 地址格式（推荐）：
```
git@github.com:用户名/仓库名.git
```

HTTPS 地址格式：
```
https://github.com/用户名/仓库名.git
```
