<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>

var jdtListCommonCode;
var jdtListCommonCodeDetail;
var jdtListLastPagenate = -1;
var jdtListLastSelectRowIndex = -1;
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
		}
// 		$('#jdtListCommonCode').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
	});

// 	$('.panel').on('shown.bs.collapse', function (e) {
// 		$('#jdtListCommonCode').dataTable().fnAdjustColumnSizing();
// 	});
	
	fun_codeGroupSelect();
	
	fun_setjdtListCommonCode(function(){
		fun_selectjdtListCommonCode(function(){

		});
	});
	
	$("input:text[numberOnly]").on("keyup", function() {
	      $(this).val($(this).val().replace(/[^0-9]/g,""));
	   });
	
	$("#txt_searchText").on('keyup click', function () {
		searchDataTable();	   
	});
	
	$("#chk_searchTable").on('keyup click', function () {
		searchDataTable();
	});
	
	$("#searchCodeGroup").on('change', function () {
		fun_selectjdtListCommonCode(function(){});
    });
	
});

function searchDataTable(){
	if($('#chk_searchTable').is(':checked')){
	      $("#jdtListCommonCode").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	}
	else{
		$("#jdtListCommonCode").DataTable().search("").draw();
	}
}

function fun_getGroupSelect(argResult){
	console.log("========================");
	console.log(argResult);
	
	$('#searchCodeGroup').empty();
	
	var appendStr = '<option value="">--전체--</option>';
	 
	for(var i=0; i<argResult.length; i++){
		appendStr = appendStr + '<option value="'+argResult[i].codeGroup+'">'+argResult[i].codeGroup+'</option>';
	}
	$('#searchCodeGroup').append(appendStr);
	
}

function fun_codeGroupSelect(){
	var inputData = {};
	
	fun_ajaxPostSend("/admin/select/tCommonCodeGroup.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			fun_getGroupSelect(tempResult);
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}


function fun_selectjdtListCommonCode(callback){
	
	var searchText = $("#txt_searchText").val();
	var searchStartDt = $("#search_startDt").val();
	var searchEndDt = $("#search_endDt").val();
	var searchCodeGroup = $("#searchCodeGroup").val();
	var inputData = {"searchText": searchText, "searchStartDt": searchStartDt,"searchEndDt": searchEndDt, "searchCodeGroup": searchCodeGroup};
	
	console.log(inputData);
	
	fun_ajaxPostSend("/admin/select/tCommon.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			fun_dataTableAddData("#jdtListCommonCode", tempResult);
			callback();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}


function fun_setjdtListCommonCode(callback) {
	jdtListCommonCode = $("#jdtListCommonCode").DataTable({
		"columns": [
			  { "title": "코드그룹", "data": "codeGroup"}      
			, { "title": "값", "data": "codeValue"}
			, { "title": "이름", "data": "codeName"}
			, { "title": "내용", "data": "codeDescription"}
			, { "title": "순서", "data": "dispOrder" }
			, { "title": "등록일자", "data": "insDt" }
			, { "title": "관리", "data": "add" }
		]
		, "sort": false                     // 소팅 여부
		, "paging": false            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "filter": true               // 검색 부분 사용 여부
		, "autoWidth": true
// 		, "search": true
// 		, "scrollXInner": "100%"
	//			, "scrollX": "100%"             // X축 스크롤 사이즈 처리
	//			, "scrollY": "235"              // 테이블 높이 설정 ( 테이블의 스크롤 Y축 설정 )
		, "order": [[ 0, "desc" ]]
		, "deferRender": true                // defer
		, "lengthMenu": [10,20,50]           // Row Setting [-1], ["All"]
		, "lengthChange": true
		, "dom": 't<"bottom"p><"clear">'
		, "language": {
			"search": "검색",
			"zeroRecords": "데이터가 없습니다."
		}
		, "columnDefs": [
			 {
				"targets": [0]
				, "class": "text-left"
			}
			, {
				"targets": [1]
				, "class": "text-left"
			}
			, {
				"targets": [2]
				, "class": "text-left"
			}
			, {
				"targets": [3]
				, "class": "text-left"
				, "render": function (data, type, row, meta) {
					var insertTr = "";
					if ( row.codeDescription.length > 50 ){
						insertTr = row.codeDescription.substring(0, 50) + "..";
					}
					else{
						insertTr = row.codeDescription
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
			}
			, {
				"targets": [6]
				, "class": "text-center"
				, "render": function (data, type, row, meta) {
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_clickjdtListCommonCode(' + meta.row + ')">상세보기</button>'; 
					return insertTr;
                }
			}
		]
	});
	callback();
};

var gfFlag = "";
function fun_insert(){
	fun_changeAfterinit();
	$("#section1_detail_view").removeAttr("style");
	gfFlag = "I";
	$("#btnCancel").hide();
}

function fun_clickjdtListCommonCode(rowIdx) {
	
	fun_changeAfterinit();
	
	var table = $("#jdtListCommonCode").DataTable();
	var row = table.rows(rowIdx).data()[0];
	
	console.log(row);
	
	var checkData = row.codeGroup;

	if (checkData != undefined) {
		jdtListLastSelectRowIndex = row.seq;
		$("#txt_codeGroup").val(row.codeGroup);
		$("#txt_codeValue").val(row.codeValue);
		$("#txt_codeGroup").prop("disabled", true);
		$("#txt_codeValue").prop("disabled", true);
		$("#txt_codeName").val(row.codeName);
		$("#txt_codeDescription").val(row.codeDescription);
		$("#txt_dispOrder").val(row.dispOrder);
		
		$("#section1_detail_view").removeAttr("style");
		gfFlag = "U";
		$("#btnCancel").show();
	}
};

//==================================JQuery DataTable Setting 끝==================================


//=== 추가/수정 이후 히든값 및 텍스트 초기화
function fun_changeAfterinit() {
	$("#txt_codeGroup").val('');
	$("#txt_codeValue").val('');
	$("#txt_codeName").val('');
	$("#txt_codeDescription").val('');
	$("#txt_adminPassword").val('');
	$("#txt_codeGroup").prop("disabled", false);
	$("#txt_codeValue").prop("disabled", false);
	$("#txt_dispOrder").val('');
};	


function fun_clickButtonDeleteCommonCode(){
	var password = $("#txt_adminPassword").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	if(password==''||password==null){
		$("#txt_adminPassword").focus();
		alert('로그인 비밀번호를 입력해주세요');
		return false;
	}

	if( $("#txt_codeGroup").val() == '' ||  $("#txt_codeValue").val() == '-1'){
		alert('코드그룹과 값을 선택해주세요');
		return false;
	}
	if (confirm('삭제 하시겠습니까?')){
		var inputData = {  "codeGroup" : $("#txt_codeGroup").val()
				, "codeValue" : $("#txt_codeValue").val()
				, "codeName" : $("#txt_codeName").val()
				, "codeDescription" : $("#txt_codeDescription").val()
				, "dispOrder" : $("#txt_dispOrder").val()
				, 'password': shaPassword
		};
		
		$.ajax({
			type: 'POST'
			, url: '/admin/delete/tCommon.do'
			, async: false
			, data: JSON.stringify(inputData)
			, contentType: 'application/json; charset=utf-8'
			, dataType: 'json'
			, success: function (msg) {
				if(msg.code == "0000"){
					fun_changeAfterinit();
					alert("삭제 되었습니다");
					
					fun_selectjdtListCommonCode(function(){
					});
					$('#exampleModalScrollable').modal('hide');
				}
				else if(msg.code == "0001"){
					$("#txt_adminPassword").val('');
					$("#txt_adminPassword").focus();
					alert("비밀번호가 다릅니다.");
				}
				else{

				}
			}
			, error: function (xhr, status, error) {
				alert("code : " + xhr.status + "\r\nmessage : " + xhr.responseText);
			}
		});
	}
	else {
	}
	return false;
}


function fun_clickButtonOfInsert(){
	
	if (gfFlag == "I"){
		fun_clickButtonInsertCommonCode();
	}
	else{
		fun_clickButtonUpdateCommonCode();
	}
	
}

function fun_clickButtonUpdateCommonCode(){
	
	if( $("#txt_codeGroup").val() == '' ||  $("#txt_codeValue").val() == ''){
		alert('코드그룹과 값을 선택해주세요');
		return false;
	}
	var password = $("#txt_adminPassword").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	if(password==''||password==null){
		$("#txt_adminPassword").focus();
		alert('로그인 비밀번호를 입력해주세요');
		return false;
	}

	if (confirm('수정 하시겠습니까?')){
		var inputData = {  "codeGroup" : $("#txt_codeGroup").val()
				, "codeValue" : $("#txt_codeValue").val()
				, "codeName" : $("#txt_codeName").val()
				, "codeDescription" : $("#txt_codeDescription").val()
				, "dispOrder" : $("#txt_dispOrder").val()
				, 'password': shaPassword
		};
		
		$.ajax({
			type: 'POST'
			, url: '/admin/update/tCommon.do'
			, async: false
			, data: JSON.stringify(inputData)
			, contentType: 'application/json; charset=utf-8'
			, dataType: 'json'
			, success: function (msg) {
				if(msg.code == "0000"){
					fun_changeAfterinit();
					alert("수정이 완료되었습니다");
					fun_selectjdtListCommonCode(function(){});
					$('#exampleModalScrollable').modal('hide');
				}
				else if(msg.code == "0002"){
					alert("코드 그룹 혹은 값이 중복되었습니다.");
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
	else {
	}
	return false;
}


function fun_clickButtonInsertCommonCode(){
	var password = $("#txt_adminPassword").val();
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	if(password==''||password==null){
		$("#txt_adminPassword").focus();
		alert('로그인 비밀번호를 입력해주세요');
	}
	else{
		var inputData = {  "codeGroup" : $("#txt_codeGroup").val()
				, "codeValue" : $("#txt_codeValue").val()
				, "codeName" : $("#txt_codeName").val()
				, "codeDescription" : $("#txt_codeDescription").val()
				, "dispOrder" : $("#txt_dispOrder").val()
				, 'password': shaPassword
		};
	
		$.ajax({
			type: 'POST'
			, url: '/admin/insert/tCommon.do'
			, async: false
			, data: JSON.stringify(inputData)
			, contentType: 'application/json; charset=utf-8'
			, dataType: 'json'
			, success: function (msg) {
				if(msg.code == "0000"){
					//$("#hdf_adminUserSeq").val('-1');
					fun_changeAfterinit();
					alert("저장이 완료되었습니다");
					fun_selectjdtListCommonCode(function(){});
					$('#exampleModalScrollable').modal('hide');
				}
				else if(msg.code == "0002"){
					alert("코드 그룹 혹은 값이 중복되었습니다.");
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

	return false;
}


</script>



<!-- <form id="membership" method="post" enctype="multipart/form-data" action=""> -->

	<div class="wrapper">
          <div class="content-wrapper">
            <!-- 상단 title -->
            <div class="content-header">
               <div class="container-fluid">
                  <div class="row">
                     <div class="col">
                        <h1 class="title">TB 공통코드 수정</h1>
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
                                    	<th>코드그룹</th>
                                        <td>
                                           <div class="row row-10 align-items-center">
                                                  <select id="searchCodeGroup" class="form-control" style="width:50%;">
		                                            <option value="">--전체--</option>
		                                        </select>
                                           </div>
                                        </td>
                                    
                                        <th>검색어</th>
                                        <td>
                                           <div class="row row-10 align-items-center">
                                                  <input type="text" style="width:84%;" class="form-control" placeholder="코드정보" id="txt_searchText" name="searchText" onKeypress="" />
                                                  <input type="checkbox" style="width:34px; margin-left: 1%;" class="form-control" id="chk_searchTable"  />
                                           </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="btns">
                                <button type="button" class="btn btn-dark min-width-90px" onclick="fun_selectjdtListCommonCode(function(){});">검색</button>
                            </div>
                        </div>
                    </section>

                    <section id="section1">
                         <div class="row justify-content-between align-items-end mb-3">
                        	<input  type="hidden" id="totalCnt" name="totalCnt" />
                            <div class="col-auto">
                            </div>
                            <div class="col-auto">
                            	<button type="button" class="btn btn-primary mr-1" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_insert();">코드등록</button>
                                <select id="nameStopLength" class="custom-select w-auto" style="display:none;">
                                	<option value="10">10</option> 
                                	<option value="20">20</option>
                                	<option value="50">50</option>
                                </select>
                            </div>
                        </div>
                         <div class="main_search_result_list">
                                <table id="jdtListCommonCode" class="table table-bordered">
	                                <thead>
	                                	<tr>
	                                        <th class="text-center" width="10%">코드그룹</th>
	                                       	<th class="text-center" width="10%">값</th>
	                                        <th class="text-center" width="23%">이름</th>
	                                        <th class="text-center" >내용</th>   
	                                        <th class="text-center" width="8%">순서</th>
	                                        <th class="text-center" width="12%">등록일자</th>   
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
                                     <th>코드그룹</th>
                                     <td>
                                     	<input type="text" id="txt_codeGroup" class="form-control" placeholder="object_code" maxlength="30"/>
                                     </td>
                                     <th>값</th>
                                     <td>
                                     	<input type="text" ID="txt_codeValue" class="form-control" placeholder="Ex) Value" maxlength="30" />
                                     </td>
                                  </tr>
                                  
                                  <tr> 
                                     <th>이름</th>
                                     <td>
                                     	<input type="text" ID="txt_codeName" class="form-control" placeholder="Ex) 코드 이름" maxlength="60" />
                                     </td>
                                     <th>순서</th>
                                     <td>
                                     	<input type="text" ID="txt_dispOrder" class="form-control" placeholder="Ex) 0,1,2,3..." numberOnly />
                                     </td>
                                  </tr>
                                  <tr> 
                                     <th>내용</th>
                                     <td colspan="3">
                                     	<textarea id="txt_codeDescription" name="txt_codeDescription" class="form-control"
									          rows="5" cols="33" maxlength="1000" >
									</textarea>
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
                            <button type="button" class="btn btn-primary" onclick="return fun_clickButtonOfInsert();">저장</button>
                            <button type="button" id="btnCancel" class="btn btn-danger" onclick="return fun_clickButtonDeleteCommonCode();" >삭제</button>
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
    
    
    
    
<!-- </form> -->
