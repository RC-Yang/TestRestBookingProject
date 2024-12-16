<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
    
    <!-- 引入 Bootstrap CSS -->
    <!-- 引入 Bootstrap JavaScript 和 jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>
	<title>餐廳訂位系統</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        header {
            background-color: #333;
            color: #fff;
            text-align: center;
            padding: 1em;
        }
        main {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
        }
        input, select {
            width: 100%;
            padding: 8px;
            margin-bottom: 16px;
            box-sizing: border-box;
        }
        #confirm {
            background-color: #4caf50;
            color: #fff;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }
        #confirm:hover {
            background-color: #45a049;
        }
		#cancel {
            background-color: red;
            color: #fff;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }
		#cancel:hover {
            background-color: lightpink;
        }
    </style>
	<script>
        $(document).ready(function() {

            // 從後端傳回的營業時間資訊
            var businessHours = {
                openingTime: '${restOT}'.substring(0, 2), 
                closingTime: '${restCT}'.substring(0, 2)  
            };

            // 初始化可選時間
            initAvailableTimes(businessHours);

            // 函數：根據後端營業時間更新可選時間
            function initAvailableTimes(businessHours) {
                // 清空訂位時間下拉式選單內所有選項
                $("#time").empty();

                // 生成新的選項
                for (var hour = businessHours.openingTime; hour < businessHours.closingTime; hour++) {
                    for (var minute = 0; minute < 60; minute += 30) {
                        var formattedTime = padNumber(hour) + ':' + padNumber(minute);
                        var option = $('<option>').val(formattedTime).text(formattedTime);
                        $("#time").append(option);
                    }
                }
            }

            // 函數：將數字轉換為兩位數字的字符串
            function padNumber(num) {
                return num < 10 ? '0' + num : num;
            }
			//20240129新增
			document.getElementById('date').min = new Date().toISOString().split('T')[0];
        });
		function bookingSubmit(){
			var bookingForm = new FormData(document.getElementById('bookingForm'));
			
			$.ajax({
				url: '/RestBookingProject/booking/makeReservation', 
				method: 'POST',
				data: bookingForm,
				//若傳送的是FormData物件，以下兩行必須添加
				processData: false,
				contentType: false,
				success: function(data) {
					$('#bookingSuccessModal.modal').addClass('fade');
					$('#bookingSuccessModal.modal').modal('show');
					$('#bookingSuccessModal .modal-body').html("<p>"+data+"</p>");
				},
				error: function() {
					console.log('無法從後端獲取資料');
				}
			});
		}
    </script>
</head>
<body>
	<div id="bookingSuccessModal" class="modal fade" tabindex="-1">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">訂位成功</h5>
	      </div>
	      <div class="modal-body">
	        <p></p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" data-bs-dismiss="modal" data-dismiss="modal">確認</button>
	      </div>
	    </div>
	  </div>
	</div>
    <header>
        <h1>${restName}訂位</h1>
    </header>
    <main>
        <form id="bookingForm">
			<label for="name">姓名：</label>
            <input type="text" id="name" name="name" required>

            <label for="phone">電話號碼：</label>
            <input type="tel" id="phone" name="phone" required>

            <label for="date">訂位日期：</label>
            <input type="date" id="date" name="date" required>

            <label for="time">訂位時間：</label>
            <select id="time" name="time" required></select>

            <label for="guests">人數：</label>
            <select id="guests" name="guests" required>
                <option value="1">1 人</option>
                <option value="2">2 人</option>
                <option value="3">3 人</option>
                <option value="4">4 人</option>
                <option value="5">5 人</option>
                <option value="6">6 人</option>
            </select>

            <button id="confirm" type="button" onclick="bookingSubmit();">提交訂位</button>
			&nbsp;
			<button id="cancel" type="button" onclick="javascript:history.back();">取消</button>
			&nbsp;
			<button id="confirm" type="button" onclick="window.location.href = 'http://localhost:8080/RestBookingProject/entry/goTologinSuccessForUser'">返回首頁</button>
			<input type="hidden" id="restId" name="restId" value="${restId}">
			<input type="hidden" id="restName" name="restName" value="${restName}">
        
        	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </form>
    </main>
</body>
</html>