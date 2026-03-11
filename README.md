# Macroeconomic Risk Correlation Analysis (VAR Model)

## Project Overview
Nghiên cứu và định lượng mối quan hệ tương quan động giữa chỉ số VN-Index và tỷ giá USD/VND. Dự án tập trung vào việc xác định các rủi ro hệ thống từ yếu tố vĩ mô và mô phỏng các kịch bản sốc thị trường phục vụ quản trị rủi ro tài chính.

## Methodology
Dự án sử dụng ngôn ngữ R với quy trình kiểm định kinh tế lượng bao gồm:

1. **Data Transformation**: Xử lý dữ liệu thô thành chuỗi thời gian (Time Series), bắt đầu từ năm 2015.
2. **Stationarity Check**: Sử dụng kiểm định ADF (Augmented Dickey-Fuller) và xử lý sai phân bậc 1 để triệt tiêu tính không dừng.
3. **Lag Selection**: Xác định độ trễ tối ưu thông qua tiêu chí AIC/SC, đảm bảo tính cân bằng giữa độ chính xác và độ phức tạp của mô hình.
4. **VAR Estimation**: Ước lượng mô hình tự hồi quy vector để đánh giá tương quan đa chiều.

## Risk & Post-Estimation Tests
Các bước kiểm soát chất lượng mô hình để đảm bảo tính ứng dụng trong thực tế:

| Kiểm định | Mục đích | Hàm thực thi |
| :--- | :--- | :--- |
| Stability Test | Kiểm tra tính ổn định của hệ thống trong dài hạn | roots() |
| Serial Correlation | Kiểm tra hiện tượng tự tương quan phần dư | serial.test() |
| ARCH Test | Kiểm tra biến động phương sai (Volatility) | arch.test() |
| Granger Causality | Xác định quan hệ nhân quả và tín hiệu dự báo sớm | causality() |

## Financial Insights
- **Impulse Response Function (IRF)**: Stress Testing - Phân tích phản ứng của thị trường chứng khoán trước các cú sốc tỷ giá.
- **Forecasting**: Dự báo xu hướng biến động trong ngắn và trung hạn với khoảng tin cậy 95%.

## Technical Stack
- Language: R
- Key Libraries: vars, tseries, ggplot2, gridExtra, readr

## Project Structure
- VAR_VNIndex_USDVND.R: Source code xử lý mô hình.
- vn_usd_var_data.csv: Dataset chỉ số vĩ mô.
- README.md: Tài liệu dự án.

---
