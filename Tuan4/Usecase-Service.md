# File này sẽ nói về 1 use case đơn giản khi làm việc với service
# THông tin về service được lưu ở trong file test.log 
## Context
* Ngày 29/8 setup linger user và 1 user service để ghi lại date hiện tại vào trong 1 file log tên là test.log và sẽ thực hiện lại hành động đấy mỗi 60s 
<img width="464" height="91" alt="linger" src="https://github.com/user-attachments/assets/107f6a00-70c4-4094-8161-3e1fde61680c" />
=> Do để chế độ linger nên user service đấy vẫn sẽ chạy liên tục => Yêu cầu phải stop và disable nhưng không biết đó là process hay service đang chạy chỉ biết được vị trí của file test.log

## Các bước thực hiện
1. Kiểm tra tiến trình đang chạy bằng lệnh lsof hoặc fuser
2. Sau khi phát hiện được tiến trình thử kiểm tra xem có phải service đang chạy hay không dùng `systemctl status`
3. Nếu thấy tiến trình nằm trong 1 service thì hãy disable và stop service ấy lại còn nếu là tiến trình thì hãy dùng kill

## Lưu ý
Các bước trên chỉ đúng nếu thực sự hiểu và nhớ được các tiến trình cũng như các chương trình mà đã được cài trên user