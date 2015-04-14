## Một số note khi sử dụng `saltstack`

### 1. Cài đặt

- Master:

```sh
apt-get update && apt-get upgrade -y
apt-get install python-software-properties -y
add-apt-repository ppa:saltstack/salt -y
apt-get update
apt-get install salt-master -y
```

`vi /etc/salt/master`

```sh
# saltmaster sẽ listen trên tất cả các IP
interface: 0.0.0.0

# Saltmaster sẽ đọc các file cấu hình ở /srv/salt
file_roots:
  base:
    - /srv/salt
```

- Minion 

Ubuntu: `apt-get install salt-minion -y`

CentOS: `rpm -Uvh http://ftp.linux.ncsu.edu/pub/epel/6/i386/epel-release-6-8.noarch.rpm && yum install salt-minion -y`

`vi /etc/salt/minion`

```sh
master: 192.168.5.50
```

Restart minion: `/etc/init.d/salt-minion restart`

### 2. Thêm xóa minion 

Sau khi restart các minion sẽ gửi các yêu cầu kết nối đến Master.
Trên Master sử dụng `salt-key -L` để liệt kê các minion. Các minion chưa được add key sẽ nằm tại: `Unaccepted Keys:`
Để add key làm như sau:
- Add 1 minion: `salt-key -a $ten_minion`
Ví dụ: `salt-key -a controller`
- Add tất cả minion: `salt-key -A`

Xóa minion:
- Xóa 1 minion: `salt-key -d $ten_minion`
- Xóa tất cả minion: `salt-key -D`

Sau khi add xong `salt-key -L` sẽ thấy các minion được add nằm tại `Accepted Keys:`

Kiểm tra kết nối: `salt '*' test.ping`

```sh
controller:
    True
CentOS:
    True
```