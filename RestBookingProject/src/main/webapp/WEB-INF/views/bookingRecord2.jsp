<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/2.0.8/css/dataTables.bootstrap5.css">
    <script type="text/javascript" charset="utf8" src="https://code.jquery.com/jquery-3.5.1.js"></script>
    <script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/2.0.8/js/dataTables.js"></script>
    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/2.0.8/js/dataTables.bootstrap5.js"></script>
    <title>訂位紀錄更新/刪除頁面</title>
    <script>
        $(document).ready(function(){
            $("#bookingRecordTable").DataTable({
                columnDefs: [
                    { orderable: false, targets: [4,5] } // 設置禁用第4列和第5列的排序功能（索引從0開始）
                ],
                language: {
                    "lengthMenu": "一頁_MENU_筆", // 修改 "Entries per page" 這段預設文字
                }
            });
        });

        function deleteBookingRecord(formNumber){
            var bookingRecordForm = new FormData(document.getElementById('bookingRecordForm'+formNumber));
            $.post({
                url:'/RestBookingProject/form/deleteBookingRecord',
                data: bookingRecordForm,
                //以下兩行是針對FormData型別物件而添加
                processData: false,
                contentType: false,

                success:(data)=>{
                    $("#bookingRecordModal").modal('show');
                    $("#bookingRecordModal .modal-body p").text(data);
                },
                error:(data)=>{ 
                }
            });
        }
        function goToUpdateBookingRecordPage(restName,bookingDate,bookingTime,guestNum){
            localStorage.setItem('restName', restName);
            localStorage.setItem('bookingDate', bookingDate);
            localStorage.setItem('bookingTime', bookingTime);
            localStorage.setItem('guestNum', guestNum);

            window.location.href = "http://localhost:8080/RestBookingProject/form/goToUpdateBookingRecordPage";
        }
    </script>
    <style>
        #bookingRecordTable th,
        #bookingRecordTable td,h2 {
            text-align: center;
            vertical-align: middle;
        }
        h2{
            padding-top: 20px;;
        }
    </style>
</head>
<body>
    <div class="modal fade" tabindex="-1" id="bookingRecordModal" data-bs-backdrop="static"><!--點擊 Modal 外的背景不會關閉 Modal，且背景也不可被點擊-->
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Modal title</h5>
            </div>
            <div class="modal-body">
              <p></p>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                onclick="window.location.href = 'http://localhost:8080/RestBookingProject/booking/goToUpdateBookingRecord'">Close</button>
            </div>
          </div>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <h2>修改/刪除訂位</h2>
            <table id="bookingRecordTable" class="table table-striped table-borderd">
                <thead>
                    <tr>
                        <th>訂位餐廳</th>
                        <th>訂位日期</th>
                        <th>訂位時間</th>
                        <th>訂位人數</th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="bookingRecord" items="${bookingRecord}">
                        <c:set var="bookingTime" value="${bookingRecord.bookingTime}" /><!--要用jstl，對${bookingRecord.bookingTime}進行substring處理-->
                        <tr> 
                            <td>${bookingRecord.bookingRest.name}</td>
                            <td>${bookingRecord.bookingDate}</td>
                            <td>${fn:substring(bookingTime, 0, 5)}</td><!--${bookingRecord.bookingTime}-->
                            <td>${bookingRecord.guestNum}</td>
                            <td><button type="button" class="btn btn-success" onclick="goToUpdateBookingRecordPage(
                              '${bookingRecord.bookingRest.name}', '${bookingRecord.bookingDate}', '${fn:substring(bookingTime, 0, 5)}','${bookingRecord.guestNum}'
                            );">修改</button></td>
                            <td> 
                                <form action="" method="post" id="bookingRecordForm${bookingRecord.bookingId}" name="bookingRecordForm${bookingRecord.bookingId}">
                                    <input type="hidden" id="bookingRecordId" name="bookingRecordId" value="${bookingRecord.bookingId}"/>
                                    <button type="button" class="btn btn-danger" onclick="deleteBookingRecord('${bookingRecord.bookingId}');">刪除</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div style="text-align: center;">
                <button type="button" class="btn btn-secondary" onclick="window.location.href = 'http://localhost:8080/RestBookingProject/entry/goTologinSuccessForUser'">返回</button>
            </div>
        </div>
    </div>
</body>
</html>