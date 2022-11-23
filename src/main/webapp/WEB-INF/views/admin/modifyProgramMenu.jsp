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

	$('.panel').on('shown.bs.collapse', function (e) {
		$('#jdtListMain').dataTable().fnAdjustColumnSizing();
	});

	fun_initializeClickEvent();
	fun_setJdtListProgram(function(){
		fun_selectJdtListProgram(function(){

		});
	});

	$("#txt_programId").focus();
	$("#hdf_adminProgramSeq").val('-1');
	// $("#txt_programId").val('1234');
	// $("#txt_parentsProgramId").val('5678');
	// $("#sel_level").val('1');
	// $("#txt_programName").val('테스트');
	// $("#txt_programSort").val('0');
	// $("#txt_location").val('../test/test.do');
});



function fun_selectJdtListProgram(callback){
	var inputData = { };
	
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

function fun_initializeClickEvent(){
	$('#jdtListMain').delegate('tr', 'click', function () {
		// 빈테이블이 아닐때
		if (this.innerText != "데이터가 없습니다.") {
			var chk = $(this).hasClass('selected');
			if (chk) {
				$(this).removeClass('selected');
				
				this.children[0].lastChild.checked = false;
				//$(this)[0].children(0).lastChild.checked = false;
				$("#hdf_adminProgramSeq").val('-1');
				$("#txt_programId").val('');
				$("#txt_parentsProgramId").val('');
				$("#txt_programName").val('');
				$("#txt_location").val('');
				$("#sel_level").val('0');
				$("sel_useYn").val('Y');
				$("#txt_programSort").val('');
			} else {
				$("#jdtListMain tbody tr").removeClass('selected');
				//$("#cbx_SelectAll").attr('checked', false);         // 전체선택 체크 해제
				$("input[name='chk-main']").prop('checked', false);  // 선택 줄 외 체크 해제
				
				$(this).toggleClass('selected');
				this.children[0].lastChild.checked = true;
				//$(this)[0].children(0).lastChild.checked = true;
				
				fun_clickJdtListMain();
			}
		}
	});

	//테이블 검색시
	$("#txt_searchParcelInfo").on('keyup click', function () {
		$("#jdtListMain").DataTable().search(
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
		var oTable = $("#jdtListMainDetail").DataTable();
		var t = $("#jdtListMainDetail").dataTable();
		
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
	
	$("#txt_programId").on("keyup", function(e){
		if(e.keyCode==13){
			$("#txt_parentsProgramId").focus();
		}
	});

	$("#txt_parentsProgramId").on("keyup", function(e){
		if(e.keyCode==13){
			$("#txt_programName").focus();
		}
	});

	$("#txt_programName").on("keyup", function(e){
		if(e.keyCode==13){
			$("#txt_location").focus();
		}
	});

	$("#txt_location").on("keyup", function(e){
		if(e.keyCode==13){
			$("#sel_level").focus();
		}
	});

	$("#sel_level").change(function(e){
		$("#txt_programSort").focus();
	});

	$("#txt_programSort").on("keyup", function(e){
		if(e.keyCode==13){
			$("#sel_useYn").focus();
		}
	});

	$("#sel_useYn").change(function(e){
		$("#txt_adminPassword").focus();
	});

	$("#txt_adminPassword").on("keyup", function(e){
		if(e.keyCode==13){
			$("#btn_Save").trigger("click");
		}
	});
}


function fun_setJdtListProgram(callback) {
	jdtListMain = $("#jdtListMain").DataTable({
		"columns": [
			{ 
				"data": null
				, "width": "20px"
				, "defaultContent": "<input type='checkbox' name='chk-main'></input>"
				, "sortable": false
			}  
			, { "title": "adminProgramSeq", "data": "adminProgramSeq" }
			, { "title": "프로그램이름", "data": "programName" }
			, { "title": "코드", "data": "programId" }
			, { "title": "상위아이디", "data": "parentsProgramId" }
			, { "title": "레벨", "data": "level" }
			, { "title": "정렬", "data": "programSort" }
			, { "title": "경로", "data": "location" }
			, { "title": "사용여부", "data": "useYn" }
			, { "title": "만든일자", "data": "regDate" }
			, { "title": "수정일자", "data": "updateDate" }
			
		]
		, "sort": false                     // 소팅 여부
		, "paging": false               // 테이블 크기를 넘어선 자료 페이징 처리 여부
		, "info": false                 // 보여지는 페이지 설명 부분 사용 여부
		, "filter": false               // 검색 부분 사용 여부
		, "autoWidth": false            // 테이블 컬럼 너비 자동 설정
		//, "jQueryUI": true              // JQuery UI 사용 여부
		, "scrollY": "235"              // 테이블 높이 설정 ( 테이블의 스크롤 Y축 설정 )
		//, "scrollCollapse": true        // 데이터 수가 적을시 사이즈 강제 하는 부분 설정
		, "scrollX": "100%"             // X축 스크롤 사이즈 처리
		, "scrollXInner": "100%"        // 스크롤 안쪽의 테이블 사이즈 처리
		, "language": {
			"zeroRecords": "데이터가 없습니다."
		}                               // 기본 데이터테이블 글자 처리
		, "columnDefs": [               // 컬럼 정의 부분 (컬럼별 옵션 처리)
			{
				"targets": [0]
					, "class": "dt-head-center dt-body-center dtPercent5"
			}
			, {
			"targets": [1]
				, "class": "hideColumn"
			}
			, {
				"targets": [2]
				, "class": "dt-head-center dt-body-left dtPercent20"
			}
			, {
				"targets": [3]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
			, {
				"targets": [4]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
			, {
				"targets": [5]
				, "class": "dt-head-center dt-body-center dtPercent5"
			}
			, {
				"targets": [6]
				, "class": "dt-head-center dt-body-center dtPercent5"
			}
			, {
				"targets": [7]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
			, {
				"targets": [8]
				, "class": "dt-head-center dt-body-center dtPercent5"
			}
			, {
				"targets": [9]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
			, {
				"targets": [10]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
		]
	});
	callback();
};

function fun_clickJdtListMain() {
	var table = $("#jdtListMain").DataTable();
	var row = table.rows('.selected').data()[0];
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
		
		//table.rows('.selected').nodes().to$().removeClass('selected');
	}
};


function fun_checkValidation(){
	
}

function fun_validationSaveChk(){
	if($("#txt_programId").val()==""){
		$("#txt_programId").focus();
		alert("프로그램 아이디을 입력 해주세요.");
		return false;
	}

	if($("#txt_parentsProgramId").val()==""){
		$("#txt_parentsProgramId").focus();
		alert("상위메뉴 아이디을 입력 해주세요.");
		return false;
	}

	if($("#txt_programName").val()==""){
		$("#txt_programName").focus();
		alert("프로그램 이름을 입력 해주세요.");
		return false;
	}

	if($("#txt_location").val()==""){
		$("#txt_location").focus();
		alert("경로를 입력 해주세요.");
		return false;
	}

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
		alert("순서를 선택 해주세요.");
		return false;
	}

	if($("#txt_adminPassword").val()==""){
		$("#txt_adminPassword").focus();
		alert("로그인 비밀번호를 입력 해주세요.");
		return false;
	}

	return true;
}

function fun_checkValidation(){
	if($("#sel_restateRegion option:selected").val()==""){
		$("#sel_restateRegion").focus();
		alert("지역을 선택해주세요.");
		return false;
	}

	if($("#txt_businessName").val()==""){
		$("#txt_businessName").focus();
		alert("사업명을 입력 해주세요.");
		return false;
	}

	if($("#txt_builder").val()==""){
		$("#txt_builder").focus();
		alert("건설사을 입력 해주세요.");
		return false;
	}

	if($("#txt_notiDay").val()==""){
		$("#txt_notiDay").focus();
		alert("공지일자를 입력 해주세요.");
		return false;
	}
	else{
		//[0-9]{4}.[0-9]{2}.[0-9]{2}
		var splitNotidate = $("#txt_notiDay").val().split(".");
		var patternDate = /[0-9]{4}.[0-9]{2}.[0-9]{2}/;

		
		if(!patternDate.test(splitNotidate)){
			$("#txt_notiDay").focus();
			alert("공지일자의 형식은 YYYY.MM.DD 입니다");
			return false;
		}
	}

	if($("#sel_state option:selected").val()==""){
		$("#sel_state").focus();
		alert("상태를 선택 해주세요.");
		return false;
	}
	
	return true;
}


//=== 추가/수정 이후 히든값 및 텍스트 초기화
function fun_changeAfterinit() {
	$("#sel_restateRegion").val('');
	$("#txt_businessName").val('');
	$("#txt_builder").val('');
	$("#txt_notiDay").val('');
	$("#sel_state").val('');
};	


//=== 전체선택 체크시 이벤트
function fun_selectAllJdtListMainDetail() {
	var chk_SelectAll = $("#cbx_SelectAll").is(':checked');             // 전체선택 체크시 true
	var tr = $("#jdtListMainDetail tbody tr");

	if (tr[0].innerText != "데이터가 없습니다.") {                              // Row에 추가된 값이 있을시
		if (chk_SelectAll) {
			//$("#Content_jdt_ListMain tbody tr").addClass('selected');           // 클래스 추가
			$("input[name='chk-row']").prop('checked', true);
			$("#jdtListMainDetail tbody tr").removeClass('selected');            // .selected 클래스 제거
		} else {
			//$("#Content_jdt_ListMain tbody tr").removeClass('selected');        // 클래스 삭제
			$("input[name='chk-row']").prop('checked', false);
			$("#jdtListMainDetail tbody tr").removeClass('selected');            // .selected 클래스 제거
		}
		fun_changeAfterinit();

	} else {                                                                    // Row에 추가된 값이 없을시
		$("#cbx_SelectAll").attr('checked', false);                     // 전체선택 체크 해제
	}
};



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
						break;
					case "0001":
						alert("저장에 실패 하였습니다");
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
   	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header" style="font-size:24px">프로그램 메뉴관리</h1>
	    </div>
	    <!-- /.col-lg-12 -->
    </div>

    <div class="row">
	    <div class="col-lg-12">
	        <div id="accordion1" class="accordion-style1 panel-group accordion-style2">
	            <div class="panel panel-default" id="tog_Head">
	                <div class="panel-heading clearfix" style="font-size:16px">
	                    <span class="toggle_accordion">
	                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse1" >
						    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
						    &nbsp;프로그램 목록
						                        
						   </a>
	                    </span>
	                    <span class="toggle_accordionSearch">
	                        
	                    </span>
	                </div>
	                <div id="collapse1" class="panel-collapse collapse in">
	                    <div class="panel panel-body">
	                        <div class="dataTable_wrapper">
	                            <!-- 프로그램 레벨 표시를 위해 stripe 클래스 제거 -->
	                            <table id="jdtListMain" class="table table-bordered table-hover">
	                                <thead>
	                                            
	                                </thead>
	                                <tbody>
	                                                    
	                                </tbody>
	                            </table>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
    
    <div class="row">
            <div class="col-lg-12">
                <div id="accordion2" class="accordion-style1 panel-group accordion-style2">
                    <div class="panel panel-default" id="tog_Detail">
                        <div class="panel-heading clearfix" style="font-size:16px">
                            <span class="toggle_accordion">
                                <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse1" >
								    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
								    &nbsp;상세정보
                                
							    </a>
                            </span>
                            <span class="toggle_accordionSearch">
                                
                            </span>
                        </div>
                        <div id="collapse2" class="panel-collapse collapse in">
                            <div class="panel-body" >
                                <div class="row form-group form-group-sm">
                                    <div class="col-lg-2 col-sm-2" style="padding-top:4px;">프로그램아이디</div>
                                    <div class="col-lg-4 col-sm-4">
                                        <input type="text" id="txt_programId" class="form-control" placeholder="Ex) 10000001" />
                                    </div>
                                    <div class="col-lg-2 col-sm-2" style="padding-top:4px;">상위메뉴아이디</div>
                                    <div class="col-lg-4 col-sm-4">
                                        <input type="text" ID="txt_parentsProgramId" class="form-control" placeholder="Ex) 10000001" />
                                    </div>
                                </div>
                                <div class="row form-group form-group-sm">
                                    <div class="col-lg-2 col-sm-2" style="padding-top:4px;">프로그램이름</div>
                                    <div class="col-lg-4 col-sm-4">
                                        <input type="text" ID="txt_programName" class="form-control" placeholder="Ex) 프로그램메뉴관리" />
                                    </div>
                                    <div class="col-lg-2 col-sm-2" style="padding-top:4px;">경로</div>
                                    <div class="col-lg-4 col-sm-4">
                                        <input type="text" ID="txt_location" class="form-control" placeholder="Ex) ../admin/modifyProgram.do">
                                    </div>
                                </div>
                                <div class="row form-group form-group-sm">
                                    <div class="col-lg-2 col-sm-2" style="padding-top:4px;">레벨</div>
                                    <div class="col-lg-4 col-sm-4">
                                        <select id="sel_level" class="form-control" >
                                            <option value="0">--선택--</option>
                                            <option value="1">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-2 col-sm-2" style="padding-top:4px;">순서</div>
                                    <div class="col-lg-4 col-sm-4">
                                        <input type="text" ID="txt_programSort" class="form-control" />
                                    </div>
                                </div>
                                <div class="row form-group form-group-sm">
									<div class="col-lg-2 col-sm-2" style="padding-top:4px;">사용여부</div>
                                    <div class="col-lg-4 col-sm-4">
                                        <select id="sel_useYn" class="form-control" >
											<option value="">--선택--</option>
											<option value="Y">Y</option>
                                            <option value="N">N</option>
                                        </select>
                                    </div>
				                	<div class="col-lg-2 col-sm-2">로그인<br>비밀번호</div>
				                	<div class="col-lg-4 col-sm-4">
				                		<input type="password" id="txt_adminPassword" class="form-control">
				                	</div>
				                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
            <div class="row" id="div_row4">
         <div class="col-lg-12">
             <div class="col-lg-5 col-md-s5">
             	<!-- <input type="button" value="회원수체크" class="btn btn-primary btn-sm" onclick="return fun_Click_btn_totalCount();" /> -->
                
             </div>
             <div class="hidden-lg hidden-md col-sm-12"><p></p></div>
             <div class="col-lg-7 col-md-7">
                 <div class="pull-right" style="padding-right:20px">
                     <input type="button" ID="btn_Delete" value="삭제" class="btn btn-danger btn-sm" onclick="return fun_clickButtonOfDeleteProgramMenu();" />
					 &nbsp;
                     <input type="button" ID="btn_Save" value="추가 및 수정" class="btn btn-primary btn-sm" onclick="return fun_clickButtonOfInsertProgramMenu();" />
                 </div> 
             </div>
         </div>
     </div>
	 <input type="hidden" id="hdf_adminProgramSeq" value="" />
</form>
