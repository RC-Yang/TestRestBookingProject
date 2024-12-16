<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>

    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css">
    <script type="text/javascript" charset="utf8" src="https://code.jquery.com/jquery-3.5.1.js"></script>
    <script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <title>訂位紀錄更新頁面e</title>
    <script nonce="${nonce}">
        $(document).ready(function(){
            updateAvailableTimes();
            
            //20241216將session內的訂位時間，設定到下拉式選單的value
            $("#bookingTime").val('${bookingTime}');
		    //20241216將session內的訂位人數，設定到下拉式選單的value
		    $("#guestNum").val("${guestNum}");
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
            
            function bookingSubmit(){
    			var bookingForm = new FormData(document.getElementById('bookingForm'));
    			
    			$.ajax({
    				url: '/RestBookingProject/booking/updateReservation', 
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
	        <h5 class="modal-title">訂位修改成功</h5>
	      </div>
	      <div class="modal-body">
	        <p></p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" onclick="window.location.href = 'http://localhost:8080/RestBookingProject/booking/queryBooking'">確認</button>
	      </div>
	    </div>
	  </div>
	</div>

    <div class="container">
        <div class="row">
            <h2 style="padding-top:20px;text-align:center;">修改訂位</h2>
            <form class="row g-3" id="bookingForm">
            	<!-- 20241216為了修改資料而添加之屬性 -->
            	<input type="hidden" id="bookingId" name="bookingId" value="${bookingId}">
            	<input type="hidden" id="restId" name="restId" value="${restId}">

                <div class="col-md-12">
                  <label for="restName" class="form-label">訂位餐廳：</label>
                  <input type="text" class="form-control" id="restName" name="restName" value="${restName}" readonly>
                </div>
                <div class="col-md-5">
                  <label for="bookingDate" class="form-label">訂位日期：</label>
                  <input type="date" class="form-control" id="bookingDate" name="bookingDate" value="${bookingDate}">
                </div>
            
                <div class="col-md-5">
                  <label for="bookingTime" class="form-label">訂位時間：</label>
                  <select id="bookingTime" name="bookingTime" class="form-select">
                  </select>
                </div>
                <div class="col-md-2">
                  <label for="guestNum" class="form-label">訂位人數：</label>
                  <input type="text" class="form-control" id="guestNum" name="guestNum">
                </div>
                
                <div class="d-flex justify-content-center">
                  <button type="button" class="btn btn-primary" onclick="bookingSubmit();">修改</button>
                  &nbsp;&nbsp;
                  <button type="button" class="btn btn-danger" onclick="window.location.href='http://localhost:8080/RestBookingProject/booking/goToUpdateBookingRecord'">取消</button>
                </div>
                
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              </form>
        </div>
    </div>
</body>
</html>