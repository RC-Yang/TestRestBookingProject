<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>網頁設計入門作業1</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>
    <!-- 刪除js檔案，以免其執行 -->
    <style>
    * {
        margin:0;
        padding:0;
        box-sizing: border-box;
    }
    header .headernav nav a{
            background-color: #fffb0000;
            color: black;
            font-family:Arial, Helvetica, sans-serif;
            font-size: 25px;
            text-decoration: none;

            display: inline-block;
            height:100%;
            /* 兒子要相對爸爸來定位，爸爸要設定可以被相對定位 */
            position: relative;
        }
        /* 令anchor的底線是一個元素，較容易設定底線 */
        /* 但底線又不算是真正的元素，故設定底線為偽元素，且是位在anchor下方的偽元素 */
        header .headernav nav a::before{
            /* 這樣就是設定偽元素(底線)在anchor下一層(非anchor下方) */
            content: '';/*一定要寫，不然偽元素無法存在*/
            display:block;/*偽元素預設是inline，要改成inline-block或block才能有寬高*/
            height: 4px;
            width: 0%;  
            background-color: #000000;
            
            /* 令該偽元素在anchor下方 */
            position: absolute;
            left: 0;
            bottom: 0;
            /*新增轉場效果與設定轉場持續時間*/
            transition: 0.25s;/*寫在這可以同時應付滑鼠移入跟移出事件，因為元素的任何狀態，都繼承了元素的默认样式*/
        }

    @media(max-width:799px){
        /* 手機板頁面 */
        header{
            display:flex;
            flex-direction: column;
            width:100%;
            height:90vh;
            background-image: linear-gradient(rgb(179, 39, 184), rgba(255, 255, 0, 0))
        }
        header div:first-child{
            width:100%;
            height:30%;
        }
        header .headerimg{
            display: inline-block;
            width:100%;
            height: 100%;
        }
        header .headernav{
            /* 對下一層的上下兩個nav做垂直排列 */
            display:flex;
            flex-direction: column;
            height:80%;
            
        }
        header .headernav nav{
            /* 對下一層的anchor作排列，為此anchor要設為block */
            display:flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;

            width:100%;
        }
        header .headernav nav a{
            display: block;
            /* width:50%; *//*anchor不須另外設定width*/
            text-align: center;
            margin-top: 9px;
        }
        /* header .headernav nav a::after也可 */
        header .headernav nav a::before
         {
            content: "";
            position: absolute;
            bottom: 0;
            width: 0;
            height: 4px; 
            background-color: #000000; 
            transition: 0.5s; /*設定所有轉場效果持續時間相同*/
            /* 設定底線偽元素一開始位於中點 */
            left:50%;    
        }

        header .headernav nav a:hover::before {
            left:0;/*設定底線偽元素由中點移動到左側(此時width仍是0，故看不到)*/
            width: 100%;/*width由0->100是往右，底線偽元素本身往左的同時也會把所屬的width往左帶，這樣就能做出往左右的效果*/
            /* 偽元素本體在轉場、偽元素的width也在轉場->雙重轉場 */
        }

        main{
            /*不要出現，也不要占位置*/
            display: none;
        }
        /* footer area */
        footer{
            width:100%;
            background-color: #73ff00bb;
            height:10vh;

            display: flex;        
            /*對兒子本身置中*/
            justify-content: center;/*只有水平置中*/
            align-items: center;
        }    
        #fooText{

        }
    }
    /* 桌機版頁面 */
    @media(min-width:800px) {
        header{
            display: flex;
            justify-content: space-between;
            height:20vh;
            background-image: linear-gradient(rgb(179, 39, 184), rgba(255, 255, 0, 0));
        }
        /* header正下一層是圖片框與nav框兩部分，圖片框包含img、nav框包含上、下兩個nav，
        所以header正下方會有2個div */
        /* header正下方第一個div */
        header div{
            /*background-color: rgb(212, 124, 23);*/
            width: 40%;
            height:100%;/*若父元素高度確定，則該元素的高度將等於它的父容器的高度*/
        }
        header div .headerimg{
            display:inline-block;
            height:100%;/*若父元素高度確定，則該元素的高度將等於它的父容器的高度*/
            /* 這樣LOGO會有個預設寬度 */
            /* 改變LOGO預設寬度 */
            /* 方法一 */
            /*width:300px;*/
        	/* 方法二 */
        	transform-origin:0 0;/*手動設置圖片擴張起點為左下角*/
            transform: scaleX(3);/*圖片以左下角為起點，向右擴張3倍*/
        }
        /* header正下方第二個div */
        header .headernav{
            width:60%;
            /*設置彈性盒子，讓子容器可以根據父容器彈性變化位置*/
            display: flex;
            /*設置子容器位置由上往下*/
            flex-direction:column;
            /*設置子容器剛好貼到最上方與最下方*/
            justify-content: space-between;
        }
        header .headernav nav{
            /*width:100%;/*如果 <nav> 被放在塊級元素內，例如 <div> 或是 <body>，它的寬度會默認為父元素的 100%*/
            text-align: right;
            padding-right: 30px;
        }

        /* 如果anchor發生hover事件，after偽元素就做以下動作 */
        header .headernav nav a:hover::before{
            width:100%; 
        }
        /* main area */
        main{
            width:100%;
            height:70vh;
        }
        #mainDiv,#mainDiv *:not(.carousel-indicators,button,button *){
            width:100%;
            height:100%;
        }
        #mainDiv .img{
        	object-fit:cover;
        }
        
        /* footer area */
        footer{
            width:100%;
            background-color: #73ff00bb;
            height:10vh;
			/*決定父元素的content完全置中(故父元素內即使是純文字，也可置中)*/
            display: flex;        
            justify-content: center;
            align-items: center;
        }
    }

    </style>
</head>
<body>
    <html>
        <body>
            <header>
                <div><img src="http://imgur.com/YtOejpS.png" class="headerimg"></div>
                <div class="headernav">
                    <nav>
                        <a href="">訂位</a>
                        <a href="">查詢訂位</a>
                        <a href="">修改/取消訂位</a>
                        <a href="">查詢餐廳</a>
                        <a href="">推薦餐廳</a>
                        <a href="">關於我們</a>
                    </nav>
                    <nav>
                        <a href="<%=request.getContextPath() %>/entry/goToReg?action=1">註冊</a>
                        <a href="<%=request.getContextPath() %>/entry/goToLogIn?action=2">登入</a>
                        <a href="<%=request.getContextPath() %>/entry/forgetPassword?action=3">忘記密碼？</a>

                    </nav>
                </div>
            </header>
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
            <footer>
                web © 2015 , Update @2023 Maintain by TSuiling ( tsuiling1020@gmail.com )
            </footer>
        </body>
    </html>
</body>
</html>