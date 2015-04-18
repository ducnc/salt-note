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
salt '*' state.highstate -l debug
```

Sau khi tại `Salt Master` cài đặt xong. Quay trở lại node `Controller` thực hiện các lệnh sau để cài đặt image Glance, network và router:

```sh
souce openrc
neutron net-create ext_net --router:external True --shared 
neutron subnet-create --name sub_ext_net ext_net 192.168.5.0/24 --gateway 192.168.5.1 --allocation-pool start=192.168.5.200,end=192.168.5.250 --enable_dhcp=False --dns-nameservers list=true 8.8.8.8 8.8.4.4 210.245.0.11
neutron net-create int_net 
neutron subnet-create int_net --name int_subnet --dns-nameserver 8.8.8.8 172.16.10.0/24
neutron router-create router_1
neutron router-gateway-set router_1 ext_net
neutron router-interface-add router_1 int_subnet
```

Cài đặt thành công, mở trình duyệt tại địa chỉ http://192.168.10.51 và đăng nhập bằng tài khoản admin password f0290c8447ff2c7e5962 để sử dụng OpenStack.

Trong một số trường hợp có thể phải reboot lại các node trước khi sử dụng.
