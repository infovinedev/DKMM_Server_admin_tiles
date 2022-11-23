<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="../assets/js/date-time/moment.js" type="text/javascript"></script>
<!-- <link href="../assets/css/bootstrap-timepicker.css" rel="stylesheet" type="text/css" />
<script src="../assets/js/date-time/bootstrap-timepicker.js" type="text/javascript"></script> -->

<link href="../assets/css/bootstrap-datetimepicker.css" rel="stylesheet" type="text/css" />
<script src="../assets/js/date-time/bootstrap-datetimepicker.js" type="text/javascript"></script>
<script src="../assets/js/date-time/bootstrap-datetimepicker.kr.js" type="text/javascript"></script>
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
	
	// $("#txt_programId").val('1234');
	// $("#txt_parentsProgramId").val('5678');
	// $("#sel_level").val('1');
	// $("#txt_programName").val('테스트');
	// $("#txt_programSort").val('0');
	// $("#txt_location").val('../test/test.do');
});



function fun_selectJdtListProgram(callback){
	var inputData = { };
	
	fun_ajaxPostSend("/tidc/select/all/notification.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			$("#txt_notiSeq").val(tempResult.length + 1);
			fun_dataTableAddData("#jdtListMain", tempResult);
			callback();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}

function fun_initializeClickEvent(){
	$("#dtp_startDate, #dtp_endDate").datetimepicker({
		format: "YYYY-MM-DD HH:mm:ss"
		, language: "kr"
		, autoclose: "true"
		, useSeconds:true
		, showMillisec:false
	});

	// $("#dtp_startTime, #dtp_endTime").timepicker({
	// 	timeFormat: "HH:mm:ss"
	// 	, autoclose: "true"
	// });


	var tempToday = new Date();
	var tempYears = tempToday.toISOString().substring(0, 4);
	var tempEndYears = tempToday.toISOString().substring(0, 4);
	var tempMonth = tempToday.getMonth();
	var tempEndMonth = tempToday.getMonth();

	var tempStartDate = new Date(mid(tempYears.toString(), 0, 4), tempMonth, tempToday.getDate(), 0, 0, 0, 0);
	$("#dtp_startDate").datetimepicker().data('DateTimePicker').setDate(tempStartDate);

	var tempEndDate = new Date(mid(tempEndYears.toString(), 0, 4), tempEndMonth, tempToday.getDate(), 23, 59, 59, 59);
	$("#dtp_endDate").datetimepicker().data('DateTimePicker').setDate(tempEndDate);
	
	$('#jdtListMain').delegate('tr', 'click', function () {
		// 빈테이블이 아닐때
		if (this.innerText != "데이터가 없습니다.") {
			var chk = $(this).hasClass('selected');
			if (chk) {
				$(this).removeClass('selected');
				
				this.children[0].lastChild.checked = false;
				//$(this)[0].children(0).lastChild.checked = false;
				$("#txt_notiSeq").val('-1');
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
	
	$("#txt_notiSeq").on("keyup", function(e){
		if(e.keyCode==13){
			$("#txt_notiCode").focus();
		}
	});

	$("#txt_notiCode").on("keyup", function(e){
		if(e.keyCode==13){
			$("#dtp_startDate").focus();
		}
	});

	$("#dtp_startDate").on("keyup", function(e){
		if(e.keyCode==13){
			$("#dtp_endDate").focus();
		}
	});

	$("#dtp_endDate").on("keyup", function(e){
		if(e.keyCode==13){
			$("#txt_notiContent").focus();
		}
	});

	$("#txt_notiContent").change(function(e){
		$("#sel_useYn").focus();
	});

	$("#sel_useYn").on("keyup", function(e){
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
			, { "title": "seq", "data": "notiSeq" }
			, { "title": "코드", "data": "notiCode" }
			, { "title": "내용", "data": "notiContent" }
			, { "title": "target", "data": "notiTarget" }
			, { "title": "시작일시", "data": "startDate" }
			, { "title": "종료일시", "data": "endDate" }
			, { "title": "사용여부", "data": "useYn" }
			, { "title": "입력일시", "data": "insertDate" }
			, { "title": "수정일시", "data": "updateDate" }
			
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
					, "class": "dt-head-center dt-body-center dtPercent2"
			}
			, {
				"targets": [1]
				, "class": "dt-head-center dt-body-center dtPercent4"
			}
			, {
				"targets": [2]
				, "class": "dt-head-center dt-body-center dtPercent5"
			}
			, {
				"targets": [3]
				, "class": "dt-head-center dt-body-left dtPercent15"
			}
			, {
				"targets": [4]
				, "class": "hideColumn"
			}
			, {
				"targets": [5]
				, "class": "dt-head-center dt-body-center dtPercent5"
				// , "render": function (data, type, row) {
				// 	var timestamp = parseInt(row.startDate);
				// 	var timezoneOffset = new Date().getTimezoneOffset() * 60000;
				// 	var isoString = new Date(timestamp - timezoneOffset).toISOString()
				// 	.replace(/T/, ' ')      // replace T with a space
				// 	.replace(/\..+/, '');     // delete the dot and everything after
                //    return isoString;
                // }
			}
			, {
				"targets": [6]
				, "class": "dt-head-center dt-body-center dtPercent5"
				// , "render": function (data, type, row) {
				// 	var timestamp = parseInt(row.endDate);
				// 	var timezoneOffset = new Date().getTimezoneOffset() * 60000;
				// 	var isoString = new Date(timestamp - timezoneOffset).toISOString()
				// 	.replace(/T/, ' ')      // replace T with a space
				// 	.replace(/\..+/, '');     // delete the dot and everything after
                //    return isoString;
                // }
			}
			, {
				"targets": [7]
				, "class": "dt-head-center dt-body-center dtPercent4"
			}
			, {
				"targets": [8]
				, "class": "dt-head-center dt-body-center dtPercent5"
				, "render": function (data, type, row) {
					var timestamp = parseInt(row.insertDate);
					var timezoneOffset = new Date().getTimezoneOffset() * 60000;
					var isoString = new Date(timestamp - timezoneOffset).toISOString()
					.replace(/T/, ' ')      // replace T with a space
					.replace(/\..+/, '');     // delete the dot and everything after
                   return isoString;
                }
			}
			, {
				"targets": [9]
				, "class": "dt-head-center dt-body-center dtPercent5"
				, "render": function (data, type, row) {
					var timestamp = parseInt(row.updateDate);
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

function fun_clickJdtListMain() {
	var table = $("#jdtListMain").DataTable();
	var row = table.rows('.selected').data()[0];
	var checkData = row.notiSeq;

	if (checkData != undefined) {
		$("#txt_notiSeq").val(row.notiSeq);
		$("#txt_notiCode").val(row.notiCode);
		$("#txt_notiContent").val(row.notiContent);
		$("#txt_notiTarget").val(row.notiTarget);
		
		var rowStartDate = row.startDate;
		var rowEndDate = row.endDate; 

		var tempStartDate = new Date(mid(rowStartDate.toString(), 0, 4), mid(rowStartDate.toString(), 5, 2) -1, mid(rowStartDate.toString(), 8, 2), mid(rowStartDate.toString(), 11, 2), mid(rowStartDate.toString(), 14, 2), mid(rowStartDate.toString(), 17, 2), 59);
		$("#dtp_startDate").datetimepicker().data('DateTimePicker').setDate(tempStartDate);

		var tempEndDate = new Date(mid(rowEndDate.toString(), 0, 4), mid(rowEndDate.toString(), 5, 2) -1, mid(rowEndDate.toString(), 8, 2), mid(rowEndDate.toString(), 11, 2), mid(rowEndDate.toString(), 14, 2), mid(rowEndDate.toString(), 17, 2), 59);
		$("#dtp_endDate").datetimepicker().data('DateTimePicker').setDate(tempEndDate);
		
		$("#txt_startDate").val();
		$("#txt_endDate").val();

		$("#sel_useYn").val(row.useYn);
		$("#txt_insertDate").val(row.insertDate);
		$("#txt_updateDate").val(row.updateDate);
		//table.rows('.selected').nodes().to$().removeClass('selected');
	}
};


function fun_checkValidation(){
	
}

function fun_validationSaveChk(){
	if($("#txt_notiSeq").val()==""){
		$("#txt_notiSeq").focus();
		alert("순번을 입력 해주세요.");
		return false;
	}

	if($("#txt_notiCode").val()==""){
		$("#txt_notiCode").focus();
		alert("코드를 입력 해주세요.");
		return false;
	}

	if($("#dtp_startDate").val()==""){
		$("#dtp_startDate").focus();
		alert("시작일시를 입력 해주세요.");
		return false;
	}

	if($("#dtp_endDate").val()==""){
		$("#dtp_endDate").focus();
		alert("종료일시를 입력 해주세요.");
		return false;
	}

	if($("#txt_notiContent").val()==""){
		$("#txt_notiContent").focus();
		alert("내용을 입력 해주세요.");
		return false;
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
		var inputData = { 'notiSeq': $("#txt_notiSeq").val()
				, 'notiCode' :$("#txt_notiCode").val()
				, 'notiContent' :$("#txt_notiContent").val()
				, 'notiTarget' :$("#txt_notiTarget").val()
				, 'startDate':$("#dtp_startDate").val()
				, 'endDate':$("#dtp_endDate").val()
				, 'useYn': $("#sel_useYn option:selected").val()
		};

		fun_ajaxPostSend("/tidc/insert/notiinfo.do", inputData, true, function(msg){
			if(msg!=null){
				switch(msg.code){
					case "0000":
						var seq = $("#txt_notiSeq").val();
						if(seq==null||seq==""){
						}
						else{
							seq = parseInt(seq) + 1;							
						}
						$("#txt_notiSeq").val(seq);
						$("#txt_notiCode").val('');
						$("#txt_notiContent").val('');
						
						var tempToday = new Date();
						var tempYears = tempToday.toISOString().substring(0, 4);
						var tempEndYears = tempToday.toISOString().substring(0, 4);
						var tempMonth = tempToday.getMonth();
						var tempEndMonth = tempToday.getMonth();

						var tempStartDate = new Date(mid(tempYears.toString(), 0, 4), tempMonth, tempToday.getDate(), 0, 0, 0, 0);
						$("#dtp_startDate").datetimepicker().data('DateTimePicker').setDate(tempStartDate);

						var tempEndDate = new Date(mid(tempEndYears.toString(), 0, 4), tempEndMonth, tempToday.getDate(), 23, 59, 59, 59);
						$("#dtp_endDate").datetimepicker().data('DateTimePicker').setDate(tempEndDate);

						$("#sel_useYn").val('N');
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
	if( $("#txt_notiSeq").val() == '-1' ||  $("#txt_notiSeq").val() == null){
		alert("프로그램을 선택해주세요");
		return false;
	}
	if (confirm('프로그램을 사용하지 않으시겠습니까?')){
		var password = $("#txt_adminPassword").val();
		var shaPassword = "";
		if(password != ""){
			shaPassword = hex_sha512(password);
			var inputData = { 'adminProgramSeq': $("#txt_notiSeq").val()
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
	        <h1 class="page-header" style="font-size:24px">TIDC MY자산/MY소비 공지</h1>
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
                                    <div class="col-lg-1 col-sm-1" style="padding-top:4px;">순번</div>
                                    <div class="col-lg-2 col-sm-2">
                                        <input type="text" id="txt_notiSeq" class="form-control" placeholder="Ex) 1" />
                                    </div>
                                    <div class="col-lg-1 col-sm-1" style="padding-top:4px;">코드</div>
                                    <div class="col-lg-2 col-sm-2">
                                        <input type="text" ID="txt_notiCode" class="form-control" placeholder="Ex) NOTS000001" />
									</div>
									<div class="col-lg-1 col-sm-1" style="padding-top:4px;">시작일시</div>
                                    <div class="col-lg-2 col-sm-2">
                                        <div class="input-group">
											<input type="text" id="dtp_startDate" class="form-control" autocomplete="no">
											<span class="input-group-addon">
												<i class="fa fa-calendar"></i>
											</span>
										</div>
									</div>
									<div class="col-lg-1 col-sm-1" style="padding-top:4px;">종료일시</div>
                                    <div class="col-lg-2 col-sm-2">
                                        <div class="input-group">
											<input type="text" id="dtp_endDate" class="form-control" autocomplete="no">
											<span class="input-group-addon">
												<i class="fa fa-calendar"></i>
											</span>
										</div>
									</div>
                                </div>
                                <div class="row form-group form-group-sm">
                                    <div class="col-lg-1 col-sm-1" style="padding-top:4px;">내용</div>
                                    <div class="col-lg-5 col-sm-5">
                                        <input type="text" ID="txt_notiContent" class="form-control" placeholder="" />
                                    </div>
                                    <div class="col-lg-1 col-sm-1" style="padding-top:4px;">사용여부</div>
                                    <div class="col-lg-2 col-sm-2">
                                        <select id="sel_useYn" class="form-control" >
											<option value="">--선택--</option>
											<option value="Y">Y</option>
                                            <option value="N">N</option>
                                        </select>
									</div>
									<div class="col-lg-1 col-sm-1" style="padding-top:4px;">타겟</div>
                                    <div class="col-lg-2 col-sm-2">
                                        <input type="text" ID="txt_notiTarget" class="form-control" placeholder="#" value="#" />
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
					<input type="button" ID="btn_new" value="새문서" class="btn btn-primary btn-sm" onclick="location.reload();" /> 
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
	 <input type="hidden" id="txt_notiSeq" value="" />
</form>
