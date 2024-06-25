<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>訂位紀錄查詢頁面</title>
    <link href="https://cdn.jsdelivr.net/npm/@mdi/font/css/materialdesignicons.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/vuetify@2.5.10/dist/vuetify.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vuetify@2.5.10/dist/vuetify.js"></script>

    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
    <input type="hidden" id="bookingRecord" value='${bookingRecord}' /><!--取出後端model物件內的json格式字串，注意要用單引號，因雙引號已被json格式字串用掉-->
    <div class="modal fade" tabindex="-1" id="bookingRecordModal">
        <div class="modal-dialog modal-lg"><!--添加modal-lg以適應螢幕寬度-->
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Modal title</h5>
              <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              
                <div id="app">
                    <v-container><!--1-->
                        <v-data-table :headers="headers" :items="items"><!--2，12是vuetify dataTable常用預設架構-->
                        </v-data-table>
                    </v-container>
                </div>

            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="window.location.href = 'http://localhost:8080/RestBookingProject/entry/goTologinSuccessForUser'">Close</button>
            </div>
          </div>
        </div>
      </div>
    
</body>
<script>
    new Vue({
        el:'#app',//el:'#app'的目的，是告訴 Vue.js，要控制哪個 DOM 元素
        vuetify:new Vuetify(),//vuetify: new Vuetify()的目的，是啟用 Vuetify 插件
        //data是js物件，用於設定vue本身可以操作的變數有哪些，這些變數可以餵給vue屬性，做出不同的效果
        //變數設定於該物件內
        data:{
            headers:[{text:'訂位餐廳',value:'rest'},{text:'訂位日期',value:'date'},{text:'訂位時間',value:'time'},{text:'訂位人數',value:'number'}],
            items:[]
        },
        mounted(){
            //取出json格式字串
            var allBookigRecord = document.getElementById('bookingRecord').value
            allBookigRecord = JSON.parse(allBookigRecord);//將json格式字串轉為js物件，這裡是轉成js array，因items只接受js array
            this.items=allBookigRecord;
            //alert(this.items);
            $("#bookingRecordModal").modal('show');
        }
    })
</script>
</html>