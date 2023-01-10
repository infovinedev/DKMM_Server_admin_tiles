<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 -->
<script>
var userListInfo;

$(document).ready(function () {
	var ua = navigator.userAgent;
	var checker = {
		iphone: ua.match(/(iPhone|iPod|iPad)/),
		blackberry: ua.match(/BlackBerry/),
		android: ua.match(/Android/)
	};
	
	$(window).bind('resize', function () {
		if (checker.android == null || checker.android == "" || checker.android == "null") {
		}
	});
	
	
	fun_setUserListInfo();
	
	$("#userListLength").change(function(){
		var length = $("#userListLength").val();
		$("#userListInfo").DataTable().page.len(length).draw();
	});
	
   $("#txt_searchText").on('keyup click', function () {
		searchDataTable();	   
	});
	
	$("#chk_searchTable").on('keyup click', function () {
		searchDataTable();
	});
	
	$("#sel_osType").on('change', function () {
		fun_search();
	});
	
});

function searchDataTable(){
	 if($('#chk_searchTable').is(':checked')){
	      $("#userListInfo").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	   }
	else{
		$("#userListInfo").DataTable().search("").draw();
	}
}

function fun_search(){
	
	$('#chk_searchTable').prop('checked', false);
	searchDataTable();
	
	var osType = $("#sel_osType").val();
	var searchText = $("#txt_searchText").val();
	var searchStartDt = $("#search_startDt").val();
	var searchEndDt = $("#search_endDt").val();
	
	
	var inputData = {"osType": osType, "searchText": searchText, "searchStartDt": searchStartDt,"searchEndDt": searchEndDt};
	fun_ajaxPostSend("/user/select/userInfo.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			for (let i = 0; i < tempResult.length; i++) {
				tempResult[i].listIndex = i + 1
			}
			fun_dataTableAddData("#userListInfo", tempResult);
		}
	});
}

//text값 공백처리
function fun_reset(type){
	$("#txt_userSeq").val("");
	$("#txt_osType").val("");
	$("#txt_ci").val("");
	$("#txt_nickName").val("");
	$("#txt_gender").val("");
	$("#txt_age").val("");
	$("#txt_phone").val("");
	$("#txt_waitCnt").val("");
	$("#txt_insDt").val("");
	$("#txt_point").val("");
	$("#txt_coupon").val("");
	$("#txt_likeCnt").val("");
	$("#txt_email").val("");
	
	//본인인증 YN 버튼 초기화
	$("#btn_useYn").removeClass();
	$("#btn_useYn").text(" ");

	
}

//상세보기
function fun_viewDetail(userSeq) {
	fun_reset();
	$("#section1_detail_view").removeAttr("style");
	var inputData = {"userSeq": userSeq};
	fun_ajaxPostSend("/user/select/userInfoDetail.do", inputData, true, function(msg){
		if(msg!=null){
			var tempResult = JSON.parse(msg.result);
			var userSeq    = tempResult.userSeq == null ? "" : tempResult.userSeq;                     //사용자ID
			var userId     = tempResult.userId == null ? "" : tempResult.userId;                       //ID
			var osType     = tempResult.osType == null ? "" : tempResult.osType;                       //OS Type
			var useYn      = tempResult.useYn == null ? "" : tempResult.useYn;                         //본인인증여부
			var ci         = tempResult.ci == null ? "준회원" : "회원";                                   //로그인  -> null값이면 준회원 X-> 회원???? 
			var nickName   = tempResult.nickName == null ? "" : tempResult.nickName;                   //닉네임
			var gender     = tempResult.gender == null ? "" : tempResult.gender;                       //성별
			var age        = tempResult.age == null ? "" : tempResult.age;                             //나이
			var phone      = tempResult.phone == null ? "" : tempResult.phone;                         //휴대전화번호
			var waitCnt    = tempResult.waitCnt == null ? "" : tempResult.waitCnt;                     //대기등록횟수
			var insDt      = tempResult.insDt == null ? "" : tempResult.insDt;                         //가입일
			var point      = tempResult.point == null ? "" : tempResult.point;                         //보유포인트
			var coupon     = tempResult.coupon == null ? "" : tempResult.coupon;                       //보유쿠폰
			var likeCnt    = tempResult.likeCnt == null ? "" : tempResult.likeCnt;                     //찜한매장
			var email      = tempResult.email == null ? "" : tempResult.email;                         //메일
			
			$("#txt_userSeq").val(userSeq);
			$("#txt_osType").val(osType);
			$("#txt_ci").val(ci);
			$("#txt_nickName").val(nickName);
			$("#span_nickName").text("#"+userId);
			$("#txt_gender").val(gender);
			$("#txt_age").val(age);
			$("#txt_phone").val(phone);
			if(useYn == "Y"){
				$("#btn_useYn").text("본인인증 완료");
				$("#btn_useYn").addClass("btn btn btn-outline-success ml-2");
			}else{
				$("#btn_useYn").text("본인인증 미완료");
				$("#btn_useYn").addClass("btn btn btn-outline-danger ml-2");
			}
			
			
			
			
			$("#txt_waitCnt").val(waitCnt);
			$("#txt_insDt").val(insDt);
			$("#txt_point").val(point);
			$("#txt_coupon").val(coupon);
			$("#txt_likeCnt").val(likeCnt);
			$("#txt_email").val(email);
		}
	});
}

function fun_setUserListInfo() {
	userListInfo = $("#userListInfo").DataTable({
		"columns": [
			  {"data":  "listIndex"}
			, {"data":  "userSeq"}
			, {"data": "osType"}
			, {"data": "nickName"}
			, {"data": "gender"}
			, {"data": "waitCnt"}
			, {"data": "likeCnt"}
			, {"data": "insDt" }
			, {"data": "point" }
			, {"data": "add" }
		]
		, "paging": true            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "autoWidth": true
 		, "scrollXInner": "100%"
		, "order": [[ 1, "desc" ]]
		, "deferRender": true                // defer
		, "lengthMenu": [10,20,50]           // Row Setting [-1], ["All"]
		, "lengthChange": true
		, "dom": 't<"bottom"p><"clear">'
		, "language": {
			"search": "검색",
			"lengthMenu": " _MENU_ ",
			"zeroRecords": "데이터가 없습니다.",
			"info": "page _PAGE_ of _PAGES_",
			"infoEmpty": "",
			"infoFiltered": "(filtered from _MAX_ total records)",
			"paginate": {
				"next": ">",
				"previous": "<"
		}
		}
		, "columnDefs": [
			{
				"targets": [0]
				, "class": "text-center"
			}
			 ,
			{
				"targets": [1]
				, "class": "text-center"
			}
			 , {
				"targets": [2]
				, "class": "text-center"
			}
			, {
				"targets": [3]
				, "class": "text-left"
				, "render": function (data, type, row) {
					var insertTr = ""; 
					insertTr += '<a href="javascript:void(0);" onclick="fun_work_excel_start(\'work\', \'' + row.userSeq + '\', \'' + row.nickName + '\')"><font color="blue"><b>'+ row.nickName +'</b></font></a>'; 
					return insertTr;
	                }
			}
			, {
				"targets": [4]
				, "class": "text-center"
			}
			, {
				"targets": [5]
				, "class": "text-center"
				, "render": function (data, type, row) {
					var insertTr = ""; 
					if ( row.waitCnt == "0" ){
						insertTr = row.waitCnt;
					}else{
						insertTr = '<a href="javascript:void(0);" onclick="fun_work_excel_start(\'wait\', \'' + row.userSeq + '\', \'' + row.nickName + '\')"><font color="blue"><b>'+ row.waitCnt +'</b></font></a>'; 
					}
					return insertTr;
	        	}
			}
			, {
				"targets": [6]
				, "class": "text-center"
				, "render": function (data, type, row) {
					var insertTr = ""; 
					if ( row.likeCnt == "0" ){
						insertTr = row.waitCnt;
					}else{
						insertTr += '<a href="javascript:void(0);" onclick="fun_work_excel_start(\'like\', \'' + row.userSeq + '\', \'' + row.nickName + '\')"><font color="blue"><b>'+ row.likeCnt +'</b></font></a>'; 
					}
					return insertTr;
	            }
			}
			, {
				"targets": [7]
				, "class": "text-center"
			}
			, {
				"targets": [8]
				, "class": "text-center"
			}
			, {
				"targets": [9]
				, "class": "text-center"
				, "render": function (data, type, row) {
					var msg = row.userSeq;
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_viewDetail(' + msg + ')">상세보기</button>'; 
					return insertTr;
                }
			}
		]
	});
	
	fun_search();
};

function fun_work_excel_start(argFlag, userSeq, userNickName){
	fun_startBlockUI();
	
	if ( argFlag == "user"){
		setTimeout(() => fun_work_excel(), 500);
	}else if ( argFlag == "work"){
		setTimeout(() => fun_user_work_excel(userSeq, userNickName), 500);
	}else if ( argFlag == "wait"){
		setTimeout(() => fun_user_wait_excel(userSeq, userNickName), 500);
	}else if ( argFlag == "like"){
		setTimeout(() => fun_user_like_excel(userSeq, userNickName), 500);
	}
	
}

function fun_work_excel(){
	
	var inputData = {"osType": "", "searchText": "", "searchStartDt": "","searchEndDt": ""};
	
	var excelArray = new Array(1); 
	var fileName = "회원정보조회";
	var url = "/user/select/userInfo.do";
	var columnCodeArray = [];
	var columnNameArray = [];
	var wscols = [];
	
	wscols.push({ width: 10 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 }); 
	
	fun_ajaxPostSend(url, inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			
			var arrayList = [];
			for (let i = 0; i < tempResult.length; i++) {
				
				var obj = {}; 
				obj.번호 = i + 1;
				obj.사용자SEQ = tempResult[i].userSeq
				obj.닉네임 = tempResult[i].nickName;
				obj.OS = tempResult[i].osType;
				obj.대기등록횟수 = tempResult[i].waitCnt;
				obj.즐겨찾기횟수 = tempResult[i].likeCnt;
				obj.성별 = tempResult[i].gender;
				obj.가입일 = tempResult[i].insDt;
				
				arrayList.push(obj);
			}
			
			excelArray[0] = arrayList;
			jsonToExcel(excelArray, fileName, columnCodeArray, wscols);
			
		}
	});
}

function fun_user_work_excel(userSeq, userNickName){
	
	var inputData = {"userSeq": userSeq};
	
	var excelArray = new Array(1); 
	var fileName = "회원업적조회_[" + userNickName + "]";
	var url = "/user/select/userDefineWorkList.do";
	var columnCodeArray = [];
	var columnNameArray = [];
	var wscols = [];
	
	wscols.push({ width: 10 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 15 }); 
	
	fun_ajaxPostSend(url, inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			
			var arrayList = [];
			for (let i = 0; i < tempResult.length; i++) {
				
				var obj = {}; 
				obj.번호 = i + 1;
				obj.업적Seq = tempResult[i].workSeq
				obj.업적명 = tempResult[i].workNm
				obj.달성조건 = tempResult[i].workConditionNm;
				obj.간략설명 = tempResult[i].workConditionDesc;
				obj.달성횟수 = tempResult[i].workCnt;
				obj.시작일자 = tempResult[i].startDt;
				obj.종료일자 = tempResult[i].endDt;
				obj.달성이후누적 = tempResult[i].zombieYn;
				obj.기간한정여부 = tempResult[i].limitYn;
				obj.완료여부 = tempResult[i].completeYn;
				obj.사용자액션횟수 = tempResult[i].myCnt;
				
				arrayList.push(obj);
			}
			excelArray[0] = arrayList;
			jsonToExcel(excelArray, fileName, columnCodeArray, wscols);
		}
	});
}

function fun_user_wait_excel(userSeq, userNickName){
	
	var inputData = {"userSeq": userSeq};
	
	var excelArray = new Array(1); 
	var fileName = "회원대기목록조회_[" + userNickName + "]";
	var url = "/user/select/userStoreWaitList.do";
	var columnCodeArray = [];
	var columnNameArray = [];
	var wscols = [];
	
	wscols.push({ width: 10 });  
	wscols.push({ width: 20 });  
	wscols.push({ width: 10 });  
	wscols.push({ width: 20 });  
	wscols.push({ width: 20 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 30 });  
	wscols.push({ width: 10 });  
	
	fun_ajaxPostSend(url, inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			
			var arrayList = [];
			for (let i = 0; i < tempResult.length; i++) {
				
				var obj = {}; 
				obj.번호 = i + 1;
				obj.대기등록일시 = tempResult[i].insDt;
				obj.대기인원 = tempResult[i].personCnt;
				obj.상점Seq = tempResult[i].storeSeq;
				obj.상점명 = tempResult[i].storeNm;
				obj.상점카테고리 = tempResult[i].ctgryNm;
				obj.상점주소 = tempResult[i].roadAddr;
				obj.상점폐업여부 = tempResult[i].delYn;

				arrayList.push(obj);
			}
			
			excelArray[0] = arrayList;
			jsonToExcel(excelArray, fileName, columnCodeArray, wscols);
			
		}
	});
}

function fun_user_like_excel(userSeq, userNickName){
	
	var inputData = {"userSeq": userSeq};
	
	var excelArray = new Array(1); 
	var fileName = "회원대기목록조회_[" + userNickName + "]";
	var url = "/user/select/userStoreLikeList.do";
	var columnCodeArray = [];
	var columnNameArray = [];
	var wscols = [];
	
	wscols.push({ width: 10 });  
	wscols.push({ width: 10 });  
	wscols.push({ width: 20 });  
	wscols.push({ width: 15 });  
	wscols.push({ width: 30 });  
	wscols.push({ width: 10 });  
	wscols.push({ width: 20 });  
	
	fun_ajaxPostSend(url, inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			
			var arrayList = [];
			for (let i = 0; i < tempResult.length; i++) {
				
				var obj = {}; 
				obj.번호 = i + 1;
				obj.상점Seq = tempResult[i].storeSeq;
				obj.상점명 = tempResult[i].storeNm;
				obj.상점카테고리 = tempResult[i].ctgryNm;
				obj.상점주소 = tempResult[i].roadAddr;
				obj.상점폐업여부 = tempResult[i].delYn;
				obj.찜상점등록일시 = tempResult[i].insDt;
				
				arrayList.push(obj);
			}
			
			excelArray[0] = arrayList;
			jsonToExcel(excelArray, fileName, columnCodeArray, wscols);
			
		}
	});
}
</script>
<head>
	<title>관리자 운영 - 회원정보조회</title>
</head>
<body class="hold-transition sidebar-mini">
    <div class="wrapper">
          <div class="content-wrapper">
            <!-- 상단 title -->
            <div class="content-header">
               <div class="container-fluid">
                  <div class="row">
                     <div class="col">
                        <h1 class="title">회원정보조회</h1>
                     </div>
                  </div>
               </div>
            </div>
            <!-- Main content -->
            <div class="content" data-menu="notice">
                <div class="container-fluid">
                    <section id="section1_search">
                        <div class="inquery-area">
                            <table class="table table-bordered">
                                <colgroup>
                                    <col style="width: 150px">
                                    <col>
                                    <col style="width: 150px">
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>가입 기간</th>
                                        <td colspan="3">
                                           <div class="row">
                                              <div class="col-auto">
                                                  <div class="row row-10 align-items-center">
                                                        <div class="col-auto">
                                                            <input type="text" readonly="" class="form-control form-datepicker" placeholder="0000-00-00" id="search_startDt">
                                                        </div>
                                                        <div class="col-auto">~</div>
                                                        <div class="col-auto">
                                                            <input type="text" readonly="" class="form-control form-datepicker endDt" placeholder="0000-00-00" id="search_endDt">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col">
                                                    <div class="btn-group" role="group">
                                                    	<button type="button" class="btn btn-outline-secondary active" day="all">전체</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="0">오늘</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="1">어제</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="3">3일</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="7">7일</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="15">15일</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="31">1개월</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="33">3개월</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="36">6개월</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>접속기기유형</th>
                                        <td>
                                            <select class="form-control" id="sel_osType" name="search_osType" style="width:80%;">
                                                <option value="">선택</option>
                                                <option value="AOS">AOS</option>
                                                <option value="IOS">IOS</option>
                                            </select>
                                        </td>
                                        <th>검색어</th>
                                        <td>
                                           <div class="row row-10 align-items-center">
                                                  <input type="text" style="width:90%;" class="form-control" placeholder="닉네임" id="txt_searchText" name="searchText" onKeypress="" />
                                                  <input type="checkbox" style="width:34px; margin-left: 1%;" class="form-control" id="chk_searchTable"  />
                                           </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="btns">
                                <button type="button" class="btn btn-dark min-width-90px" onclick="fun_search();">검색</button>
                            </div>
                        </div>
                    </section>

                    <section id="section1">
                        <div class="row justify-content-between align-items-end mb-3">
                        	<div class="col-auto"></div>
                            <div class="col-auto">
                            	<button type="button" class="btn btn-outline-primary mr-1" onclick="fun_work_excel_start('user', '', '')">엑셀다운로드</button>
                                <select id="userListLength" class="custom-select w-auto">
                                	<option value="10">10</option>
                                	<option value="20">20</option>
                                	<option value="50">50</option>
                                </select>
                            </div>
                         </div>
                         <div class="main_search_result_list">
                                <table id="userListInfo" class="table table-bordered">
                                    <thead>
                                    	<tr>
	                                        <th class="text-center" width="5%">번호</th>
	                                        <th class="text-center" width="10%">사용자<br/>ID</th>
	                                       	<th class="text-center" width="8%">OS</th>
	                                        <th class="text-center">닉네임</th>
	                                        <th class="text-center" width="7%">성별</th>
	                                        <th class="text-center" width="8%">대기등록<br/>횟수</th>
	                                        <th class="text-center" width="8%">즐겨찾기<br/>횟수</th>
	                                        <th class="text-center" width="11%">가입일</th>
	                                        <th class="text-center" width="8%">보유<br/>포인트</th>
	                                        <th class="text-center" width="8%">관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                        </div>
                	</section>
                </div>
                <!-- 상세보기 모달창 start -->
                <div class="modal fade" id="exampleModalScrollable" tabindex="-1" role="dialog" aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
                  <div class="modal-dialog modal-dialog-scrollable" role="document">
                    
                    <!-- 상세보기 start-->
                    <section id="section1_detail_view" style="display:none;">
                        <div class="modal-content" style="width: 1200px;">
                         <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalScrollableTitle">회원정보 상세</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                              <span aria-hidden="true">&times;</span>
                            </button>
                          </div>
                          <div class="modal-body">
                            <table class="table table-bordered" >
                               <colgroup>
                                  <col style="width:15%">
                                  <col style="width:35%">
                                  <col style="width:15%">
                                  <col style="width:35%">
                               </colgroup>
                               <tbody>
                                  <tr>
                                     <th>사용자ID</th>
                                     <td><input class="form-control" type="text" id="txt_userSeq" readOnly/></td>
                                     <th>OS</th>
                                     <td><input class="form-control" type="text" id="txt_osType" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>로그인</th>
                                     <td><input class="form-control" type="text" id="txt_ci" readOnly/></td><!-- null값이면 준회원 X-> 회원???? -->
                                     <th>닉네임</th>
                                     <td><input class="form-control-finance" type="text" id="txt_nickName" readOnly/>
                                         <span id="span_nickName" style="color:blue"></span>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>성별</th>
                                     <td><input class="form-control" type="text" id="txt_gender" readOnly/></td>
                                     <th>나이</th>
                                     <td><input class="form-control" type="text" id="txt_age" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>휴대전화번호</th>
                                     <td><input class="form-control-finance" style="width:245px;" type="text" id="txt_phone" readOnly/>
                                         <button id="btn_useYn" class=""></button>
                                     </td>
                                     <th>대기등록횟수</th>
                                     <td><input class="form-control" type="text" id="txt_waitCnt" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>가입일</th>
                                     <td><input class="form-control" type="text" id="txt_insDt" readOnly/></td>
                                     <th>보유포인트</th>
                                     <td><input class="form-control" type="text" id="txt_point" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>찜한매장</th>
                                     <td><input class="form-control" type="text" id="txt_likeCnt" readOnly/></td>
                                     <th>메일</th>
                                     <td><input class="form-control" type="text" id="txt_email" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>보유쿠폰</th>
                                     <td colspan="3"><input class="form-control" type="text" id="txt_coupon" readOnly/></td>
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                          </div>
                        </div>
                    </section>
                  </div>
                </div>
                <!-- 상세보기 모달창 end -->
            </div>
        </div>
    </div>
    </body>