<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>

var jdtListAdminDefault;
var jdtListProgram;

window.onload = function(){
};

$(document).ready(function () {
	var ua = navigator.userAgent;
	var checker = {
		iphone: ua.match(/(iPhone|iPod|iPad)/),
		blackberry: ua.match(/BlackBerry/),
		android: ua.match(/Android/)
	};

	$("#divUser").show();        
	$("#divProgram").hide();  
	
	//=== jdt_List 사이즈 변환시 테이블 리사이징
	$(window).bind('resize', function () {
		if (checker.android == null || checker.android == "" || checker.android == "null") {
			//$('#jdt_List').dataTable().fnAdjustColumnSizing();
		}
		$('#jdtListAdminDefault').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
		$('#jdtListProgram').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
	});

	$('.panel').on('shown.bs.collapse', function (e) {
		$('#jdtListAdminDefault').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
		$('#jdtListProgram').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
	});

	fun_setjdtListAdminDefault(function(){
		fun_selectjdtListAdminDefault(function(){

		});
	});

	fun_setJdtListProgram(function(){
		fun_selectProgramMenuOfAdminUser(function(){

		});
	});

	$("#hdf_adminUserSeq").val('-1');
	$("#hdf_adminProgramSeq").val('-1');
	
	$("#cbx_SelectAll").on('keyup click', function () {
		fun_SelectAll_jdtListProgramDetail();
	});
	
	$("#txt_searchText").on('keyup click', function () {
		searchDataTable();	   
	});
	
	$("#chk_searchTable").on('keyup click', function () {
		searchDataTable();
	});
});

function searchDataTable(){
	if($('#chk_searchTable').is(':checked')){
	      $("#jdtListAdminDefault").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	}
	else{
		$("#jdtListAdminDefault").DataTable().search("").draw();
	}
}



function fun_SetButtonMode(type) {
	if (type == "A") {
		$("#Content_btn_Modify").attr('disabled', 'disabled');      // disabled 속성 추가
		$("#Content_btn_Add").removeAttr('disabled');               // disabled 속성 제거
	} else if (type == "U") {
		$("#Content_btn_Modify").removeAttr('disabled');
		$("#Content_btn_Add").attr('disabled', 'disabled');
	}
};


function fun_selectjdtListAdminDefault(callback){
	var searchText = $("#txt_searchText").val();
	var inputData = {"searchText": searchText, "codeGroup": "mng_type"};
	
	fun_ajaxPostSend("/common/select/serviceCodeList.do", inputData, true, function(msg){ 
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			fun_dataTableAddData("#jdtListAdminDefault", tempResult);
			callback();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}

function fun_setjdtListAdminDefault(callback) {
	jdtListAdminDefault = $("#jdtListAdminDefault").DataTable({
		"columns": [
			{ "title": "권한", "data": "codeValue"}      
			, { "title": "권한명", "data": "codeName"}
			, { "title": "순서", "data": "dispOrder"}
			, { "title": "등록일", "data": "insDt" }
			, { "title": "관리", "data": "add" }
			 
		]
		, "sort": true                     // 소팅 여부
		, "paging": true            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "autoWidth": false
		, "filter": true               // 검색 부분 사용 여부
		, "search": true
		, "order": [[ 3, "asc" ]]
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
			, "class": "text-center"
			}
			, {
				"targets": [1]
				, "class": "text-left"
			}
			, {
				"targets": [2]
				, "class": "text-center"
			}
			, {
				"targets": [3]
				, "class": "text-center"
			}
			, {
				"targets": [4]
				, "class": "text-center"
				, "render": function (data, type, row, meta) {
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_clickjdtListAdminDefault(' + meta.row + ')">상세보기</button>'; 
					return insertTr;
                }
			}
		]
	});
	callback();
};

function fun_clickjdtListAdminDefault(rowIdx) {
	var table = $("#jdtListAdminDefault").DataTable();
	var row = table.rows(rowIdx).data()[0];
	var checkData = row.codeValue;
	
	if (checkData != undefined) {
		$("#hdf_roleNm").val(row.codeValue);
		$("#divUser").hide();
		$("#divProgram").show();
		fun_clickJdtListProgram(row.codeValue, function(){});     // jdtListProgram Data Binding
		
		$("#section1_detail_view").removeAttr("style");
	}
};


//====================================jdt_ListActivity Row Click Event====================================

function fun_setJdtListProgram(callback) {
	jdtListProgram = $("#jdtListProgram").DataTable({
		"columns": [
			{ 
				"data": null
				, "width": "20px"
				, "defaultContent": "<input type='checkbox' name='chk-program'></input>"
				, "sortable": false
			}  
			, { "title": "Seq", "data": "adminProgramSeq" }
			, { "title": "프로그램이름", "data": "programName" }
			, { "title": "코드", "data": "programId" }
			, { "title": "상위아이디", "data": "parentsProgramId" }
			, { "title": "레벨", "data": "level" }
			, { "title": "정렬", "data": "programSort" }
			, { "title": "경로", "data": "location" }
			, { "title": "사용여부", "data": "useYn" }
		]
		, "sort": false                     // 소팅 여부
		, "paging": false               // 테이블 크기를 넘어선 자료 페이징 처리 여부
		, "info": false                 // 보여지는 페이지 설명 부분 사용 여부
		, "filter": false               // 검색 부분 사용 여부
		, "autoWidth": false            // 테이블 컬럼 너비 자동 설정
		, "language": {
			"zeroRecords": "데이터가 없습니다."
		}                               // 기본 데이터테이블 글자 처리
		, "columnDefs": [               // 컬럼 정의 부분 (컬럼별 옵션 처리)
			{
				"targets": [0]
				,"class": "text-center"
			}
			, {
				"targets": [1]
				, visible: true
				, searchable: true
			}
			, {
				"targets": [2]
				, "class": "text-left"
			}
			, {
				"targets": [3]
				, "class": "text-center"
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
			}
			, {
				"targets": [7]
				, "class": "text-left"
			}
			, {
				"targets": [8]
				, "class": "text-center"
			}
		]
	});
	callback();
};


function fun_clickJdtListProgram(roleNm, callback) {
	//체크상태가 있을 수 있는 row값을 초기화한다
	$("#cbx_SelectAll").prop('checked', false); 
	for(var i=0; i<$("#jdtListProgram tbody tr").length;i++){
		$("input:checkbox[name=chk-program]")[i].checked = false;
	}

	var inputData = { "roleNm" : roleNm };
	
	fun_ajaxPostSend("/admin/select/permissionOfDefaultAdmin.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					if(msg.result!=undefined){
						// var tempAdminProgram = [];
						var tempResult = JSON.parse(msg.result);

						for(var i=0; i<tempResult.length;i++){
							var adminProgramSeq = tempResult[i].adminProgramSeq;
							for(var j=0; j<$("#jdtListProgram tbody tr").length; j++){
								var tempProgramSeq = $("#jdtListProgram tbody tr")[j].children[1].innerText;
								if(tempProgramSeq==adminProgramSeq){
									$("#jdtListProgram tbody tr")[j].children[0].children[0].checked = true;
								}
							}
						}
					}
					break;
				case "0001":
					tempAdminProgram = tempResult;
					break;
				}
			callback();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
};


function fun_selectProgramMenuOfAdminUser(callback){
	var inputData = {};
	fun_ajaxPostSend("/admin/select/programMenuOfPermission.do", inputData, true, function(msg){
		if(msg!=null){
			var tempAdminProgram = [];
			var tempResult = JSON.parse(msg.result);
			switch(msg.code){
				case "0000":
					fun_dataTableAddData("#jdtListProgram", tempResult);
					break;
				case "0001":
					break;
			}
			callback();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}

function fun_checkValidation(){
	
}


//=== 전체선택 체크시 이벤트
function fun_SelectAll_jdtListProgramDetail() {
	var chk_SelectAll = $("#cbx_SelectAll").is(':checked');             // 전체선택 체크시 true
	var tr = $("#jdtListProgram tbody tr");

	if (tr[0].innerText != "데이터가 없습니다.") {                              // Row에 추가된 값이 있을시
		if (chk_SelectAll) {
			$("input[name='chk-program']").prop('checked', true);
		} else {
			$("input[name='chk-program']").prop('checked', false);
		}

	} else {                                                                    // Row에 추가된 값이 없을시
		$("#cbx_SelectAll").attr('checked', false);                     // 전체선택 체크 해제
	}
};



function fun_clickButtonOfModify() {
	if (confirm("수정 하시겠습니까?")) {
		var password = $("#txt_adminPassword").val();
		
		var shaPassword = "";
		if(password != ""){
			shaPassword = hex_sha512(password);
		}
		else{
			$("#txt_adminPassword").focus();
			alert("로그인 비밀번호를 입력해주세요");
			return false;
		}

		var tempPermission = [];
		for(var i=0; i<$("#jdtListProgram tbody tr").length; i++){
			if($("#jdtListProgram tbody tr")[i].children[0].children[0].checked){
				
				console.log($("#jdtListProgram tbody tr")[i]);
				
				var adminProgramSeq = $("#jdtListProgram tbody tr")[i].children[1].innerText;
				var permission = {"adminProgramSeq": adminProgramSeq, "roleNm":$("#hdf_roleNm").val()};
				tempPermission.push(permission);
			}
		}
		
		var inputData = {
			'password': shaPassword
			, "permission" : tempPermission
		};
		fun_ajaxPostSend("/admin/insert/programPermissionOfDefaultAdmin.do", inputData, true, function(msg){
			if(msg!=null){
				switch(msg.code){
					case "0000":
						alert("권한이 부여 되었습니다");
						//fun_dataTableAddData("#jdtListProgram", tempResult);
						break;
					case "0001":
						alert("권한을 부여 할 수 없습니다");
						break;
				}
				$("#txt_adminPassword").val("");
			}
			else{
				$("#txt_adminPassword").val("");
				//alert('서비스가 일시적으로 원활하지 않습니다.');
			}
		});
	}
	return false;
};

//=== 취소 버튼 클릭시 이벤트 함수
function fun_clickButtonOfCancel() {
	$("#divProgram").hide();
	$("#divUser").show();
	return false;
};
</script>



<form id="membership" method="post" enctype="multipart/form-data" action="">
   	
   	<div class="wrapper">
          <div class="content-wrapper">
            <!-- 상단 title -->
            <div class="content-header">
               <div class="container-fluid">
                  <div class="row">
                     <div class="col">
                        <h1 class="title">ADMIN USER 목록</h1>
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
                                    	<th>검색어</th>
                                        <td colspan="3">
                                           <div class="row row-10 align-items-center">
                                                  <input type="text" style="width:84%;" class="form-control" placeholder="검색어" id="txt_searchText" name="searchText" onKeypress="" />
                                                  <input type="checkbox" style="width:34px; margin-left: 1%;" class="form-control" id="chk_searchTable"  />
                                           </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="btns">
                                <button type="button" class="btn btn-dark min-width-90px" onclick="fun_selectjdtListAdminDefault(function(){});">검색</button>
                            </div>
                        </div>
                    </section>

                    <section id="section1">
                         <div class="row justify-content-between align-items-end mb-3">
                        	<input  type="hidden" id="totalCnt" name="totalCnt" />
                            <div class="col-auto">
                            </div>
                            <div class="col-auto">
<!--                             	<button type="button" class="btn btn-primary mr-1" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_insert();">코드등록</button> -->
                                <select id="nameStopLength" class="custom-select w-auto" style="display:none;">
                                	<option value="10">10</option> 
                                	<option value="20">20</option>
                                	<option value="50">50</option>
                                </select>
                            </div>
                        </div>
                         <div class="main_search_result_list">
                                <table id="jdtListAdminDefault" class="table table-bordered">
	                                <thead>
	                                	<tr>
	                                        <th class="text-center" width="25%">권한</th>
	                                       	<th class="text-center">권한명</th>
	                                       	<th class="text-center" width="10%">순서</th>
	                                        <th class="text-center" width="15%">등록일</th>   
	                                        <th class="text-center" width="12%">관리</th>
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
                            <table id="jdtListProgram" class="table table-bordered" style="margin-left:13px;" >
                                <thead>
                                	<th class="text-center" width="3%"><input type='checkbox' id="cbx_SelectAll" name='cbx_SelectAll'></input></th>
                                	<th class="text-center" width="5%">adminProgramSeq</th> 
                                       <th class="text-center">프로그램이름</th>
                                      	<th class="text-center" width="8%">코드</th>
                                       <th class="text-center" width="8%">상위아이디</th>
                                       <th class="text-center" width="5%">레벨</th>   
                                       <th class="text-center" width="5%">정렬</th>   
                                       <th class="text-center" width="20%">경로</th>   
                                       <th class="text-center" width="5%">사용여부</th>   
                                </thead>
                                <tbody>
                                                    
                                </tbody>
	                        </table>
	                        <br/>
                            <table class="table table-bordered">
                               <colgroup>
                                  <col style="width:15%">
                                  <col style="width:35%">
                                  <col style="width:15%">
                                  <col style="width:35%">
                               </colgroup>
                               <tbody>
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
                            <button type="button" class="btn btn-primary" onclick="return fun_clickButtonOfModify();">저장</button>
<!--                             <button type="button" id="btnCancel" class="btn btn-danger" onclick="return fun_clickButtonDeleteCommonCode();" >전체삭제</button> -->
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
   	
   	
   	
	 <input type="hidden" id="hdf_adminProgramSeq" value="" />
     <input type="hidden" id="hdf_roleNm" value="" />
</form>
