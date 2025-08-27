# User/Group Management
## USER + GROUP
* User: là một tài khoản có thể là *người dùng thực* hoặc là *tiến trình hệ thống* . Group sẽ bao gồm nhiều người dùng mục đích là để xác định mức độ quyền hạn(level of privilege) đối với các file/directories mà nhóm sở hữu
* người dùng sẽ được quản lý bằng một file $${\color{red}/etc/passwd}$$ ngoài ra còn có file $${\color{red}/etc/passwd-}$$ dùng cho trường hợp backup và được phân cách giữa các trường bởi dấu :

![ảnh 1](https://github.com/user-attachments/assets/52361aa9-9d99-44ca-8c0e-6064a2a079f1)

Ở đây có 7 fields bắt đầu từ:

1. Username: Tên người dùng
2. Password: Mật khẩu người dùng (sẽ được lưu ở trong $${\color{cyan}/etc/shadow}$$) còn ở đây dấu x tức là được mã hóa ở trong file mật khẩu
3. UserID: ID của toàn bộ người dùng

| Number | UserID |
| --- | --- |
| 0 | root |
| 1 to 999 | predefined + admin + system account|
| 1000 above | user account |

4. GroupID: ID của primary group mà người dùng đấy thuộc
5. UserID info: Comment field ghi lại thông tin thêm về người dùng
6. Home Directory: Thư mục home của người dùng đấy
7. Login shell: Đường dẫn tuyệt đối của shell người dùng đấy

* file $${\color{cyan}/etc/shadow}$$ dùng để quản lý mật khẩu cũng được phân cách giống như trong file passwd và có các trường là
1. Username
2. Password : mật khẩu sau khi được hash
    - normal password : gồm có 3 fields ngăn cách với nhau bởi $ => $hash_method_id$salt$hash
    - no login : * => không có password (thường là các account hệ thống)
    - lock account : ! => account bị khóa nhưng không phải bị disable => Sử dụng những phương pháp đăng nhập khác hoặc có các authentication token khác
    - E.g ![/etc/shadow](https://github.com/user-attachments/assets/af8b8825-27d5-40cc-89f6-ae208b484db5) 
3. Date last change : thời gian sửa đổi lần cuối dùng theo thời gian Unix
    - Nếu muốn tính thời gian Unix-Time thì có thể sử dụng hàm date
4. Minimum age : thời gian nhỏ nhất giữa hai lần sửa đổi mật khẩu (default 0)
5. Maximum age : thời gian lớn nhất mật khẩu đấy còn valid cho đến khi phải thay đổi (default 99999)
6. Warning period : Số ngày cho đến khi đến maximum age sẽ được phát cảnh báo đổi mật khẩu
7. Inactivity period : Số ngày sau khi tới maximum age mà người dùng chưa đổi mật khẩu sẽ được cho cơ hội thứ 2 để đổi mật khẩu nếu vẫn không đổi mật khẩu thì account sẽ rơi vào trạng thái lock
8. Expire Date : ngày mà account đó bị lock
9. Unused : Không được sử dụng, được để dành cho mục đích khác ở tương lai

* $${\color{burntorange}/etc/group}$$ dùng để chứa thông tin về tất cả group trong hệ thống và có 4 fields là
1. Group Name : Tên của Group
2. Password : Mật khẩu của nhóm được lưu ở trong file $${\color{forestgreen}/etc/gshadow}$$
3. Group ID: ID định danh của group
4. Group member: Toàn bộ thành viên thuôc group đấy

* $${\color{forestgreen}/etc/gshadow}$$ dùng để lưu thông tin về mật khẩu của các group
1. Group name
2. Group Password : Tương tự như trong file $${\color{cyan}/etc/shadow}$$
3. Group administrator : User được Group Owner cấp cho quyền administrator mục đích là để quản lý vấn đề thêm bớt người dùng, quản lý mật khẩu nhóm
4. Group members : Các thành viên trong nhóm

<img width="1304" height="63" alt="/etc/gshadow" src="https://github.com/user-attachments/assets/5dd28f33-0597-4aa9-af59-23f3e232ba02" />

* Ngoài ra còn có file setting các chức năng hệ thống làm khi thêm người dùng mới nằm ở trong file /etc/login.defs (E.g: Thư mục home của người dùng mới nằm ở đâu, shell người dùng, etc)
* Vấn đề xem/thêm/xóa/thay đổi mật khẩu/thay đổi UID,GID cho user/group
    - Xem Thông tin user/group: **id**
    - Thêm user/group : **useradd**(tương tác trực tiếp nên có thể đưa vào script)/**adduser**(thân thiện với người dùng hơn)/**groupadd**
    - Xóa user/group : **deluser**/**delgroup**
    - Thay đổi password cho người dùng/nhóm : **passwd** / **gpasswd**
    - Thêm nhóm/Rời nhóm cho user: **usermod** có thể thay đổi cả primary group lẫn secondary group cũng như là rời khỏi nhóm tuy nhiên chỉ có thể rời secondary group, Có thể sử dụng thêm **groupmod** để thay đổi một số tùy chọn của nhóm

## Permission
### Normal Permission
* 3 loại người dùng file **_user_** - **_group_** - **_other_** và mỗi người sẽ có 3 quyền chính *r*-*w*-*x*=> muốn xem thông tin đầy đủ -> ls -l
* Quyền rwx của file có những điểm khác so với quyền rwx của directories cụ thể là ở quyền thực thi (E.g: Một thư mục có quyền --x (chỉ execute) -> không thấy tên file (không ls được) nhưng nếu biết chính xác tên file và có quyền trên file đó thì vẫn mở được)
* Vấn đề thay đổi quyền của file :
    * Chỉ chủ sở hữu hoặc root mới được quyển thay đổi quyền của file
    * Có 2 cách để thay đổi quyền: **symbolic** dùng chuỗi ký tự còn **numeric** dùng số để biểu diễn quyền
    * Thay đổi quyền của file thông qua câu lệnh **chmod** với cách biểu diễn bên trên
* Vấn đề thay đổi chủ sở hữu của file  
    * Bắt buộc phải là những người dùng có quyền *sudo* hoặc *root* mới có thể thay đổi quyền của file
    * có thể thay đổi owner/group owner file bằng câu lệnh **chown** **chgrp**
    * Lưu ý khi sử dụng câu lệnh chmod/chown với option **-R**(Recursive) đối với thư mục thì sẽ thay đổi toàn bộ content ở bên trong
### Special Permission
* SUID:
    * Thực thi file với quyền hạn của owner
    * chmod u+s / chmod 4xxx -> nếu user không có quyền thực thi thì s->S
    * E.g <img width="550" height="182" alt="SUID" src="https://github.com/user-attachments/assets/fb26dace-2893-423a-aa8b-e5e491c8e4e6" />
* SGID: Tương tự như với SUID nhưng mà được dùng cho group owner
* Sticky bit:
    * chmod o+t / chmod 1xxx -> nếu other không có quyền thực thi thì t->T
    * Files/Directories chỉ có thể bị xóa bởi owner hoặc root
    * E.g <img width="1105" height="344" alt="StickyBit" src="https://github.com/user-attachments/assets/0bb7d084-916a-443f-b389-264557e93012" />
### sudo và su
* su : switch user và sudo : super user do
* config cấu hình sudo nằm ở bên trong file $${\color{red}/etc/sudoers}$$ tuy nhiên việc chỉnh sửa trực tiếp file đấy tiềm ẩn rất nhiều nguy cơ và rủi ro chính vì vậy sẽ sử dụng công cụ để xử lý 1 cách an toàn là : **visudo** => tạo một file sudoers.tmp để tránh sửa đổi trực tiếp file sudoers
<img width="1185" height="549" alt="visudo" src="https://github.com/user-attachments/assets/23b4fa75-0ed1-44a8-ac38-2208c18c5144" />

* Một entry sẽ có dạng " $${\color{red}userorgroup}$$  $${\color{orange}host}$$ = $${\color{blue}(runasuser)}$$ $${\color{green}[options:] }$$ command_list"
    * $${\color{red}userorgroup}$$ : người hoặc nhóm người có thể dùng rule này (WHO)
    * $${\color{orange}host}$$ : host nào sẽ bị người/nhóm người áp dụng lệnh (WHERE)
    * $${\color{blue}(runasuser)}$$ : có thể dưới dạng *user:group* quyền hạn của người dùng rule phụ thuộc vào quyền hạn của runas_user (AS WHO)
    * $${\color{green}[options:] }$$ : các tùy chọn có thể được áp dụng lên
    * command_list : các câu lệnh mà người dùng rule này có thể sử dụng

## Bash Shell env
### Env Variables
- Là các biến **toàn cục** (global variables) trong hệ thống. Được Bash shell và các chương trình con sử dụng để xác định cách hoạt động.
- Thường chứa thông tin như:
<img width="1919" height="879" alt="printenv" src="https://github.com/user-attachments/assets/29e7d2ff-9c83-44ad-9110-3d7364b3eba6" />

  - `PATH`: Danh sách thư mục tìm kiếm lệnh
  - `USER`: Tên người dùng
  - `HOME`: Thư mục chính của user
  - `LANG`: Ngôn ngữ hệ thống
  - `EDITOR`: Trình soạn thảo mặc định
  - `SHELL`: Loại shell đang dùng
- Các process con sẽ **kế thừa** biến môi trường từ shell cha.

<img width="1047" height="180" alt="envtest" src="https://github.com/user-attachments/assets/92d1af07-af1c-4396-9eb3-44bd7b4d954f" />