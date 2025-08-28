# Bổ sung
## FS
### Luồng hoạt động File system
1. Ứng Dụng Gửi Yêu Cầu
- Gọi system call: `open()`, `read()`, `write()`, `close()`
- Chuyển từ **user space** sang **kernel space**

2. Logical File System (LFS)
- Quản lý **metadata**: quyền truy cập, vị trí file, dung lượng
- Kiểm tra quyền truy cập
- Phân tích đường dẫn (path resolution)
- Giao tiếp với **File Organization Module**

3. File Organization Module
- Xác định cách dữ liệu được lưu: block, inode, FAT, ext4 inode...
- Tìm vị trí block vật lý
- Chuyển yêu cầu xuống **Basic File System**

4. Basic File System
- Cung cấp API cơ bản để đọc/ghi block
- Tạo **I/O request** (bio struct, buffer head)

5. I/O Control Layer
- Gồm:
  - **Device Drivers**: giao tiếp trực tiếp với thiết bị (HDD, SSD, NVMe)
  - **Interrupt Handlers**: nhận tín hiệu I/O hoàn thành
- Sử dụng **I/O Scheduler**: CFQ, deadline, noop...

6. Device Hardware
- Thực hiện lệnh đọc/ghi block
- Trả dữ liệu về kernel qua **DMA** hoặc **interrupt**

7. Trả Kết Quả Về Ứng Dụng
- Kernel nhận interrupt → đánh thức process đang chờ
- Copy dữ liệu từ kernel buffer về user buffer
- System call trả về → ứng dụng tiếp tục thực thi
### Vấn đề umount lúc 1 tiến trình đang xử lý
* Tình huống: xuất hiện 1 tiến trình đọc ghi / có file descriptor cwd(current working directory) nằm ở bên trong khu vực cần unmount => target is busy
* Quy trình kill+umount: 
    1. Xác định tiến trình đang được xử lý ở bên trong vị trí cần umount bằng : `lsof` hoặc `fuser`
    2. Xác định xong sẽ tiến hành kill tiến trình đấy dựa trên PID
    3. Kiểm tra lại rồi tiến hành unmount
    <img width="1919" height="1153" alt="forcekill" src="https://github.com/user-attachments/assets/3c6114b2-57d7-49cb-ae7f-c848689cecd5" />
* Vấn đề về dữ liệu

## LVM
### Định nghĩa
Logical Volume (LV) là thành phần của Logical Volume Manager (LVM), dùng để quản lý dung lượng lưu trữ linh hoạt hơn so với phân vùng truyền thống. Nó hoạt động như một “phân vùng ảo” mà bạn có thể tạo, mở rộng, thu nhỏ, di chuyển, snapshot… mà không bị ràng buộc chặt chẽ vào kích thước cố định của phân vùng vật lý.
### Quy trình hoạt động
* LVM sẽ thêm 1 số bước nằm giữa sau khi phân vùng và trước khi gắn file system vào vùng nhớ
![LogicalVolumenManager](https://github.com/user-attachments/assets/03f28770-9757-41bf-b3b2-99c8d713f136)

1. Sau khi phân vùng sẽ phải thêm physical volume dựa trên các partition thông qua các lệnh như `pvcreate` `pvs`. Bản chất là gắn nhãn LVM lên partition đấy
<img width="645" height="144" alt="pvs" src="https://github.com/user-attachments/assets/ba76e258-a6c4-4263-9b95-96a35f867920" />

2. Tiếp theo sẽ là group các physical volume để tạo thành 1 vùng nhớ(ổ đĩa ảo) gọi là volume group thông qua các lệnh `vgcreate` `vgs`
3. Sau đấy sẽ là khởi tạo các logical volume dựa trên ổ đĩa ảo volume group thông qua các lệnh `lvcreate` `lvs`
<img width="1377" height="725" alt="lvs" src="https://github.com/user-attachments/assets/c97b7a0e-7e03-40d0-bb1d-f61b11bcec8b" />

### Mở rộng thu hẹp
1. Physical volume: Yêu cầu phải mở rộng partition trước khi mở rộng physical volume sau đó dùng lệnh `pvresize`
<img width="1273" height="201" alt="pvresize" src="https://github.com/user-attachments/assets/cb35f65d-5fed-4002-909b-09ac0ddcc40e" />

2. Volume group: bằng cách nhóm thêm các physical volume khác vào thông qua lệnh `vgextend` `vgremove`

3. Logical Volume: bằng cách sử dụng lệnh `lvextend` `lvreduce` => lượng bộ nhớ có thể sử dụng mở rộng ra hoặc thu hep phụ thuộc vào volume group mà logical volume này được tạo
<img width="910" height="478" alt="lvextend" src="https://github.com/user-attachments/assets/d2000514-d5f0-4cda-8066-2bc93d9e95f4" />

## Hard link and sym link