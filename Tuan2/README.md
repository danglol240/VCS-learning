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
* 3 loại người dùng file **_user_** - **_group_** - **_other_** => muốn xem thông tin đầy đủ -> ls -l
* Vấn đề thay đổi quyền của file :
    * Chỉ chủ sở hữu hoặc root mới được quyển thay đổi quyền của file
    * Có 2 cách để thay đổi quyền: **symbolic** dùng chuỗi ký tự còn **numeric** dùng số để biểu diễn quyền
* Vấn đề thay đổi chủ sở hữu của file  
    * Bắt buộc phải là những người dùng có quyền *sudo* mới có thể thay đổi quyền của file
    * có thể thay đổi chủ sở hữu / nhóm sở hữu file bằng câu lệnh **chown** **chgrp**