<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>

<style>
    *{
        margin:0;
        padding:0;
        box-sizing: border-box;
    }
    #header{
        height:20vh;
        width:98%;

        display:flex;/*這樣即可將一組包含div元素在內的多個元素，整併成只有一行，也就是單一div元素，不會單獨占有整個一行*/
        justify-content: space-between;
        align-items: center;

        margin-top:20px;/*因現為border-box，padding+content=height=20vh=固定值，這樣的話如果要以padding來調整位置，必然影響到content，導致內容失真，故不能使用padding來調整*/
        margin-right:5%;/*這時需要於水平方向讓內容向左微調；這時水平方向為width:100%，內容佔據全部；而既然不能用padding來設定位置，故設成width:95%;margin-right:5%;*/
        margin-left:-3%;/*這時要將logo向外推；而既然將margin設為正數，表示將內容向中央推、那麼將margin設為負數，表示將內容向外推*/
        /*原本width為100%，前面設定+5%、-3%，若還要讓整體布局為100%，則width須為98%*/
    }
    #header #userImg{
        height:100%;/*讓該img元素的大小，剛好依父元素大小來縮放*/
    }
    #navigator{
        height:10vh;
        width:100%;
        background-color: Aquamarine;
        /*要對子元素(這裡是超連結元素)，進行水平垂直置中*/
        display:flex;
        justify-content: center;
        align-items: center;
    }
    #navigator a{/*受父元素的flex影響，此時anchor會從inline元素，變成flex元素*/
        height: 100%;
        width:15%;
        /*要對子元素(這裡是超連結文字充當子元素角色)，進行水平垂直置中*/
        display:flex;
        justify-content: center;
        align-items: center;
             
        color: black;
        text-decoration: none;
    }
    #navigator a:hover{
        background-color: DarkGreen;
        transition: 0.25s;
        text-decoration: none;
    }
    main{
        height:57vh;
        width:100%;
    }
    /*20240301新增*/
    #mainDiv,.carousel-inner,.carousel-item,.carousel-item>img{
      height: 100%;
    }
    .carousel-item>img{
      object-fit: cover;
    }
    footer{
      height:10vh;
      background-color: Chartreuse;
      /*text-align: center;*/
      /*vertical-align: middle;*/
      /*以上置中效果較差*/
      display:flex;
      justify-content: center;
      align-items: center;
    }
</style>
</head>
<body>
    <header id="header">
        <div id="logo" name="logo"><img src="<%=request.getContextPath()%>/image/photo1.png"/></div>
        <!--因為要設定flexbox，故需要一個div將以下內容包含起來-->
        <div style="height:100%;padding:15px 0;"><!--這時content高度為100%-30px-->
            您好~~~<!--該字串被抬升15px-->
            104
            <img id="userImg" src="<%=request.getContextPath()%>/image/photoSample.jpg"/>
            <a href="<%=request.getContextPath()%>/entry/logout">登出</a>
        </div>
    </header>
    <nav id="navigator">
        <a href="booking.html">訂位</a>
        <a href="#">查詢訂位</a>
        <a href="#">修改/取消訂位</a>
        <a href="<%=request.getContextPath() %>/form/queryInitialDistrict">查詢餐廳</a>
        <a href="#">推薦餐廳</a>
        <a href="#">關於我們</a>
    </nav>
    <main>
        <div id="mainDiv" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-indicators">
              <button type="button" data-bs-target="#mainDiv" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
              <button type="button" data-bs-target="#mainDiv" data-bs-slide-to="1" aria-label="Slide 2"></button>
              <button type="button" data-bs-target="#mainDiv" data-bs-slide-to="2" aria-label="Slide 3"></button>
              <button type="button" data-bs-target="#mainDiv" data-bs-slide-to="3" aria-label="Slide 4"></button>
              <button type="button" data-bs-target="#mainDiv" data-bs-slide-to="4" aria-label="Slide 5"></button>
            </div>
            <div class="carousel-inner" >
              <div class="carousel-item active">
                <img src="https://i.imgur.com/tJuGXUM.jpg" class="d-block w-100 img" alt="...">
              </div>
              <div class="carousel-item">
                <img src="https://i.imgur.com/vw27QaK.jpg" class="d-block w-100 img" alt="...">
              </div>
              <div class="carousel-item">
                <img src="https://i.imgur.com/dBWzKFq.jpg" class="d-block w-100 img" alt="...">
              </div>
              <div class="carousel-item">
                <img src="https://i.imgur.com/2dFFcM7.jpg" class="d-block w-100 img" alt="...">
              </div>
              <div class="carousel-item">
                <img src="https://i.imgur.com/LdabDP2.jpg" class="d-block w-100 img" alt="...">
              </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#mainDiv" data-bs-slide="prev">
              <span class="carousel-control-prev-icon" aria-hidden="true"></span>
              <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#mainDiv" data-bs-slide="next">
              <span class="carousel-control-next-icon" aria-hidden="true"></span>
              <span class="visually-hidden">Next</span>
            </button>
        </div>
    </main>
    <footer>web © 2015 , Update @2023 Maintain by TSuiling ( tsuiling1020@gmail.com )</footer>
</body>
</html>