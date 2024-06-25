<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css">
    <script type="text/javascript" charset="utf8" src="https://code.jquery.com/jquery-3.5.1.js"></script>
    <script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <title>訂位紀錄更新頁面e</title>
    <script>
        $(document).ready(function(){
            updateAvailableTimes();

            restName = localStorage.getItem('restName');
            bookingDate = localStorage.getItem('bookingDate');//input type="date"的資料值格式，為YYYY-MM-DD
            bookingTime = localStorage.getItem('bookingTime');
            guestNum = localStorage.getItem('guestNum');

            $("#restName").val(restName);
            $("#bookingDate").val(bookingDate);//值為YYYY-MM-DD的格式，正是input type="date"所需
            $("#bookingTime").val(bookingTime);
            $("#guestNum").val(guestNum);
        });

         //根據後端營業時間更新可選時間
         function updateAvailableTimes() {
                // 清空訂位時間下拉式選單內所有選項
                $("#bookingTime").empty();

                // 生成新的選項
                for (var hour = '10'; hour < '21'; hour++) {
                    for (var minute = 0; minute < 60; minute += 30) {
                        var formattedTime = padNumber(hour) + ':' + padNumber(minute);
                        var option = $('<option>').val(formattedTime).text(formattedTime);
                        $("#bookingTime").append(option);
                    }
                }
            }

            //將數字轉換為兩位數字的字符串
            function padNumber(num) {
                return num < 10 ? '0' + num : num;
            }
    </script>
</head>
<body>
    <div class="container">
        <div class="row">
            <h2 style="padding-top:20px;text-align:center;">修改訂位</h2>
            <form class="row g-3">
                <div class="col-md-12">
                  <label for="restName" class="form-label">訂位餐廳：</label>
                  <input type="text" class="form-control" id="restName">
                </div>
                <div class="col-md-5">
                  <label for="bookingDate" class="form-label">訂位日期：</label>
                  <input type="date" class="form-control" id="bookingDate">
                </div>
            
                <div class="col-md-5">
                  <label for="bookingTime" class="form-label">訂位時間：</label>
                  <select id="bookingTime" class="form-select">
                  </select>
                </div>
                <div class="col-md-2">
                  <label for="guestNum" class="form-label">訂位人數：</label>
                  <input type="text" class="form-control" id="guestNum">
                </div>
                
                <div class="d-flex justify-content-center">
                  <button type="submit" class="btn btn-primary">修改</button>
                  &nbsp;&nbsp;
                  <button type="button" class="btn btn-danger" onclick="window.location.href='http://localhost:8080/RestBookingProject/booking/goToUpdateBookingRecord'">取消</button>
                </div>
              </form>
        </div>
    </div>
</body>
</html>