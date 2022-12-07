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
			//$('#jdt_List').dataTable().fnAdjustColumnSizing();
		}
		$('#jdtListCommonCode').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
	});

	$('.panel').on('shown.bs.collapse', function (e) {
		$('#jdtListCommonCode').dataTable().fnAdjustColumnSizing();
	});

	fun_initializeClickEvent();
	fun_setjdtListCommonCode(function(){
		fun_selectjdtListCommonCode(function(){

		});
	});
	$("#hdf_adminUserSeq").val('-1');

	
	//$("#txt_codeGroup").val("test");
	//$("#txt_codeValue").val("b");
	//$("#txt_codeName").val("00");
	//$("#txt_codeDescription").val("1");
});


function fun_selectjdtListCommonCode(callback){
	var inputData = { };
	
	fun_ajaxPostSend("/admin/select/tbCommon.do", inputData, true, function(msg){
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

function fun_initializeClickEvent(){
	$('#jdtListCommonCode').delegate('tr', 'click', function () {
		// 빈테이블이 아닐때
		if(typeof(jdtListCommonCode.row(this).data()) !== "undefined") {
			var chk = $(this).hasClass('selected');
			if (chk) {
				$(this).removeClass('selected');
				
				this.children[0].lastChild.checked = false;
				//$(this)[0].children(0).lastChild.checked = false;
				jdtListLastSelectRowIndex = -1;
				jdtListLastPagenate = -1;
				
				$("#txt_codeGroup").prop("disabled", false);
				$("#txt_codeValue").prop("disabled", false);

				fun_changeAfterinit();
			} else {
				$("#jdtListCommonCode tbody tr").removeClass('selected');
				$("#cbx_SelectAll").attr('checked', false);         // 전체선택 체크 해제
				$("input[name='chk-admin']").prop('checked', false);  // 선택 줄 외 체크 해제
				$(this).toggleClass('selected');
				this.children[0].lastChild.checked = true;
				//$(this)[0].children(0).lastChild.checked = true;
				jdtListLastPagenate = jdtListCommonCode.page();
				
				fun_clickjdtListCommonCode();   // 선택한 줄 값 라인에 입력
			}
		}
	});

	$("#txt_userId").on("keyup", function(e){
		if(e.keyCode==13){
			$("#txt_newPassword").focus();
		}
	});

	$("#txt_newPassword").on("keyup", function(e){
		if(e.keyCode==13){
			$("#txt_userName").focus();
		}
	});

	$("#txt_userName").on("keyup", function(e){
		if(e.keyCode==13){
			$("#sel_userTypeCode").focus();
		}
	});

	$("#sel_userTypeCode").change(function(e){
		$("#txt_adminPassword").focus();
	});

	$("#txt_adminPassword").on("keyup", function(e){
		if(e.keyCode==13){
			$("#btn_Save").trigger("click");
		}
	});


	//테이블 검색시
	$("#txt_searchParcelInfo").on('keyup click', function () {
		$("#jdtListCommonCode").DataTable().search(
			$("#txt_searchParcelInfo").val()
		).draw();
	});

	//추가
	$("#btn_itemCode").on("click", function(){
		if($("#hdf_memberId").val()==""){
			if (confirm('고객정보가 없습니다\n추가하시겠습니까?')) {
				setTimeout(function () {
					$("#btn_memberCode").trigger('click');
				}, 800);
			}
			
			return false;
		}
	});

	$('#btn_DeleteSelect').click(function () {
		var oTable = $("#jdtListCommonCodeDetail").DataTable();
		var t = $("#jdtListCommonCodeDetail").dataTable();
		
		var chk = $("#cbx_SelectAll").is(':checked');
		if (chk) {
			t.fnClearTable();                               // 전체 선택 시 테이블 클리어
		} else {
			oTable.row('.selected').remove().draw(false);   // 해당 클래스의 줄 삭제
		}
		
		chk_HasSel = true;
		$("#cbx_SelectAll").attr('checked', false);             // 전체선택 체크 해제
		fun_changeAfterinit();                          // 라인 입력값 삭제
	});
}


var jdtListRow = 0;
function fun_setjdtListCommonCode(callback) {
	jdtListCommonCode = $("#jdtListCommonCode").DataTable({
		"columns": [
			{ 
				//"title": "<input type='checkbox' id='cbx_SelectAll' onclick='fun_SelectAll_jdt_ListMain();' class='ace' />"
				"data": null
				, "width": "20px"
				, "defaultContent": "<input type='checkbox' name='chk-admin'></input>"
				, "sortable": false
			}
			, { "title": "seq", "data": "seq"}
			, { "title": "코드그룹", "data": "codeGroup"}      
			, { "title": "값", "data": "codeValue"}
			, { "title": "이름", "data": "codeName"}
			, { "title": "내용", "data": "codeDescription"}
			, { "title": "등록일자", "data": "regDate" }
		]
		// , "rowCallback": function (row, data, index) {  // 로우 데이터 바인딩후 화면에 보여주기 전 실행 함수
		// 	if($('td', row)[1].outerText!=undefined){
		// 		$('td', row)[1].outerText = parseInt(jdtListRow);
		// 		jdtListRow++;
		// 	}
		// }
		, "paging": false            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "autoWidth": false
		, "scrollY": "350px"
		, "scrollCollapse": true
		, "scrollX": true
		, "scrollXInner": "100%"
		//, "orderClasses": false
		, "order": [[ 1, "asc" ]]
		, "deferRender": true           // defer
		, "lengthMenu": [[20], [20]]           // Row Setting [-1], ["All"]
		, "lengthChange": false
		, "dom": 't<"bottom"p><"clear">'
		, "language": {
			"search": "검색",
			"lengthMenu": " _MENU_ 줄 표시",
			"zeroRecords": "데이터가 없습니다.",
			"info": "page _PAGE_ of _PAGES_",
			"infoEmpty": "",
			"infoFiltered": "(filtered from _MAX_ total records)",
			"paginate": {
				"next": "다음",
				"previous": "이전"
			}
		}
		, "columnDefs": [
			{
				"targets": [1]
				, "class": "hideColumn"
				// , "render": function (data, type, row) {
				// 	jdtListRow++;
				// 	return parseInt(jdtListRow);
                // }
			}
			, {
				"targets": [2]
				, "class": "dt-head-center dt-body-left dtPercent5"
			}
			, {
				"targets": [3]
				, "class": "dt-head-center dt-body-left dtPercent10"
			}
			, {
				"targets": [4]
				, "class": "dt-head-center dt-body-left dtPercent20"
			}
			, {
				"targets": [5]
				, "class": "dt-head-center dt-body-left dtPercent50"
			}
			, {
				"targets": [6]
				, "class": "dt-head-center dt-body-left dtPercent10"
				, "render": function (data, type, row) {
					var timestamp = parseInt(row.regDate);
					var timezoneOffset = new Date().getTimezoneOffset() * 60000;
					var isoString = new Date(timestamp - timezoneOffset).toISOString()
					.replace(/T/, ' ')      // replace T with a space
					.replace(/\..+/, '');     // delete the dot and everything after
                   return isoString;
                }
			}
		]
	});
	callback();
};

function fun_clickjdtListCommonCode() {
	var table = $("#jdtListCommonCode").DataTable();
	var row = table.rows('.selected').data()[0];
	var checkData = row.seq;

	if (checkData != undefined) {
		jdtListLastSelectRowIndex = row.seq;
		$("#txt_codeGroup").val(row.codeGroup);
		$("#txt_codeValue").val(row.codeValue);
		$("#txt_codeGroup").prop("disabled", true);
		$("#txt_codeValue").prop("disabled", true);
		$("#txt_codeName").val(row.codeName);
		$("#txt_codeDescription").val(row.codeDescription);
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
				, 'password': shaPassword
		};
		
		$.ajax({
			type: 'POST'
			, url: '/admin/delete/tbCommon.do'
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
				, 'password': shaPassword
		};
		
		$.ajax({
			type: 'POST'
			, url: '/admin/update/tbCommon.do'
			, async: false
			, data: JSON.stringify(inputData)
			, contentType: 'application/json; charset=utf-8'
			, dataType: 'json'
			, success: function (msg) {
				if(msg.code == "0000"){
					fun_changeAfterinit();
					alert("수정이 완료되었습니다");
					fun_selectjdtListCommonCode(function(){});
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
				, 'password': shaPassword
		};
	
		$.ajax({
			type: 'POST'
			, url: '/admin/insert/tbCommon.do'
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



<form id="membership" method="post" enctype="multipart/form-data" action="">

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
                                        <th>검색어</th>
                                        <td colspan="3">
                                           <div class="row row-10 align-items-center">
                                                  <input type="text" style="width:94%;" class="form-control" placeholder="프로그램이름" id="txt_searchText" name="searchText" onKeypress="" />
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
                                <select id="nameStopLength" class="custom-select w-auto">
                                	<option value="10">10</option> 
                                	<option value="20">20</option>
                                	<option value="50">50</option>
                                </select>
                            </div>
                        </div>
                         <div class="main_search_result_list">
                                <table id="jdtListMain" class="table table-bordered">
	                                <thead>
	                                	<th class="text-center" width="5%">Seq</th> 
                                        <th class="text-center" width="10%" >코드그룹</th>
                                       	<th class="text-center" width="10%">값</th>
                                        <th class="text-center" width="10%">이름</th>
                                        <th class="text-center" >내용</th>   
                                        <th class="text-center" width="10%">등록일자</th>   
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
                                     <th>코드그룹</th>
                                     <td>
                                     	<input type="text" id="txt_codeGroup" class="form-control" placeholder="object_code" />
                                     </td>
                                     <th>값</th>
                                     <td>
                                     	<input type="text" ID="txt_codeValue" class="form-control" placeholder="Ex) 10000001" />
                                     </td>
                                  </tr>
                                  
                                  <tr> 
                                     <th>이름</th>
                                     <td colspan="3">
                                     	<input type="text" ID="txt_codeName" class="form-control" placeholder="Ex) 프로그램메뉴관리" />
                                     </td>
                                  </tr>
                                  <tr> 
                                     <th>내용</th>
                                     <td colspan="3">
                                     	<input type="text" ID="txt_codeDescription" class="form-control" placeholder="Ex) ../admin/modifyProgram.do">
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
                            <button type="button" class="btn btn-primary" onclick="return fun_clickButtonOfInsertProgramMenu();">저장</button>
                            <button type="button" id="btnCancel" class="btn btn-danger" onclick="return fun_clickButtonOfDeleteProgramMenu();" >삭제</button>
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
    
    
    
    
</form>
