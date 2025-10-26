<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>查詢餐廳頁面</title>
    <!-- 引入 Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
    <!-- 引入 Bootstrap JavaScript 和 jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>
	
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-vue@2.23.1/dist/bootstrap-vue.min.css">
	<script src="https://cdn.jsdelivr.net/npm/vue@2"></script>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap-vue@2.23.1/dist/bootstrap-vue.min.js"></script>
	
    <!-- 20240809新增CSRF參數 -->
	<meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body>
<div class="container" id="app">
		 <b-form
			  action="<%=request.getContextPath()%>/rest/queryRests"
			  method="post" class="d-flex flex-column justify-content-center align-items-center vh-100">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		<div class="accordion w-50" id="accordionExample">
		  <div class="accordion-item">
		    <h2 class="accordion-header" id="headingOne">
		      <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
		        依地區選擇餐廳
		      </button>
		    </h2>
		    <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
		      <div class="accordion-body">
			      	<b-form-group>
						<b-form-checkbox-group v-model="cityId"
						    :options="cityOptions"
						     value-field="id"
							 text-field="countryName"
						    @change="loadDistricts" style="column-count:3;">
						</b-form-checkbox-group>	             
		             	<hr>
		             	<b-form-checkbox-group v-model="districtId"
			               :options="districtOptions"
			               	value-field="districtId"
		  					text-field="districtName" style="column-count:3;"
		  					name="districtId">
	  					</b-form-checkbox-group>
	  					
	  				</b-form-group>
  				<b-badge 
		           v-for="opt in selectedOptions" 
		          :key="opt.districtId"
		           class="badge bg-primary mx-1"
		        >{{opt.countryName}}{{opt.districtName}}
		        </b-badge>
		        
		      </div>
		    </div>
		  </div>
		  <div class="accordion-item">
		    <h2 class="accordion-header" id="headingTwo">
		      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
		        依風格選擇餐廳
		      </button>
		    </h2>
		    <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
		      <div class="accordion-body">
		      </div>
		    </div>
		  </div>
		</div>
		<b-button type="submit" class="btn btn-success my-2">查詢</b-button>
	</b-form>
</div>
<script nonce="${nonce}">

	new Vue({
		el:"#app",
		data(){
			return{
				cityId:'',
				cityOptions:[],
				districtId:[],
				districtOptions:[],
				allDistricts:[]
			}
		},
		mounted(){
			fetch("<%=request.getContextPath()%>/form/queryAllCity")
			.then(res=>res.json()).then(data=>this.cityOptions=data);
			
			fetch("<%=request.getContextPath()%>/form/queryAllDistricts")
			.then(res=>res.json()).then(data=>this.allDistricts=data)
			
			fetch("<%=request.getContextPath()%>/form/queryDistrictForRest?country=臺北市")
			.then(res=>res.json()).then(data=>this.districtOptions=data);
		},
		computed:{
			selectedOptions(){
				var arr;
				arr=this.allDistricts.filter(district=>this.districtId.includes(district.districtId));
				return arr;
			}
		},
		methods:{
			loadDistricts(){
				fetch("<%=request.getContextPath()%>/form/queryDistrict?cityId="+this.cityId)
				.then(res=>res.json()).then(data=>this.districtOptions=data)
			}
		}
	})
</script>
</body>
</html>