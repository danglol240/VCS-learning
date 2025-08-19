# User/Group Management
## USER + GROUP
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
    - E.g ![anh2](https://github.com/user-attachments/assets/af8b8825-27d5-40cc-89f6-ae208b484db5) 
3. Date last change : thời gian sửa đổi lần cuối dùng theo thời gian Unix
4. Minimum age : thời gian nhỏ nhất giữa hai lần sửa đổi mật khẩu (default 0)
5. Maximum age : thời gian lớn nhất mật khẩu đấy còn valid cho đến khi phải thay đổi (default 99999)
6. Warning period : Số ngày cho đến khi đến maximum age sẽ được phát cảnh báo đổi mật khẩu
7. Inactivity period : Số ngày sau khi tới maximum age mà người dùng chưa đổi mật khẩu sẽ được cho cơ hội thứ 2 để đổi mật khẩu nếu vẫn không đổi mật khẩu thì account sẽ rơi vào trạng thái lock
8. Expire Date : ngày mà account đó bị lock
9. Unused : Không được sử dụng, được để dành cho mục đích khác ở tương lai