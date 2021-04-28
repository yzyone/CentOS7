
# 定义ll命令 #

## OSX ##

修改文件 `~/.profile` 或者  `~/.bash_profile`

    alias ll='ls -lG'
	或者
    alias ll='ls -lGaf'



## linux ##

修改文件 `~/.bashrc` 或者 `~/.bash_profile`

    alias ll='ls -l --color=auto'


执行

    source ~/.bash_profile

或者

从新打开terminal

即可生效。

