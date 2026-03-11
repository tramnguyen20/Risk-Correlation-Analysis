
# ---------------------------------------------------------
# VAR MODEL WITH VN-INDEX AND USD/VND EXCHANGE RATE
# ---------------------------------------------------------

# 1. LOAD LIBRARIES
if (!require("vars")) install.packages("vars")
if (!require("tseries")) install.packages("tseries")
if (!require("readr")) install.packages("readr")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("gridExtra")) install.packages("gridExtra")

library(vars)
library(tseries)
library(readr)
library(ggplot2)
library(gridExtra)

# 2. IMPORT DATA
data <- read_csv("vn_usd_var_data.csv")

# 3. TRANSFORM TO MONTHLY TIME SERIES
ts_data <- ts(data[, -1], start = c(2015, 1), frequency = 12)

# Chọn tất cả các cột của data trừ cột đầu tiên (thường là Date), 
# Chuyển phần dữ liệu (loại bỏ cột Date) thành chuỗi thời gian monthly bắt đầu từ tháng 1/2015
# Dấu -1 có nghĩa là bỏ cột thứ nhất.
# Hàm ts() là tạo đối tượng chuỗi thời gian trong R.
# start = c(2015, 1): Chỉ định thời điểm bắt đầu của chuỗi thời gian: tháng 1 năm 2015.
# frequency = 12: Thiết lập tần suất (số kỳ trong một đơn vị) là 12 kỳ mỗi năm, tức là dữ liệu theo tháng.
# Nếu dữ liệu theo quý thì dùng frequency = 4; còn nếu theo ngày thì nên dùng xts hoặc zoo thay vì ts.

# 4. CHECK STATIONARITY WITH ADF TEST
adf.test(ts_data[, "VNINDEX"])
adf.test(ts_data[, "USDVND"])

# If not stationary, difference the data
ts_diff <- diff(ts_data)

# Re-check ADF
adf.test(ts_diff[, "VNINDEX"])
adf.test(ts_diff[, "USDVND"])

# 5. VAR MODEL ESTIMATION
# Chọn độ trễ tối ưu (lag) bằng VARselect() với tiêu chí AIC, HQ, SC.
lag_selection <- VARselect(ts_diff, lag.max = 12, type = "const")
lag_selection$selection

# Tham số:
# ts_diff: là dữ liệu chuỗi thời gian đã được lấy sai phân (để đảm bảo tính dừng).
# lag.max = 12: kiểm tra tối đa đến 12 độ trễ (p = 1 đến 12).
# type = "const": mô hình có hằng số (intercept) – tức là giả định chuỗi có trung bình khác 0.

# Fit VAR with selected lag
var_model <- VAR(ts_diff, p = lag_selection$selection["AIC(n)"], type = "const")
summary(var_model)

# Khắc phục lỗi mô hình VAR:

# Tạo chuỗi sai phân và loại bỏ NA
ts_diff <- na.omit(diff(ts_data))

# Kiểm tra lag tối ưu với giới hạn nhỏ hơn nếu dữ liệu ít
lag_selection <- VARselect(ts_diff, lag.max = 1, type = "const")

# Ước lượng lại mô hình VAR
var_model <- VAR(ts_diff, p = lag_selection$selection["AIC(n)"], type = "none")
summary(var_model)

# 6. CÁC KIỂM ĐỊNH HẬU KIỂM MÔ HÌNH VAR

# 6.1 KIỂM ĐỊNH ỔN ĐỊNH
roots(var_model, modulus = TRUE)

# 6.2. TỰ TƯƠNG QUAN PHẦN DƯ
serial.test(var_model, lags.pt = 12, type = "PT.asymptotic")

# 6.3. PHƯƠNG SAI THAY ĐỔI (ARCH)
arch.test(var_model, lags.multi = 5)

# 6.4. PHÂN PHỐI CHUẨN PHẦN DƯ
normality.test(var_model)

# 7. GRANGER CAUSALITY TEST
causality(var_model, cause = "VNINDEX")
causality(var_model, cause = "USDVND")

# 8. IMPULSE RESPONSE FUNCTION (IRF)
# Cách 1: Vẽ trực tiếp
irf_plot <- plot(irf(var_model, impulse = "USDVND", response = "VNINDEX", n.ahead = 12, boot = TRUE))

# Cách 2:
library(vars)
irf_result <- irf(var_model, impulse = "USDVND", response = "VNINDEX", n.ahead = 12, boot = TRUE)
plot(irf_result)

# Impulse = USDVND: gây ra một cú sốc (shock) trong tỷ giá USD/VND.
# Response = VNINDEX: đo lường phản ứng của chỉ số VN-Index.
# n.ahead = 12: quan sát ảnh hưởng trong 12 tháng tiếp theo.
# boot = TRUE: sử dụng bootstrap để tính khoảng tin cậy.

# 9. FORECAST
forecast <- predict(var_model, n.ahead = 6, ci = 0.95)
par(mar = c(3, 3, 2, 1))
plot(forecast)

# 10. FEVD (Forecast Error Variance Decomposition)
fevd(var_model)
