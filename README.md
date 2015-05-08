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
cd ~
git clone https://github.com/ducnc/salt-note.git
cp -R salt-note/salt /srv
cp -R salt-note/pillar /srv
salt '*' state.highstate
```

Sau khi tại `Salt Master` cài đặt xong. Quay trở lại node `Controller` thực hiện các lệnh sau để cài đặt image Glance, network và router:

```sh
source openrc
neutron net-create ext_net --router:external True --shared 
neutron subnet-create --name sub_ext_net ext_net 192.168.5.0/24 --gateway 192.168.5.1 --allocation-pool start=192.168.5.200,end=192.168.5.250 --enable_dhcp=False --dns-nameservers list=true 8.8.8.8 8.8.4.4 210.245.0.11
neutron net-create int_net 
neutron subnet-create int_net --name int_subnet --dns-nameserver 8.8.8.8 172.16.10.0/24
neutron router-create router_1
neutron router-gateway-set router_1 ext_net
neutron router-interface-add router_1 int_subnet
```

Cấu hình image mẫu Cirros cho hệ thống: 
```sh
mkdir images
cd images/
wget https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img
glance image-create --name "cirros-0.3.3-x86_64" --disk-format qcow2 --container-format bare --is-public True --progress < cirros-0.3.0-x86_64-disk.img
cd	
rm -r images
```

Cài đặt thành công, mở trình duyệt tại địa chỉ http://192.168.10.51 và đăng nhập bằng tài khoản admin password f0290c8447ff2c7e5962 để sử dụng OpenStack.

####**Chú ý:**

- Trong một số trường hợp có thể phải reboot lại các node trước khi sử dụng.
- Tại thời điểm thực hiện cài đặt hệ thống này nhiều khi sources.list mặc định của Ubuntu bị lỗi Hash sum mismatch khiến cho các gói cài đặt không đúng phiên bản của OpenStack. Để kiểm tra điều này bạn hãy thực hiện câu lệnh sau trên node Controller trước khi thực hiện cài đặt trên Salt Master:
`apt-get update –y`

Nếu gặp lỗi Hash sum mismatch thì bạn hãy thực hiện việc thay sources.list khác bằng các lệnh như sau trên tất cả các node OpenStack trước khi chạy state trên Salt Master:
```sh
cd /etc/apt/
wget https://raw.githubusercontent.com/hocchudong/ghichep/master/sources.list2
mv sources.list sources.list.bka
mv sources.list2 sources.list
cd
```