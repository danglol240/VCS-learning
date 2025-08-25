# Package Management
## Khái niệm cơ bản
### Mirror và Repo
* Mirror có thể hiểu là một máy chủ nhân bản có chứa bản sao của dữ liệu hay kho lưu trữ của server khác và được chạy ở trên một thiết bị khác với bản gốc mục đích là để : *Tăng tốc độ tải, Chia tải hoặc dùng làm Dự phòng*
* Repo hay Repository là kho lưu trữ các phần mềm, ứng dụng, tool tiện ích mà được duy trì và phát hành bởi một tổ chức cơ quan => Các công ty thường sẽ tự host một Mirror riêng, nội bộ(internal) nhằm mục đích bảo mật hoặc yêu cầu nhân viên sử dụng những package, yêu cầu về version cụ thể.

## Cách APT cấu hình mirror và repo
* APT lấy cấu hình của repository từ File chính: `/etc/apt/sources.list` Thư mục phụ: `/etc/apt/sources.list.d/*.list` (Trước khi chỉnh sửa cần lưu ý sao lưu trước khi thay đổi)
<img width="605" height="291" alt="aptsources" src="https://github.com/user-attachments/assets/aae27a77-4d98-402f-88cf-09a6930ba753" />

- **Thêm repo**: Sử dụng `sudo add-apt-repository "deb http://example.com/repo focal main"` (đối với PPA: `sudo add-apt-repository ppa:user/ppa-name`). Hoặc thêm thủ công vào `/etc/apt/sources.list` và chạy `sudo apt update`.
- **Sửa repo**: Chỉnh sửa dòng trong `/etc/apt/sources.list` (ví dụ: thay đổi URL mirror) và chạy `sudo apt update`.
- **Xóa repo**: Sử dụng `sudo add-apt-repository --remove "deb http://example.com/repo focal main"`, hoặc xóa tệp trong `/etc/apt/sources.list.d/`, sau đó chạy `sudo apt update`.

## Package
* Một gói là một tệp lưu trữ nén (định dạng `.deb` trong Ubuntu/Debian) chứa phần mềm, bao gồm các tệp thực thi, thư viện, tệp cấu hình và siêu dữ liệu. Nó đơn giản hóa việc cài đặt, quản lý và phân phối phần mềm.
* Các gói được sử dụng để cài đặt, cập nhật và xóa phần mềm một cách hiệu quả trong khi xử lý phụ thuộc, đảm bảo tính nhất quán hệ thống và cho phép kiểm soát phiên bản.

## Thông thường, một gói bao gồm:
- Binary files (tệp thực thi và thư viện).
- Configuration files
- Tài liệu (trang man, README).
- metadata (tên, phiên bản, phụ thuộc, thông tin người duy trì, checksum).
- Các script trước/sau cài đặt (cho các tác vụ thiết lập/dọn dẹp).
- Danh sách tệp và quyền truy cập

* Package Dependency là các gói khác cần thiết để một gói hoạt động. APT tự động giải quyết và cài đặt chúng để tránh xung đột hoặc phần mềm bị hỏng


## APT và dpkg
-   **dpkg**: Công cụ cấp thấp (low-level) để cài đặt, gỡ bỏ và quản lý
    các gói `.deb`.
-   **apt**: Công cụ cấp cao (high-level) dùng để quản lý gói, phụ
    thuộc, và kho lưu trữ, dựa trên `dpkg`.

### So sánh dpkg và APT

| Tiêu chí               | dpkg                                | APT (Advanced Package Tool)                   |
|-------------------------|-------------------------------------|-----------------------------------------------|
| **Mục đích**            | Low-level package manager           | High-level package management tool            |
| **Chức năng**           | Cài đặt, Gỡ bỏ, Chỉnh sửa các package `deb` một cách trực tiếp | Quản lý gói, tự động xử lý phụ thuộc |
| **Xử lý dependency**| Phải xử lý phụ thuộc 1 cách trực tiếp | Tự động tải và xử lý phụ thuộc cần thiết |
| **Phạm vi xử lý**        | Sử dụng cho các package đơn lẻ   | Sử dụng cho toàn bộ hệ thống       |

## Một số câu lệnh chính
* Show dependencies: `apt depends` `apt rdepends`
* Kiểm tra thuộc package nào : dùng `dpkg -S` hoặc `apt-file search`
* List file trong 1 packge : dùng `dpkg -L` hoặc `apt-file list`
* Search : `apt search` hoặc `apt-file search`
* Download : `sudo apt install`
* Remove : `sudo apt remove`(keep conf files) `sudo apt purge`(no keep) `sudo apt autoremove`(remove unused dependencies)
* Upgrade : `sudo apt update`(update repo cache) `sudo apt upgrade`(upgrade installed packages)/`sudo apt full-upgrade`
* List toàn bộ hoặc đã tải : `apt list` hoặc `dpkg -l`