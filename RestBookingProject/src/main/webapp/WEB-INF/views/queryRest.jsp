<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>查詢餐廳頁面</title>
    <!-- 引入 Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- 引入 Bootstrap JavaScript 和 jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <script>
    	$(document).ready(function(){
    		// 監聽第一層radio的change事件
    		$('input[name="country"]').change(function() {
    		  // 獲取被選中的radio的值
    		  var selectedCountry = $(this).val();

    		  // JQuery ajax參數只吃字串或javascript原生物件
    		  //要串出字串，其中中文編碼要編碼為UTF-8
    		  var queryStringData = 'country=' + encodeURIComponent(selectedCountry);

    		  // 發送AJAX請求向後端取得第二層checkbox list的資料
    		  $.ajax({
    		    url: '/RestBookingProject/form/queryDistrict', 
    		    method: 'GET',
    		    data: queryStringData, // 使用string形式的資料
    		    success: function(data) {//後端的hashMap，回到前端轉型為javascript字串物件
					// 清空原有的districtList
					$('#districtList').empty();
					
					// 要获取javascript对象的所有鍵值對，不能直接用data.length。因為data只是字串，並非array
					// 要获取javascript对象的所有key，以使用for loop將鍵對應的值一一取出
					//使用Object.keys取出物件的所有key，這樣這些key會被包含在一個array內
					//這樣就可使用for loop將key一一取出
					var keys = Object.keys(data);
					var key = null;
					var value = null; 
					
					// 遍历键名，访问相应的属性值
					for (var i = 0; i < keys.length; i++) {
					    key = keys[i];
					    value = data[key];
					
					  $('#districtList').append(//添加子元素
						'<div class="form-check">'+
						'<input class="form-check-input" type="checkbox" id="district" name="district" value="'+value+'">'
						+'<label class="form-check-label">'
						+value+
						'</label>'+
						'</div>'
					  );
					}
    		    },
    		    error: function() {
    		      console.log('無法從後端獲取資料');
    		    }
    		  });
    		});
   		
    	});
    </script>
	<style>
		*{
			box-sizing:border-box;
		}

		.headerImgDiv{
            width:100%;
            /*調整子物件版面step1*/
            display:flex!important;/*必須要加!important，不知為何*/
            /*調整子物件版面step2*/
            justify-content:space-around;
            align-items: center;
            
            /*去除圖片上下方多餘空白*/
            display:inline-block;
            margin-top:-202px;
            margin-bottom:-202px;
            
        }
        .headerImgDiv .headerimg{
            /* 變形圖片當中的縮放圖片 */
            transform:scale(1,0.7);
        }
        .headerImgDiv .headerUserImg{
        	transform: scale(0.3, 0.3);
        }

		body{
			height:100vh;
		}
		.container{
			height:40%;
		}
		.row{
			height:100%;
		}
		.form-check{
			display:inline-block;
		}
		#queryRestArea{
			height:100%;
			margin: 0 auto;
		}
		#title{
			padding:20px;
			font-size:36px;
			text-align:center;
		}
		#countryList,#districtList{
			display:flex;
			align-items: center;
			justify-content: space-around;
		}
	</style>
</head>
<body>
	<div class="container">
        <div class="row">
			<div class="headerImgDiv">
				<img src="<%=request.getContextPath() %>/image/photo1.png" class="headerimg">
				<div>
					你好，${account}~~~
					<img src="data:image/jpeg;base64,${userImage}" alt="Image" class="headerUserImg">
					<a href="<%=request.getContextPath() %>/entry/logout">登出</a>
				</div>
			</div>
			<div id="queryRestArea">
				<div id="title">查詢餐廳</div>
				<div class="accordion" id="accordionExample">
					<div class="accordion-item">
					  <h2 class="accordion-header" id="headingOne">
						<button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
						  依餐廳地點
						</button>
					  </h2>
					  <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
						<div class="accordion-body">
						  	<!--使用動態checkbox選擇餐廳地點-->
						  	<form action="<%=request.getContextPath() %>/rest/queryRests" method="post">
								<!-- 第一層的radio list -->
								<div id="countryList">
								
									<div class="form-check">
									<input class="form-check-input" type="radio" name="country" value="臺北市" checked> 
									<label class="form-check-label">
										臺北市
									</label>
									</div>
									<div class="form-check">
									<input class="form-check-input" type="radio" name="country" value="新北市">
									<label class="form-check-label">
										新北市
									</label>
									</div>
									<div class="form-check">
									<input class="form-check-input" type="radio" name="country" value="基隆市"> 
									<label class="form-check-label">
										基隆市
									</label>
									</div>
									<div class="form-check">
									<input class="form-check-input" type="radio" name="country" value="桃園市">
									<label class="form-check-label">
										桃園市
									</label>
									</div>
									<div class="form-check">
									<input class="form-check-input" type="radio" name="country" value="新竹市"> 
									<label class="form-check-label">
										新竹市
									</label>
									</div>
									<div class="form-check">
									<input class="form-check-input" type="radio" name="country" value="新竹縣">
									<label class="form-check-label">
										新竹縣
									</label>
									</div>
								</div>
		  
						  
								<!-- 第二層的checkbox list -->
								<div id="districtList">
								<c:forEach var="district" items="${districtMap}">
									<div class="form-check">
										<input class="form-check-input" type="checkbox" name="district" value="<c:out value='${district.value}'/>"/> 
										<label class="form-check-label">
											<c:out value="${district.value}"/>
										</label>
									</div>
								</c:forEach>				
								</div>
							  
								<div class="text-center">
									<button type="submit" class="btn btn-primary">查詢餐廳</button>
									<button type="button" class="btn btn-danger" onclick="javascript:history.back();">取消</button>
								</div>
						  	</form>
							<!--使用動態checkbox選擇餐廳地點結束-->
						</div>
					  </div>
					</div>
					<div class="accordion-item">
						<h2 class="accordion-header" id="headingTwo">
						<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
							依餐廳類型
						</button>
						</h2>
						<div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
							<div class="accordion-body">
								<!--使用動態checkbox選擇餐廳風格-->
								<div id="styleList">
									<c:forEach var="district" items="${districtMap}">
										<div class="form-check">
											<input class="form-check-input" type="checkbox" name="style" value="<c:out value='${district.value}'/>"/> 
											<label class="form-check-label">
												<c:out value="${district.value}"/>
											</label>
										</div>
									</c:forEach>				
								</div>
							</div>
						</div>
					</div>
					<div class="accordion-item">
					  <h2 class="accordion-header" id="headingThree">
						<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
						  依訂位人數
						</button>
					  </h2>
					  <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#accordionExample">
						<div class="accordion-body">
						  <strong>This is the third item's accordion body.</strong> It is hidden by default, until the collapse plugin adds the appropriate classes that we use to style each element. These classes control the overall appearance, as well as the showing and hiding via CSS transitions. You can modify any of this with custom CSS or overriding our default variables. It's also worth noting that just about any HTML can go within the <code>.accordion-body</code>, though the transition does limit overflow.
						</div>
					  </div>
					</div>
				</div>
			</div>
		</div>
    </div>
</body>
</html>