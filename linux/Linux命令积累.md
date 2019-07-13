
# make

```
-f：指定“makefile”文件；
-i：忽略命令执行返回的出错信息；
-s：沉默模式，在执行之前不输出相应的命令行信息；
-r：禁止使用build-in规则；
-n：非执行模式，输出所有执行命令，但并不执行；
-t：更新目标文件；
-q：make操作将根据目标文件是否已经更新返回"0"或非"0"的状态信息；
-p：输出所有宏定义和目标文件描述；
-d：Debug模式，输出有关文件和检测时间的详细信息。

```

# yum
软件包管理器
```
选项
-h：显示帮助信息；
-y：对所有的提问都回答“yes”；
-c：指定配置文件；
-q：安静模式；
-v：详细模式；
-d：设置调试等级（0-10）；
-e：设置错误等级（0-10）；
-R：设置yum处理一个命令的最大等待时间；
-C：完全从缓存中运行，而不去下载或者更新任何头文件。
参数
install：安装rpm软件包；
update：更新rpm软件包；
check-update：检查是否有可用的更新rpm软件包；
remove：删除指定的rpm软件包；
list：显示软件包的信息；
search：检查软件包的信息；
info：显示指定的rpm软件包的描述信息和概要信息；
clean：清理yum过期的缓存；
shell：进入yum的shell提示符；
resolvedep：显示rpm软件包的依赖关系；
localinstall：安装本地的rpm软件包；
localupdate：显示本地rpm软件包进行更新；
deplist：显示rpm软件包的所有依赖关系。
```
## yum -y update
升级所有包，改变软件设置和系统设置,系统版本内核都升级
## yum -y upgrade
升级所有包，不改变软件设置和系统设置，系统版本升级，内核不改变


# ghkconfig
检查、设置系统的各种服务。这是Red Hat公司遵循GPL规则所开发的程序，它可查询操作系统在每一个执行等级中会执行哪些系统服务，其中包括各类常驻服务。谨记chkconfig不是立即自动禁止或激活一个服务，它只是简单的改变了符号连接。
## 使用
1. 服务脚本必须存放在/etc/ini.d/目录下，并在脚本上添加

```shell
# chkconfig: 2345 90 10
# description: Saves and restores system entropy pool for \
# higher quality random number generation.
```
2. chkconfig --add servicename在chkconfig 工具服务列表中增加此服务，此时服务会被在/etc/rc.d/rcN.d中赋予K/S入口了；
3. chkconfig --level 35 mysqld on 修改服务的默认启动等级。

## 命令
```
--add：增加所指定的系统服务，让chkconfig指令得以管理它，并同时在系统启动的叙述文件内增加相关数据；
--del：删除所指定的系统服务，不再由chkconfig指令管理，并同时在系统启动的叙述文件内删除相关数据；
--level<等级代号>：指定读系统服务要在哪一个执行等级0-6中开启或关毕。
--list：所有服务

```

[chkconfig,service 和systemctl](http://pcpj2g4mj.bkt.clouddn.com/18-8-29/61043616.jpg)



# 系统

## 查看用户日志

tail -f filename

## lastlog

查看用户登陆日志信息

