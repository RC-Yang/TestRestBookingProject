<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.Base64" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>餐廳查詢結果</title>

    <!-- 引入 Bootstrap JavaScript 和 jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
	<!-- 20240819新增 -->
	<!-- Bootstrap 5 CSS -->
	<link
	  href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	  rel="stylesheet"/>
	<!-- Vue 3 -->
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<!-- Bootstrap 5 JavaScript (optional, for Bootstrap's JS components) -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<!-- BootstrapVue CSS -->
	<link href="https://unpkg.com/bootstrap-vue@2.21.2/dist/bootstrap-vue.css" rel="stylesheet">	
	<!-- Vue 2.x -->
	<script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>	
	<!-- BootstrapVue JavaScript -->
	<script src="https://unpkg.com/bootstrap-vue@2.21.2/dist/bootstrap-vue.js"></script>
	
	<meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>

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
            <div class="col-12 text-center py-3" id="queryCondition">您查詢的條件是：位於
				<c:forEach var="district" items="${checkedDistrictList}" varStatus="status">
					${district}<c:if test="${!status.last}">、</c:if>
				</c:forEach>
			的餐廳
			</div>
        </div>
    </div>
    <div class="container queryResult" id="queryResult">
        <div class="row" id="app"><!-- Vue物件控制範圍 -->

            <!-- 呈顯動態資料區塊 start-->		
            <c:forEach items="${rests}" var="rest" varStatus="status">
            <div class="col-md-4" v-show="showItem('${status.index}')">
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
                         data-bs-toggle="modal" data-bs-target="#restModal${status.index}">餐廳詳細資訊</button>

                    <!-- Modal -->
                        <div class="modal fade" id="restModal${status.index}" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
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
										<input type="hidden" name="_csrf" value="${_csrf.token}"/>
										 
										<input type="hidden" name="restId" id="restId" value="${rest.id}">
										<input type="hidden" name="restName" id="restName" value="${rest.name}">
										<input type="hidden" name="restAddress" id="restAddress" value="${rest.address}">
										<input type="hidden" name="restOT" id="restOT" value="${rest.openingTime}">
										<input type="hidden" name="restCT" id="restCT" value="${rest.closingTime}">
										<input type="hidden" name="curDate" id="curDate" class="curDate" value="">
										
										<button type="submit" class="btn btn-primary btn-lg">訂位</button>
									</form>
									<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">關閉</button>
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
            <!-- 20240819新增 -->
            <div class="d-flex justify-content-center"><!-- 讓頁碼清單置中 -->
	            <!-- v-model 將 currentPage 與 <b-pagination> 的當前頁碼給雙向綁定，
	            從而引發Vue物件內，函數{}內含的currentPage被更新，這讓該函數會重新執行 -->
	            <b-pagination
		            v-model="currentPage"
		            :total-rows="totalItems"
		            :per-page="itemsPerPage"
		            :page-range="10"
		            :next-text="'Next'"
		            :prev-text="'Previous'"
		        ></b-pagination>
	        </div>
	        <div class="d-flex justify-content-center">
	        	<button type="button" class="btn btn-danger" id="turnToHomeButton">回首頁</button>
	        </div>
        </div>  
    </div>

    <script nonce="${nonce}">
        //為實作分頁功能而new Vue物件
        new Vue({//Vue 2的new Vue()；在Vue 3要用Vue.createApp，不可使用new Vue()
			el: '#app',//要將該vue物件跟該id範圍進行綁定
			data(){
				return{
					currentPage:1,
					totalItems:document.querySelectorAll("#queryResult .col-md-4").length,
					itemsPerPage:20
				};//跟一般寫法是return XXX;這樣的意思一樣
			},
			methods:{
				//只要currentPage的值發生變化，該函數，這樣的話，跟v-if、v-show綁定的函數都會被執行。故該函數便會重新執行
				showItem(index){
					if(index>=(this.currentPage-1)*this.itemsPerPage&&
							index<this.currentPage*this.itemsPerPage){
						return true;
					}
					return false;
				}
			}
        });
    </script>
   
	<script nonce="${nonce}">
	 	<!-- 20240901新增返回首頁按鈕 -->
		document.getElementById('turnToHomeButton').addEventListener("click",function(){
			window.location.href = 'http://localhost:8080/RestBookingProject/entry/login';
		});
		<!--20241215處理queryCondition文字區域多餘空白之問題-->
		document.getElementById('queryCondition').textContent=
			document.getElementById('queryCondition').textContent.replace(/\s+/g, "").trim();
	</script>
</body>
</html>