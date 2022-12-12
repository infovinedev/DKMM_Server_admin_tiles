<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>

var jdtListMain;
var jdtListMainDetail;

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
		$('#jdtListMain').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
	});


	fun_setJdtListProgram(function(){
		fun_selectJdtListProgram(function(){

		});
	});
	
	$("#txt_searchText").on('keyup click', function () {
		searchDataTable();	   
	});
	
	$("#chk_searchTable").on('keyup click', function () {
		searchDataTable();
	});
	
	$("input:text[numberOnly]").on("keyup", function() {
	      $(this).val($(this).val().replace(/[^0-9]/g,""));
	   });
	
	$("#txt_programId").focus();
	$("#hdf_adminProgramSeq").val('-1');
	
});

function searchDataTable(){
	if($('#chk_searchTable').is(':checked')){
	      $("#jdtListMain").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	}
	else{
		$("#jdtListMain").DataTable().search("").draw();
	}
}

function fun_selectJdtListProgram(callback){
	var searchText = ""; //$("#txt_searchText").val();
	var searchStartDt = $("#search_startDt").val();
	var searchEndDt = $("#search_endDt").val();
	
	
	var inputData = {"searchText": searchText, "searchStartDt": searchStartDt,"searchEndDt": searchEndDt};
	
	console.log(inputData);
	
	fun_ajaxPostSend("/admin/select/programMenu.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			fun_dataTableAddData("#jdtListMain", tempResult);
			callback();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}


function fun_setJdtListProgram(callback) {
	jdtListMain = $("#jdtListMain").DataTable({
		"columns": [
			  { "title": "Seq", "data": "adminProgramSeq" }
			, { "title": "프로그램이름", "data": "programName" }
			, { "title": "프로그램ID", "data": "programId" }
			, { "title": "상위ID", "data": "parentsProgramId" }
			, { "title": "레벨", "data": "level" }
			, { "title": "정렬", "data": "programSort" }
			, { "title": "경로", "data": "location" }
			, { "title": "사용여부", "data": "useYn" }
			, { "title": "만든일자", "data": "regDate" }
			, { "title": "수정일자", "data": "updateDate" }
			, { "title": "수정", "data": "add" }
			
		]
		, "sort": false                     // 소팅 여부
		, "paging": false            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "filter": true               // 검색 부분 사용 여부
		, "autoWidth": false
		, "search": true
		, "scrollXInner": "100%"
// 			, "scrollX": "100%"             // X축 스크롤 사이즈 처리
// 			, "scrollY": "235"              // 테이블 높이 설정 ( 테이블의 스크롤 Y축 설정 )
		, "order": [[ 0, "desc" ]]
		, "deferRender": true                // defer
		, "lengthMenu": [10,20,50]           // Row Setting [-1], ["All"]
		, "lengthChange": true
		, "dom": 't<"bottom"p><"clear">'
		, "language": {
			"zeroRecords": "데이터가 없습니다."
		}
		, "columnDefs": [               // 컬럼 정의 부분 (컬럼별 옵션 처리)
			 {
				"targets": [0]
				,	"class": "text-center"
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
			}
			, {
				"targets": [5]
				, "class": "text-center"
			}
			, {
				"targets": [6]
				, "class": "text-left"
			}
			, {
				"targets": [7]
				, "class": "text-center"
			}
			, {
				"targets": [8]
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
				"targets": [9]
				, "class": "text-center"
				, "render": function (data, type, row, meta) {
					var insertTr = "";
					if ( row.updateDate != "" ){
						insertTr = row.updateDate.substring(0,4) + "-" + row.updateDate.substring(4,6) + "-" + row.updateDate.substring(6,8);
						insertTr = insertTr + " " +  row.updateDate.substring(8,10) + ":" + row.updateDate.substring(10,12) + ":" + row.updateDate.substring(12,14);
					}
					return insertTr;
                }
			}
			, {
				"targets": [10]
				, "class": "text-center"
				, "render": function (data, type, row, meta) {
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_clickJdtListMain(' + meta.row + ')">상세보기</button>'; 
					return insertTr;
                }
			}
		]
	});
	callback();
};

function formReset(){
	$("#hdf_adminProgramSeq").val("");
	$("#txt_programId").val("");
	$("#txt_programName").val("");
	$("#txt_parentsProgramId").val("");
	$("#txt_location").val("");
	$("#sel_level").val("");
	$("#sel_useYn").val("");
	$("#txt_programSort").val("");
}

var gfFlag = "";
function fun_insert(){
	formReset();
	$("#hdf_adminProgramSeq").val("-1");
	$("#section1_detail_view").removeAttr("style");
	gfFlag = "I";
	$("#btnCancel").hide();
}


function fun_clickJdtListMain(rowIdx) {
	var table = $("#jdtListMain").DataTable();
	var row = table.rows(rowIdx).data()[0];
	
	console.log(row);
	
	var checkData = row.adminProgramSeq;

	if (checkData != undefined) {
		$("#hdf_adminProgramSeq").val(row.adminProgramSeq);
		$("#txt_programId").val(row.programId);
		$("#txt_programName").val(row.programName);
		$("#txt_parentsProgramId").val(row.parentsProgramId);
		$("#txt_location").val(row.location);
		$("#sel_level").val(row.level);
		$("#sel_useYn").val(row.useYn);
		$("#txt_programSort").val(row.programSort);
		
		$("#section1_detail_view").removeAttr("style");
		
		gfFlag = "U";
		$("#btnCancel").show();
	}
	else{
		fun_insert();
	}
};


function fun_validationSaveChk(){
	if($("#txt_programId").val()==""){
		$("#txt_programId").focus();
		alert("프로그램 아이디을 입력 해주세요.");
		return false;
	}

// 	if($("#txt_parentsProgramId").val()==""){
// 		$("#txt_parentsProgramId").focus();
// 		alert("상위메뉴 아이디을 입력 해주세요.");
// 		return false;
// 	}

	if($("#txt_programName").val()==""){
		$("#txt_programName").focus();
		alert("프로그램 이름을 입력 해주세요.");
		return false;
	}

// 	if($("#txt_location").val()==""){
// 		$("#txt_location").focus();
// 		alert("경로를 입력 해주세요.");
// 		return false;
// 	}

	if($("#sel_level option:selected").val()==""){
		$("#sel_level").focus();
		alert("레벨을 선택해주세요.");
		return false;
	}
	else{
		if($("#sel_level option:selected").val()=="0"){
			$("#sel_level").focus();
			alert("레벨을 선택해주세요.");
			return false;	
		}
	}

	if($("#sel_useYn option:selected").val()==""){
		$("#sel_useYn").focus();
		alert("사용여부를 선택해주세요.");
		return false;
	}
	else{
		if($("#sel_useYn option:selected").val()==""){
			$("#sel_useYn").focus();
			alert("사용여부를 선택해주세요.");
			return false;	
		}
	}
	
	if($("#txt_programSort").val()==""){
		$("#txt_programSort").focus();
		alert("순서를 입력 해주세요.");
		return false;
	}

	if($("#txt_adminPassword").val()==""){
		$("#txt_adminPassword").focus();
		alert("로그인 비밀번호를 입력 해주세요.");
		return false;
	}

	return true;
}



function fun_clickButtonOfInsertProgramMenu() {
	if(fun_validationSaveChk()){
	}
	else{
		return false;
	}
	
	if (confirm('등록 및 수정하시겠습니까?')){
		var password = $("#txt_adminPassword").val();
		var shaPassword = "";
		if(password != ""){
			shaPassword = hex_sha512(password);
		}
		var inputData = { 'adminProgramSeq': $("#hdf_adminProgramSeq").val()
				, 'programId' :$("#txt_programId").val()
				, 'parentsProgramId' :$("#txt_parentsProgramId").val()
				, 'level':$("#sel_level option:selected").val()
				, 'programName':$("#txt_programName").val()
				, 'programSort':$("#txt_programSort").val()
				, 'useYn': $("#sel_useYn option:selected").val()
				, 'location':$("#txt_location").val()
				, 'password': shaPassword
		};

		fun_ajaxPostSend("/admin/insert/programMenu.do", inputData, true, function(msg){
			if(msg!=null){
				switch(msg.code){
					case "0000":
						$("#hdf_adminProgramId").val('-1');
						$("#txt_programId").val('');
						$("#txt_parentsProgramId").val('');
						$("#txt_programName").val('');
						$("#txt_location").val('');
						$("#sel_level").val('0');
						$("#sel_useYn").val('Y');
						$("#txt_programSort").val('');
						$("#txt_adminPassword").val('');
						alert("저장되었습니다");
						
						fun_selectJdtListProgram(function(){
						});
						
						$('#exampleModalScrollable').modal('hide');
						
						break;
					case "0001":
						alert("저장에 실패 하였습니다");
						break;
				}
				
			}
			else{
				//alert('서비스가 일시적으로 원활하지 않습니다.');
			}
		});
	}
	//=== Save Line Data
	//var inputData = $('#jdtListMainDetail').tableToJSON({"headings":["idx", "restateRegion", "businessName", "builder", "notiDay", "state"], "ignoreEmptyRows":true});

	return false;
};


function fun_clickButtonOfDeleteProgramMenu(){
	if( $("#hdf_adminProgramSeq").val() == '-1' ||  $("#hdf_adminProgramSeq").val() == null){
		alert("프로그램을 선택해주세요");
		return false;
	}
	if (confirm('프로그램을 사용하지 않으시겠습니까?')){
		var password = $("#txt_adminPassword").val();
		var shaPassword = "";
		if(password != ""){
			shaPassword = hex_sha512(password);
			var inputData = { 'adminProgramSeq': $("#hdf_adminProgramSeq").val()
					, 'password': shaPassword
			};

			fun_ajaxPostSend("/admin/delete/programMenu.do", inputData, true, function(msg){
				if(msg!=null){
					switch(msg.code){
						case "0000":
							$("#hdf_adminProgramId").val('-1');
							$("#txt_programId").val('');
							$("#txt_parentsProgramId").val('');
							$("#txt_programName").val('');
							$("#txt_location").val('');
							$("#sel_level").val('0');
							$("#sel_useYn").val('Y');
							$("#txt_programSort").val('');
							$("#txt_adminPassword").val('');
							alert("삭제되었습니다");
							$('#exampleModalScrollable').modal('hide');
							break;
						case "0001":
							alert("삭제에 실패 하였습니다");
							break;
					}
					fun_selectJdtListProgram(function(){
					});
					
				}
				else{
					//alert('서비스가 일시적으로 원활하지 않습니다.');
				}
			});
		}
		else{
			$("#txt_adminPassword").focus();
			alert("로그인 비밀번호를 입력해주세요");
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
                        <h1 class="title">프로그램 메뉴관리</h1>
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
                                <button type="button" class="btn btn-dark min-width-90px" onclick="fun_selectJdtListProgram(function(){});">검색</button>
                            </div>
                        </div>
                    </section>

                    <section id="section1">
                         <div class="row justify-content-between align-items-end mb-3">
                        	<input  type="hidden" id="totalCnt" name="totalCnt" />
                            <div class="col-auto">
                            </div>
                            <div class="col-auto">
                            	<button type="button" class="btn btn-primary mr-1" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_insert();">프로그램등록</button>
                                <select id="nameStopLength" class="custom-select w-auto" style="display:none;">
                                	<option value="10">10</option> 
                                	<option value="20">20</option>
                                	<option value="50">50</option>
                                </select>
                            </div>
                        </div>
                         <div class="main_search_result_list">
                                <table id="jdtListMain" class="table table-bordered">
	                                <thead>
	                                	<th class="text-center" width="3%">adminProgramSeq</th> 
                                        <th class="text-center">금지어명</th>
                                       	<th class="text-center" width="7%">코드</th>
                                        <th class="text-center" width="7%">상위아이디</th>
                                        <th class="text-center" width="4%">레벨</th>   
                                        <th class="text-center" width="4%">정렬</th>   
                                        <th class="text-center" width="15%">경로</th>   
                                        <th class="text-center" width="5%">사용여부</th>   
                                        <th class="text-center" width="11%">만든일자</th>   
                                        <th class="text-center" width="11%">수정일자</th>  
                                        <th class="text-center" width="8%"></th>
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
                                     <th>프로그램아이디</th>
                                     <td>
                                     	<input type="text" id="txt_programId" class="form-control" placeholder="Ex) 10000001" />
                                     </td>
                                     <th>상위메뉴아이디</th>
                                     <td>
                                     	<input type="text" ID="txt_parentsProgramId" class="form-control" placeholder="Ex) 10000001" />
                                     </td>
                                  </tr>
                                  
                                  <tr> 
                                     <th>프로그램이름</th>
                                     <td>
                                     	<input type="text" ID="txt_programName" class="form-control" placeholder="Ex) 프로그램메뉴관리" />
                                     </td>
                                     <th>경로</th>
                                     <td>
                                     	<input type="text" ID="txt_location" class="form-control" placeholder="Ex) ../admin/modifyProgram.do">
                                     </td>
                                  </tr>
                                  
                                  <tr> 
                                     <th>레벨</th>
                                     <td>
                                     	<select id="sel_level" class="form-control" >
                                            <option value="0">--선택--</option>
                                            <option value="1">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                        </select>
                                     </td>
                                     <th>순서</th>
                                     <td>
                                     	<input type="text" ID="txt_programSort" class="form-control" numberOnly />
                                     </td>
                                  </tr>
                                  
                                  <tr> 
                                     <th>사용여부</th>
                                     <td>
                                     	<select id="sel_useYn" class="form-control" >
											<option value="">--선택--</option>
											<option value="Y">Y</option>
                                            <option value="N">N</option>
                                        </select>
                                     </td>
                                     <th>로그인<br>비밀번호</th>
                                     <td>
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
    <input type="hidden" id="hdf_adminProgramSeq" value="" />
</form>
