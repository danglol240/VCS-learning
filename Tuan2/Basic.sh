#!/bin/bash
# Nên bắt đầu bằng shebang như trên mục đích để cho hệ điều hành xác định sẽ sử dụng bash nào để xử lý các câu lệnh

# 1. Using variables
# Lưu ý về cách đặt tên biến phải bắt đầu bằng chữ cái (A-Z) hoặc _
# Define variables
num1="24"
name1="dang"
# Access variables, readonly variables, unset variable
echo "$num1 $name1"

# 2. Special variables
# ================== Biến đặc biệt trong Bash ==================
# $0   : Tên file hoặc script đang thực thi
# $n   : Tham số theo vị trí (ví dụ $1, $2, ... là các tham số truyền vào script)
# $#   : Số lượng tham số được truyền vào script
# $*   : Tất cả tham số truyền vào (gộp thành một chuỗi duy nhất)
# $@   : Tất cả tham số truyền vào (giữ riêng từng tham số)
# $?   : Mã thoát (exit status) của lệnh cuối cùng (0 = thành công, khác 0 = lỗi)
# $$   : PID (Process ID) của shell hoặc script hiện tại
# $!   : PID của tiến trình chạy nền (background) gần nhất
#
# ===== Một số biến đặc biệt khác trong Bash =====
# $-        : Các tùy chọn/switch đang bật trong shell hiện tại
# $_        : Tham số cuối cùng của lệnh trước đó
# $IFS      : Internal Field Separator (ký tự phân tách, mặc định là khoảng trắng)
# $LINENO   : Số dòng hiện tại trong script
# $BASH_SOURCE : Tên file script hiện tại
# $FUNCNAME    : Tên hàm đang được gọi
echo "File Name: $0"
echo "First Parameter : $1"
echo "Second Parameter : $2"
echo "Quoted Values: $@"
echo "Quoted Values: $*"
echo "Total Number of Parameters : $#"
echo $?

# 3. Using Arrays
# Access all the item in the array using * or @ E.g: NAME[*]
NAME[0]="Dang"
NAME[1]="Khanh"
NAME[2]="VAnh"
NAME[3]="Huy"
echo "First Index: ${NAME[0]}"
echo "Second Index: ${NAME[1]}"

# 4. Basic Operators
