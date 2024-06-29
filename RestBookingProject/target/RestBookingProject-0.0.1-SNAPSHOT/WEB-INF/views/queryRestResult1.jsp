<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.Base64" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>餐廳查詢結果</title>

    <!-- 引入 Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- 引入 Bootstrap JavaScript 和 jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <style>
        *{
            box-sizing: border-box;
            margin:0;
            padding:0;
        }
        .title{
            font-weight:bold;
            font-size: 36px;
            padding:15px;
        }
        .thumbnail{
            width:100%;
            height:93%;
            margin-top: 7%;
        }
        .thumbnail img{
            object-fit: cover;
        }
        .caption{
            text-align: center;

        }   
        
    </style>
</head>
<body>
    <div class="container">
        <div class="row">
            <div class="col-12 text-center title">餐廳查詢結果</div>
        </div>
        <div class="row">
            <div class="col-12 text-center py-3">您查詢的條件是：${country}的
			<c:forEach var="district" items="${districtList}">
				<!-- 输出数组的每个元素 -->
				${district}&nbsp;
			</c:forEach>
			的餐廳</div>
        </div>
    </div>
    <div class="container queryResult" id="queryResult">
        <div class="row">

            <!-- 呈顯動態資料區塊 start-->		
            <c:forEach items="${rests}" var="rest">
            <div class="col-md-4">
                <div class="thumbnail">
                    <a href="#" target="_blank">
                    <img src="data:image/jpeg;base64,${rest.imageList.get(0).restImage}" alt="Image" class="img-thumbnail w-100 h-75">
                    <div class="caption">
                    	<p>${rest.name}</p>
                        <p>${rest.address}</p>
                    </div>
                    </a>
                    
                    <!--製作按下按鈕後，彈出視窗效果-->
                    <div class="caption">
                    <button type="button" class="btn btn-primary"
                         data-toggle="modal" data-target="#exampleModal">餐廳詳細資訊</button>

                    <!-- Modal -->
                        <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">餐廳詳細資訊</h5>
                                
                                </div>
                                <div class="modal-body">
                                	<p>營業時間：</p>
									<p>${rest.openingTime}~${rest.closingTime}</p>
                                </div>
                                <div class="modal-footer">
									<form method="post" action="<%=request.getContextPath() %>/booking/goToBooking">
										<input type="hidden" name="restId" id="restId" value="${rest.id}">
										<input type="hidden" name="restName" id="restName" value="${rest.name}">
										<input type="hidden" name="restAddress" id="restAddress" value="${rest.address}">
										<input type="hidden" name="restOT" id="restOT" value="${rest.openingTime}">
										<input type="hidden" name="restCT" id="restCT" value="${rest.closingTime}">
										<input type="hidden" name="curDate" id="curDate" class="curDate" value="">
										
										<button type="submit" class="btn btn-primary btn-lg">訂位</button>
									</form>
									<button type="button" class="btn btn-secondary" data-dismiss="modal">關閉</button>
                                </div>
                            </div>
                            </div>
                        </div>
                    </div>
                    <!--製作按下按鈕後，彈出視窗效果結束-->
                </div>
            </div>
            </c:forEach>
            <!-- 呈顯動態資料區塊 end-->
        </div>  
    </div>

    <nav aria-label="Page navigation example">
        <ul class="pagination justify-content-center" style="margin:40px 20px;">
            <li class="page-item"><a class="page-link" href="#">Previous</a></li>
            <li class="page-item"><a class="page-link" href="#">1</a></li>
            <li class="page-item"><a class="page-link" href="#">2</a></li>
            <li class="page-item"><a class="page-link" href="#">3</a></li>
            <li class="page-item"><a class="page-link" href="#">Next</a></li>
        </ul>
    </nav>

    <script>
        //分頁功能
        $(document).ready(function(){
            var currentPage=1;
            var triggerPage=1;//選擇的頁碼
            var queryResultCount = $('.col-md-4').length;
            var queryResultPerPage =20;
            var maxPage=0;//最大可以選擇的頁碼

            if(queryResultCount/queryResultPerPage!=0){
                maxPage=(queryResultCount/queryResultPerPage)+1;//8/5==1，需要2頁
            }
            else if(queryResultCount/queryResultPerPage==0){
                maxPage=queryResultCount/queryResultPerPage;//20/5==4，需要4頁
            }
            
            //20240612新增動態產生分頁頁碼列表
            $(".pagination").find("li:not(:first,:last)").remove();
            for (var i = 1; i <= maxPage; i++) {
                $("<li class='page-item'><a class='page-link' href='#'>" + i + "</a></li>")
                    .insertBefore(".pagination li:last");
            }           
            $('.col-md-4').hide().slice(0,queryResultPerPage).show();//所有class名為col-md-4的元素通通隱藏，除了第0~4個元素

			//20240612新增動態找出現為哪一頁
            $('.pagination').on('click','.page-link',function(){//第二個參數是指某個指定父元素底下，所有匹配選擇器的子元素
                triggerPage = $(this).text();

                if(triggerPage=='Previous' && currentPage>1){
                    currentPage--;
                }
                else if(triggerPage=='Next' && currentPage<maxPage){
                    currentPage++;
                }
                else{
                    currentPage=triggerPage;
                }
                //呈顯當前頁數的資料；第1頁是1~5筆、第2頁是6~10筆......
                $('.col-md-4').hide().slice(currentPage*queryResultPerPage-queryResultPerPage,currentPage*queryResultPerPage).show();
            })
        })
    </script>
</body>
</html>