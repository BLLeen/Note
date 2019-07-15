# Git教程

## clone远程仓库
```sh

	# 将远程仓库克隆到本地
	git clone git@github.com:xxxx/xxxxx.git "绝对路径"
	
	# 创建本地个人分支
	git checkout -b branchname origin/branchname
	
	# 抓取远程修改
	git pull 
	
	# 为自己分支和远程分支创建关联
	git branch --set-upstream-to=origin/branchname branchname

	# 推送自己的分支
	git push origin branchname 
	
	# 删除本地仓库
	删除.git文件夹 rm -rf .git
```
----------------------------------------------------------------------
## 分支Branch
- 查看本地分支
$ git branch
- 查看包括远程的所有分支
$ git branch -a
- 创建本地分支并关联远程分支
$ git checkout -b dev  (创建并切换到dev分支)

$ git pull origin dev

- 切换分支
$ git checkout dev
- 合并分支
$ git merge branchname
- 删除分支
$git branch -d branchname

$git branch -D branchname(强行删除)

----------------------------------------------------------

## 保存现场
	创建现场(保存add的暂存区，此时为nothing，可切换分支)
		$ git stash
	stash列表
		$ git stash list
	现场恢复
		$ git stash apply (stash@{0}) (不删除)
		$ git stash pop (stash@{0}) (恢复同时删除)
	现场删除
		$ git stash drop (stash@{0})
---------------------------------------------------------

## 多人协作
	本地关联远程
		$ git remote add origin git@github.com:xxxxx/xxxxx.git
	创建远程origin的dev分支
		$ git checkout -b dev origin/dev 
	提交冲突
		将最新提交抓取下来
			$ git pull
		如果git pull提⽰“no tracking information”，则本地分⽀和远程分⽀的链接关系没有创建
			$ git branch --set-upstream branchname origin/branchname。 
		解决冲突在提交
---------------------------------------------------------
## 管理标签
	添加分支标签
		$ git tag xxxx
	添加commit标签
	 	$ git tag xxxx commitId
	添加有信息的标签
		$ git tag -a tagName -m "xxxxx" commitId
	查看所有标签
		$ git tag
	查看标签信息
		$ git show tagName
	删除标签
		$ git tag -d tagName
	推送标签到远程
		$ git push origin tagName
		$ git push origin --tags(所有标签)
	删除远程标签
		$ git push origin :refs/tags/tagName
---------------------------------------------------------
## 查看commi日志
	$ git log --pretty=oneline --abbrev-commit（简略）
	$ git log(详细)

## 查看命令日志
	$ git reflog 

## 撤销修改 git checkout -- (filename)
	1.修改还未add：则回到版本区一样的状态
	2.修改已add，但是工作区又修改：则回到当前暂存区状态

## 删除暂存区 
	git reset HEAD (filename)
## 文件删除
	git rm (filename)
	git commit -m ""

## 文件恢复
	git checkout -- (filename)将版本库恢复到工作区
	如果未commit则git checkout -- (filename)将暂存区恢复到工作区
	
------------------------------------------------------------------
子模式
	用来引入另一个git项目
	添加子模块
		git submodule add git@github.com:xxx/xxx.git mymodule
	cat .submodules
		[submodule "name"]
			path=(父模块的子目录)
			url=git@github.com:xxx/xxx.git
	删除子模块
		1) $ git rm --cached [submodulePath] //根据路径删除子模块的记录
		2) 编辑“.gitmodules”文件，将子模块的相关配置节点删除掉清理子模块配置
		3) 编辑“ .git/config”文件，将子模块的相关配置节点删除掉 
		4) 手动删除子模块残留的目录 
	切换子模块
		cd进入子模块目录即可
	子模式修改提交
		子模块修改提交后切换到父模块进行pull（拉取所有的关联子模块最新修改）
		git submodule foreach git pull
	有submodule的项目的clone
		git clone git@github.com:xxxxx/xxxxxx.git  --recursive
	

## Git提交规范
Git提交时，添加Comment请遵循以下要求：
- [INI] 初始化创建项目
- [IMP] 提升改善正在开发或者已经实现的功能
- [FIX] 修正BUG
- [REF] 重构一个功能，对功能重写
- [ADD] 添加实现新功能
- [REM] 删除不需要的文件	
- [UPD] 修改文件


	
	
	
	
