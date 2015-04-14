# saltstack

### Lab cài đặt OpenStack bằng SaltStack

#### Mô hình cài đặt:

![Alt text](http://i.imgur.com/f6fPdi1.png)

Trong đó:
- Master: Ubuntu Server 12.04
- Các node còn lại: Ubuntu Server 14.04

#### Thực hiện

Tại `salt master` thực hiện các lệnh:

```sh
apt-get install -y git
git clone salt '*' https://github.com/ducnc/salt-note.git
cp -R salt-note/salt /srv
cp -R salt-note/pillar /srv
salt '*' state.highstate
```