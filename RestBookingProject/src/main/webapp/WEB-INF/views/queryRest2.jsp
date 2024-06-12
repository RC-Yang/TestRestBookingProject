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
	<script src="https://cdn.jsdelivr.net/npm/vue@2"></script>
    
    <script>
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
	<div class="container" id="app">
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
				<form action="<%=request.getContextPath() %>/rest/queryRests" method="post">
				  <!-- 第一層的checkbox list -->
				  <div id="countryList">
						<div v-for="(value, key) in country" class="form-check">
							<input class="form-check-input" type="checkbox" :value="value" @change="handleCheckedCountry" name="country">
							<label class="form-check-label">{{ value }}</label>
						</div>
					</div>
				
				  <!-- 第二層的checkbox list -->
				  <div id="districtList" v-if="Object.keys(districts).length > 0">
						<div v-for="(value, key) in districts" class="form-check"><!--:value指的是input 元素的 value 属性，而"value"指的是当前迭代中的 value-->
							<input class="form-check-input" type="checkbox" :value="value" 
								v-model="checkedDistrict[key]" @change="handleCheckedDistrict(key)" name="district" id="district">
								<!--v-model在checkbox被勾選時被設定為true，接著透過雙向綁定，將值傳給checkedDistrict[key]-->
							<label class="form-check-label">{{ value }}</label>
						</div>			
				  </div>

				  <div id="districtButtonList" v-if="Object.entries(allDistricts).length > 0"><!--這是一個以一個個key-value對構成的二維陣列，並非map-->
						<!--預設可以呈顯全部縣市行政區的button，只是會根據v-if判斷是否要呈顯-->
						<button v-for="(value, key) in allDistricts" v-if="showButton[key]" class="btn btn-primary">{{ value }}</button>
						<div v-for="(value, key) in allDistricts" class="form-check">
							<input type="hidden" :disabled="!showButton[key]" name="checkedDistrict" :value="value"/>
						</div>
					</div>
					
					<div class="text-center">
						<button type="submit" class="btn btn-primary">查詢餐廳</button>
						<button type="button" class="btn btn-danger" onclick="javascript:history.back();">取消</button>
					</div>
				</form>
			</div>
		</div>
    </div>
	<script>
		new Vue({
			el: '#app',
			data: {
				country: {
					臺北市: '臺北市',
					新北市: '新北市',
					基隆市: '基隆市',
					桃園市: '桃園市',
					新竹市: '新竹市',
					新竹縣: '新竹縣'
				},
				checkedCountry: [],
				districts: {},//這是原生js物件//在 Vue.js 中，物件的屬性可以通過方括號 [] 來訪問
				allDistricts:{},//表示全部縣市的行政區
        		checkedDistrict: [],//表示被選取縣市的行政區
				showButton:[]//這物件與「全部縣市的行政區」綁定
			},
			//20240306新增
			//onready事件發生後，就執行的區塊
			//mounted階段相當於發生onready事件後的階段
			mounted() {
				this.loadAllDistricts();
				//20240417新增
				checkedDistrict=new Array(999).fill(false);
				showButton=new Array(999).fill(false);
			},
			methods: {
				handleCheckedCountry(event) {
					this.loadDistricts(event);
				},
				loadDistricts(event){
					//因vue.js不能用this來表示觸發事件的元素，故以event.target.value取代jQUery的$(this).val()
					var selectedCountry = event.target.value;
					var queryStringData = 'country=' + encodeURIComponent(selectedCountry);

					$.ajax({
						url: '/RestBookingProject/form/queryDistrict',
						method: 'GET',
						data: queryStringData,
						success: (data) => {
							// 將獲取的包含key value的原生js物件，assign給districts這個原生js物件
							this.districts = data;
						},
						error: (error) => {
							console.error('Error fetching second layer options:', error);
						}
            		});
				},
				loadAllDistricts(){			
					$.ajax({
						url: '/RestBookingProject/form/queryAllDistricts',
						method: 'GET',
						success: (data) => {
							//this.allDistricts = data;//這作法不好
							//20240417更新
							dataMap = new Map(Object.entries(data));
							dataMap.forEach((value,key) => {//不可寫成(key,value)
								this.$set(this.allDistricts, key, value);
							});
						},
						error: (error) => {
							console.error('Error fetching second layer options:', error);
						}
            		});
				},
				handleCheckedDistrict(key){
					//this.showButton[key] = !this.showButton[key];
					this.showButton[key] = this.checkedDistrict[key];
					//倒轉vue變數；再利用v-if的雙向綁定功能，間接設定html button的樣式
				}		
			}
			// other options here
		});
	</script>
</body>
</html>