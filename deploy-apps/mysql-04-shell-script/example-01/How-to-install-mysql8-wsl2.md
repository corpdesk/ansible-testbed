## Install MySql 8.x on WSL2 Ubuntu18.04

```bash
(
git clone https://gist.github.com/CosminEugenDinu/7ef73816f950b1ba8a9fd1eabb23c42e install_mysql8
chmod 740 install_mysql8/wsl2-ubuntu18.04-mysql8.0.sh
./install_mysql8/wsl2-ubuntu18.04-mysql8.0.sh
)
```

Enter MySql console in order to setup database, users, etc.:
```bash
sudo mysql
# or $sudo mysql -u root -p (if you set up root password)

```
```
mysql> create database db_name;
mysql> create user 'devops'@'%' identified by 'yU0B14NC1PdE';
mysql> grant all on db_name.* to db_user@localhost;
mysql> exit
```

```
create user 'devops'@'%' identified by '<db-pswd>';
GRANT ALL PRIVILEGES ON *.* TO 'devops'@'%';
```

Import backup database data
```bash
sudo mysql db_name < /full/path/to/backup.sql
```