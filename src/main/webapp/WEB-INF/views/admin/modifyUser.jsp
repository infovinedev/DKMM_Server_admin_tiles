<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>

var jdtListAdminUser;
var jdtListAdminUserDetail;

window.onload = function(){
};

$(document).ready(function () {
	var ua = navigator.userAgent;
	var checker = {
		iphone: ua.match(/(iPhone|iPod|iPad)/),
		blackberry: ua.match(/BlackBerry/),
		android: ua.match(/Android/)
	};
	
	//=== jdt_List 사이즈 변환시 테이블 리사이징
	$(window).bind('resize', function () {
		if (checker.android == null || checker.android == "" || checker.android == "null") {
			//$('#jdt_List').dataTable().fnAdjustColumnSizing();
		}
		$('#jdtListAdminUser').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
	});

// 	$('.panel').on('shown.bs.collapse', function (e) {
// 		$('#jdtListAdminUser').dataTable().fnAdjustColumnSizing();
// 	});

	fun_setjdtListAdminUser(function(){
		fun_selectjdtListAdminUser(function(){

		});
	});
	
	$("#txt_searchText").on('keyup click', function () {
		searchDataTable();	   
	});
	
	$("#chk_searchTable").on('keyup click', function () {
		searchDataTable();
	});
	
	$("#hdf_adminUserSeq").val('-1');

});

function searchDataTable(){
	if($('#chk_searchTable').is(':checked')){
	      $("#jdtListAdminUser").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	}
	else{
		$("#jdtListAdminUser").DataTable().search("").draw();
	}
}

function fun_selectjdtListAdminUser(callback){
	var searchStartDt = $("#search_startDt").val();
	var searchEndDt = $("#search_endDt").val();
	var inputData = {"searchText": "", "searchStartDt": searchStartDt,"searchEndDt": searchEndDt};
	
	
	fun_ajaxPostSend("/admin/select/adminUser.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			fun_dataTableAddData("#jdtListAdminUser", tempResult);
			callback();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}


function fun_setjdtListAdminUser(callback) {
	jdtListAdminUser = $("#jdtListAdminUser").DataTable({
		"columns": [
			  { "title": "seq", "data": "adminUserSeq"}      
			, { "title": "아이디", "data": "userId"}
			, { "title": "이름", "data": "userName"}
			, { "title": "코드", "data": "userTypeCode"}
			, { "title": "패스워드오류", "data": "passwordErrorCount" }
			, { "title": "마지막로그인", "data": "lastloginDate" }
			, { "title": "블록", "data": "blockYn" }
			, { "title": "등록일", "data": "regDate" }
			, { "title": "수정", "data": "add" }
			
		]
		, "sort": true                     // 소팅 여부
		, "paging": true            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "autoWidth": false
		, "filter": true               // 검색 부분 사용 여부
		, "search": true
// 		, "scrollY": "350px"
// 		, "scrollCollapse": true
// 		, "scrollX": true
// 		, "scrollXInner": "100%"
		//, "orderClasses": false
		, "order": [[ 1, "desc" ]]
		, "deferRender": true           // defer
		, "lengthMenu": [[10], [10]]           // Row Setting [-1], ["All"]
		, "lengthChange": false
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
				, visible: false
				, searchable: false
			}
			, {
				"targets": [1]
				, "class": "text-center"
			}
			, {
				"targets": [2]
				, "class": "text-left"
			}
			, {
				"targets": [3]
				, "class": "text-center"
				, "render": function (data, type, row, meta) {
					var insertTr = "";
					if ( row.userTypeCode == "00" ){
						insertTr = "관리자";
					}
					else{
						insertTr = "마케팅";
					}
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
				, "render": function (data, type, row, meta) {
					var insertTr = "";
					if ( row.lastloginDate != "" ){
						insertTr = row.lastloginDate.substring(0,4) + "-" + row.lastloginDate.substring(4,6) + "-" + row.lastloginDate.substring(6,8);
						insertTr = insertTr + " " +  row.lastloginDate.substring(8,10) + ":" + row.lastloginDate.substring(10,12) + ":" + row.lastloginDate.substring(12,14);
					}
					return insertTr;
                }
			}
			, {
				"targets": [6]
				, "class": "text-center"
			}
			, {
				"targets": [7]
				, "class": "text-center"
				, "render": function (data, type, row, meta) {
					var insertTr = "";
					if ( row.regDate != "" ){
						insertTr = row.regDate.substring(0,4) + "-" + row.regDate.substring(4,6) + "-" + row.regDate.substring(6,8);
						insertTr = insertTr + " " +  row.regDate.substring(8,10) + ":" + row.regDate.substring(10,12) + ":" + row.regDate.substring(12,14);
					}
					return insertTr;
                }
			}
			, {
				"targets": [8]
				, "class": "text-center"
				, "render": function (data, type, row, meta) {
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_clickjdtListAdminUser(' + meta.row + ')">상세보기</button>'; 
					return insertTr;
                }
			}
		]
	});
	callback();
};

function fun_insert(){
	fun_changeAfterinit();
	$("#txt_userId").attr("disabled",false); 
	$("#txt_userName").attr("disabled",false); 
	$("#sel_userTypeCode").val("-1");
	
	
	$("#section1_detail_view").removeAttr("style");
	$("#btnBlockY").hide();
	$("#btnBlockN").hide();
}

function fun_clickjdtListAdminUser(rowIdx) {
	var table = $("#jdtListAdminUser").DataTable();
	var row = table.rows(rowIdx).data()[0];
	var checkData = row.adminUserSeq;

	if (checkData != undefined) {
		
		fun_changeAfterinit();
		
		$("#hdf_adminUserSeq").val(row.adminUserSeq);
		$("#txt_userId").val(row.userId);
		$("#txt_userId").attr("disabled",true); 
		$("#txt_userName").val(row.userName);
		$("#txt_userName").attr("disabled",true); 
		$("#sel_userTypeCode").val(row.userTypeCode);
		
		$("#btnBlockY").show();
		$("#btnBlockN").show();
		
		$("#section1_detail_view").removeAttr("style");
	}
};

//==================================JQuery DataTable Setting 끝==================================


//=== 추가/수정 이후 히든값 및 텍스트 초기화
function fun_changeAfterinit() {
	$("#hdf_adminUserSeq").val('-1');
	$("#txt_userId").val('');
	$("#txt_newPassword").val('');
	$("#txt_userName").val('');
	$("#sel_userTypeCode").val('');
	$("#txt_adminPassword").val('');
};	



function fun_clickButtonBlockAdminUser(){
	
	if( $("#hdf_adminUserSeq").val() == '' ||  $("#hdf_adminUserSeq").val() == '-1'){
		alert('사용자를 선택해주세요');
		return false;
	}
	if (confirm('사용자를 블럭 하시겠습니까?')){
		var password = $("#txt_adminPassword").val();
		var shaPassword = "";
		if(password != ""){
			shaPassword = hex_sha512(password);
		}
		if(password==''||password==null){
			$("#txt_adminPassword").focus();
			alert('로그인 비밀번호를 입력해주세요');
		}
		else{
			var inputData = { 'adminUserSeq': $("#hdf_adminUserSeq").val()
							, 'blockYn': 'Y'
							, 'password': shaPassword
					};
			
			$.ajax({
				type: 'POST'
				, url: '/admin/update/block.do'
				, async: false
				, data: JSON.stringify(inputData)
				, contentType: 'application/json; charset=utf-8'
				, dataType: 'json'
				, success: function (msg) {
					if(msg.code == 0){
						fun_changeAfterinit();
						alert("블럭설정이 완료되었습니다");
						
						fun_selectjdtListAdminUser(function(){
						});
					}
					else{
						$("#txt_adminPassword").val('');
						$("#txt_adminPassword").focus();
						alert(msg.errorMessage);
							
					}
				}
				, error: function (xhr, status, error) {
					alert("code : " + xhr.status + "\r\nmessage : " + xhr.responseText);
				}
			});

		}
	}
	else {
	}
	return false;
}


function fun_clickButtonUnBlockAdminUser(){
	
	if( $("#hdf_adminUserSeq").val() == '' ||  $("#hdf_adminUserSeq").val() == '-1'){
		alert('사용자를 선택해주세요');
		return false;
	}
	if (confirm('사용자를 블럭 해제하시겠습니까?')){
		var password = $("#txt_adminPassword").val();
		var shaPassword = "";
		if(password != ""){
			shaPassword = hex_sha512(password);
		}
		if(password==''||password==null){
			$("#txt_adminPassword").focus();
			alert('로그인 비밀번호를 입력해주세요');
		}
		else{
			var inputData = { 'adminUserSeq': $("#hdf_adminUserSeq").val()
							, 'blockYn': 'N'
							, 'password': shaPassword
					};
			
			$.ajax({
				type: 'POST'
				, url: '/admin/update/block.do'
				, async: false
				, data: JSON.stringify(inputData)
				, contentType: 'application/json; charset=utf-8'
				, dataType: 'json'
				, success: function (msg) {
					if(msg.code == 0){
						fun_changeAfterinit();
						alert("블럭해제가 완료되었습니다");
						fun_selectjdtListAdminUser(function(){});
					}
					else{
						$("#txt_adminPassword").val('');
						$("#txt_adminPassword").focus();
						alert(msg.errorMessage);
					}
				}
				, error: function (xhr, status, error) {
					alert("code : " + xhr.status + "\r\nmessage : " + xhr.responseText);
				}
			});
		}

	}
	else {
	}
	return false;
}


function fun_clickButtonInsertAdminUser(){
	
	
	if (confirm('등록 및 수정하시겠습니까?')){
		var password = $("#txt_adminPassword").val();
		var newPassword = $("#txt_newPassword").val();
		var shaPassword = "";
		var shaNewPassword = "";
		
		if(password != ""){
			shaPassword = hex_sha512(password);
		}
		if(newPassword != ""){
			shaNewPassword = hex_sha512(newPassword);
		}
		if(password==''||password==null){
			$("#txt_adminPassword").focus();
			alert('로그인 비밀번호를 입력해주세요');
		}
		else{
			var inputData = { 'adminUserSeq': $("#hdf_adminUserSeq").val()
					, 'userId' :$("#txt_userId").val()
					, 'userName' : $("#txt_userName").val()
					, 'newPassword1' :shaNewPassword
					, 'userTypeCode':$("#sel_userTypeCode option:selected").val()
					, 'password': shaPassword
			};
		
			$.ajax({
				type: 'POST'
				, url: '/admin/insert/adminUser.do'
				, async: false
				, data: JSON.stringify(inputData)
				, contentType: 'application/json; charset=utf-8'
				, dataType: 'json'
				, success: function (msg) {
					if(msg.code == 0){
						$("#hdf_adminUserSeq").val('-1');
						fun_changeAfterinit();
						alert("저장이 완료되었습니다");
						fun_selectjdtListAdminUser(function(){});
						
					}
					else{
						$("#txt_adminPassword").val('');
						$("#txt_adminPassword").focus();
						alert("비밀번호가 다릅니다.");
					}
				}
				, error: function (xhr, status, error) {
					alert("code : " + xhr.status + "\r\nmessage : " + xhr.responseText);
				}
			});
		}

	}
	else {
	}
	return false;
}


</script>



<form id="membership" method="post" enctype="multipart/form-data" action="">
	<div class="wrapper">
          <div class="content-wrapper">
            <!-- 상단 title -->
            <div class="content-header">
               <div class="container-fluid">
                  <div class="row">
                     <div class="col">
                        <h1 class="title">사용자 조회</h1>
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
                                        <th>등록 기간</th>
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
                                        <th>검색어</th>
                                        <td colspan="3">
                                           <div class="row row-10 align-items-center">
                                                  <input type="text" style="width:94%;" class="form-control" placeholder="사용자정보" id="txt_searchText" name="searchText" onKeypress="" />
                                                  <input type="checkbox" style="width:34px; margin-left: 1%;" class="form-control" id="chk_searchTable"  />
                                           </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="btns">
                                <button type="button" class="btn btn-dark min-width-90px" onclick="fun_selectjdtListAdminUser(function(){});">검색</button>
                            </div>
                        </div>
                    </section>

                    <section id="section1">
                         <div class="row justify-content-between align-items-end mb-3">
                        	<input  type="hidden" id="totalCnt" name="totalCnt" />
                            <div class="col-auto">
                            </div>
                            <div class="col-auto">
                            	<button type="button" class="btn btn-primary mr-1" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_insert();">사용자등록</button>
                                <select id="nameStopLength" class="custom-select w-auto">
                                	<option value="10">10</option> 
                                	<option value="20">20</option>
                                	<option value="50">50</option>
                                </select>
                            </div>
                        </div>
                         <div class="main_search_result_list">
                                <table id="jdtListAdminUser" class="table table-bordered">
	                                <thead>
	                                	<th class="text-center">Seq</th> 
                                        <th class="text-center" width="15%">ID</th>
                                       	<th class="text-center">이름</th>
                                        <th class="text-center" width="8%">코드</th>   
                                        <th class="text-center" width="10%">패스워드오류</th>   
                                        <th class="text-center" width="11%">마지막로그인</th>   
                                        <th class="text-center" width="10%">블록</th>   
                                        <th class="text-center" width="11%">등록일</th>   
                                        <th class="text-center" width="8%">수정</th>
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
                            <h5 class="modal-title" id="exampleModalScrollableTitle">상세정보</h5>
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
                                     <th>아이디</th>
                                     <td>
                                     	<input type="text" id="txt_userId" class="form-control" placeholder="Ex) admin" />
                                     </td>
                                     <th>비밀번호</th>
                                     <td>
                                     	<input type="password" id="txt_newPassword" class="form-control" placeholder="" />
                                     </td>
                                  </tr>
                                  <tr>
                                  	<td colspan="4">
                                  		<div class="col-lg-12 col-sm-12" style="color: Red">
	                                		※ 비밀번호는 공란으로 둘 경우 비밀번호는 변경되지 않습니다
	                                	</div>
                                  	</td>
                                  </tr>
                                  <tr> 
                                     <th>이름</th>
                                     <td>
                                     	<input type="text" id="txt_userName" class="form-control" placeholder="" />
                                     </td>
                                     <th>유저타입</th>
                                     <td>
                                     	<select id="sel_userTypeCode" class="form-control" style="width:50%;">
											<option value="-1">---선택---</option>
											<option value="00">관리자</option>
											<option value="01">마케팅</option>
                                        </select>
                                     </td>
                                  </tr>
                                  
                                  <tr> 
                                     <th>로그인<br>비밀번호</th>
                                     <td colspan="3">
                                     	<input type="password" id="txt_adminPassword" class="form-control">
                                     </td>
                                  </tr>
                                  
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-primary" onclick="return fun_clickButtonInsertAdminUser();">저장</button>
                            <button type="button" id="btnBlockY" class="btn btn-danger" onclick="return fun_clickButtonBlockAdminUser();" >블럭설정</button>
                            <button type="button" id="btnBlockN" class="btn btn-danger" onclick="return fun_clickButtonUnBlockAdminUser();" >블럭해제</button>
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
	 <input type="hidden" id="hdf_adminUserSeq" value="" />
</form>
