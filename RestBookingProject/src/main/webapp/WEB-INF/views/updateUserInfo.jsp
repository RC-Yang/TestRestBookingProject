<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>查詢餐廳頁面</title>
    <!-- 引入 Bootstrap CSS -->
    <!-- 引入 Bootstrap JavaScript 和 jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@2"></script>
    <style>
        header #title{
            text-align: center;
            padding:20px;
            font-size: 36px;
        }
        #userImg{
          width:100px;
          height:100px;
          /*為確保圖片可以正確呈顯重點，而非呈顯裁剪後或變形後之模樣*/
          object-fit: cover;/*可以將圖片內容的重點給呈顯出來，而非只是呈顯圖片的邊緣*/
        }
    </style>
    
</head>
<body>
    <header>
        <div id="title">修改餐廳資訊</div>
    </header>
    <main id="app">
        <div class="container">
            <form class="row g-3" style="padding:0 150px">
                <div class="col-md-6">
                <label for="inputEmail4" class="form-label">Email</label>
                <input type="email" class="form-control" id="inputEmail4" value="<c:out value='${user.email}'/>">
                </div>
                <div class="col-md-6">
                <label for="inputPassword4" class="form-label">Password</label>
                <input type="password" class="form-control" id="inputPassword4" value="<c:out value='${user.password}'/>">
                </div>

                <div class="col-md-3">
                  <label for="inputCity" class="form-label">City</label>
                  <select id="inputCity" class="form-select" v-if="Object.keys(allCity).length > 0" v-model="selectedCityOption"><!--v-model用於实现双向绑定；v-model的值就是該html元素之值-->
                      <option v-for="(value, key) in allCity" v-bind:value="value">{{value}}</option>
                      <!--Vue.js 会将第一个参数视为当前项的值，第二个参数视为当前项的键，而没有提供第三个参数时，默认情况下并不会将它视为索引-->
                      <!--"value"跟{{value}}，都是來自(value, key)的value-->
                      <!--v-bind:value的value，等於option 元素的 value 属性-->
                  </select>
                </div>
                <div class="col-md-3">
                  <label for="inputDistrict" class="form-label">District</label>
                  <select id="inputDistrict" class="form-select" v-if="Object.keys(this.districts).length > 0" v-model="selectedDistrictOption">
                      <option v-for="(value, key) in districts" :value="value">{{value}}</option>
                  </select>
                </div>

                <div class="col-6">
                <label for="inputAddress" class="form-label">Address</label>
                <input type="text" class="form-control" id="inputAddress" placeholder="" 
                      value="<c:out value='${address}'/>">
                </div>

                <div class="col-md-3">
                  <label for="userImg" class="form-label">餐廳圖片</label>
                    <!-- 使用img標籤，src屬性包含base64圖片字串 -->
                    <img id="userImg" src="data:image/jpeg;base64,<c:out value='${picture}'/>" alt="Base64 Image" class="img-fluid">
                </div>
                <div class="col-md-9">
                  <label for="imageFile" class="form-label">修改餐廳圖片：</label>
                  <input type="file" class="form-control" id="imageFile">
                </div>

                <div class="col-12 d-flex justify-content-center gap-2">
                    <button type="submit" class="btn btn-primary">確認</button>
                    <button type="button" class="btn btn-danger" onclick="history.go(-1);">取消</button>
                </div>
            </form>
        </div>
    </main>
    <script nonce="${nonce}">
      new Vue({
        el: '#app',
        data() {
  			return {
    			allCity:{},
    			districts:{},
    			selectedCityOption:'',
    			selectedDistrictOption:''
  			}
        },
        methods: {
            loadAllCity(){
              $.ajax({
                url:"/RestBookingProject/form/queryAllCity",
                method:"get",
                success:(data) => {//data 是一個純粹的JavaScript物件，object型別的可迭代對象
                    this.allCity=data;//這個allCity，資料面是map，但型別卻是object，但对象类型并不是一个可迭代对象
                    
                    var allCityForFindSelectedOption = new Map(Object.entries(data));//Object.entries()回傳的是array，將其作為參數添加到new Map()裡，即可產生可迭代之物件
                    //補充：Object.keys()也是回傳的是array

					//如果你传递一个对象类型的可迭代对象，它不会直接被接受，因为对象类型并不是一个可迭代对象
                    var defaultOption = Array.from(allCityForFindSelectedOption).find(function([value, label]){
                    	return label === "<c:out value='${userCity}'/>";
                    });
                    //find函數可對可迭代對象進行遍歷，其參數是回調函數，而回調函數的參數是可迭代對象的元素
    				//当find函数找到符合条件的元素时，它会立即停止迭代，并返回该符合条件的元素
    				//補充：foreach()其參數也是回調函數

                    if (defaultOption) {
                      this.selectedCityOption = defaultOption[1];
                    }
                },
                error:(error) => {

                }
              });
            },
            loadInitialDistricts(){
              $.ajax({
                url:"/RestBookingProject/form/queryDistrict",
                method:"get",
                data:"country="+encodeURIComponent("<c:out value='${userCity}'/>"),
                success:(data) => {
                    this.districts=data;
                    var allDistrictsForFindSelectedOption = new Map(Object.entries(data));//這個allCity，資料面、型別都是map

                    var defaultOption = Array.from(allDistrictsForFindSelectedOption).find(([value, label]) => label === 
                    "<c:out value='${userDistrict}'/>");
    
                    if (defaultOption) {
                      this.selectedDistrictOption = defaultOption[1];
                    }
                },
                error:(error) => {

                }
              });
            }
        },
        mounted() {
          this.loadAllCity();
          this.loadInitialDistricts();
        },
      });    
  </script>
</body>
</html> 