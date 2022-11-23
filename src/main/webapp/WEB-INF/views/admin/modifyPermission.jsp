<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>

var jdtListAdminUser;
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
		$('#jdtListAdminUser').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
		$('#jdtListProgram').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
	});

	$('.panel').on('shown.bs.collapse', function (e) {
		$('#jdtListAdminUser').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
		$('#jdtListProgram').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
	});

	fun_initializeClickEvent();
	fun_setjdtListAdminUser(function(){
		fun_selectjdtListAdminUser(function(){

		});
	});

	fun_setJdtListProgram(function(){
		fun_selectProgramMenuOfAdminUser(function(){

		});
	});

	$("#hdf_adminUserSeq").val('-1');
	$("#hdf_adminProgramSeq").val('-1');
	// $("#txt_programId").val('1234');
	// $("#txt_parentsProgramId").val('5678');
	// $("#sel_level").val('1');
	// $("#txt_programName").val('테스트');
	// $("#txt_programSort").val('0');
	// $("#txt_location").val('../test/test.do');
});



function fun_initializeClickEvent(){
	$('#jdtListAdminUser').delegate('tr', 'click', function () {
		// 빈테이블이 아닐때
		if (this.innerText != "데이터가 없습니다.") {
			var chk = $(this).hasClass('selected');
			if (chk) {
				$(this).removeClass('selected');
				
				this.children[0].lastChild.checked = false;
				//$(this)[0].children(0).lastChild.checked = false;
				
			} else {
				$("#jdtListAdminUser tbody tr").removeClass('selected');
				//$("#cbx_SelectAll").attr('checked', false);         // 전체선택 체크 해제
				$("input[name='chk-admin']").prop('checked', false);  // 선택 줄 외 체크 해제
				
				$(this).toggleClass('selected');
				this.children[0].lastChild.checked = true;
				//$(this)[0].children(0).lastChild.checked = true;
				
				fun_clickjdtListAdminUser();
			}
		}
	});

	$('#jdtListProgram').delegate('tr', 'click', function () {
		// 빈테이블이 아닐때
		if (this.innerText != "데이터가 없습니다.") {
			var chkBoxVal = $(this).children()[1].lastChild.value;
			if (chkBoxVal == "true") {
				$(this).children()[1].lastChild.checked = false;
				$(this).children()[1].lastChild.value = "false";
			} else {
				$(this).children()[1].lastChild.checked = true;
				$(this).children()[1].lastChild.value = "true";
			}
		}
	});

	//테이블 검색시
	$("#txt_searchParcelInfo").on('keyup click', function () {
		$("#jdtListProgram").DataTable().search(
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
		var oTable = $("#jdtListProgramDetail").DataTable();
		var t = $("#jdtListProgramDetail").dataTable();
		
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


function fun_SetButtonMode(type) {
	if (type == "A") {
		$("#Content_btn_Modify").attr('disabled', 'disabled');      // disabled 속성 추가
		$("#Content_btn_Add").removeAttr('disabled');               // disabled 속성 제거
	} else if (type == "U") {
		$("#Content_btn_Modify").removeAttr('disabled');
		$("#Content_btn_Add").attr('disabled', 'disabled');
	}
};


function fun_selectjdtListAdminUser(callback){
	var inputData = { };
	
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
			{ 
				//"title": "<input type='checkbox' id='cbx_SelectAll' onclick='fun_SelectAll_jdt_ListMain();' class='ace' />"
				"data": null
				, "width": "20px"
				, "defaultContent": "<input type='checkbox' name='chk-admin'></input>"
				, "sortable": false
			}   
			, { "title": "seq", "data": "adminUserSeq"}      
			, { "title": "이름", "data": "userId"}
			, { "title": "이름", "data": "userName"}
			, { "title": "코드", "data": "userTypeCode"}
			, { "title": "패스워드오류", "data": "passwordErrorCount" }
			, { "title": "마지막로그인", "data": "lastloginDate" }
			, { "title": "블록", "data": "blockYn" }
			
		]
		, "sort": false                     // 소팅 여부
			, "paging": false               // 테이블 크기를 넘어선 자료 페이징 처리 여부
			, "info": false                 // 보여지는 페이지 설명 부분 사용 여부
			, "filter": false               // 검색 부분 사용 여부
			, "autoWidth": false            // 테이블 컬럼 너비 자동 설정
			//, "jQueryUI": true              // JQuery UI 사용 여부
			, "scrollY": "635"              // 테이블 높이 설정 ( 테이블의 스크롤 Y축 설정 )
			//, "scrollCollapse": true        // 데이터 수가 적을시 사이즈 강제 하는 부분 설정
			, "scrollX": "100%"             // X축 스크롤 사이즈 처리
			, "scrollXInner": "100%"        // 스크롤 안쪽의 테이블 사이즈 처리
			, "language": {
				"zeroRecords": "데이터가 없습니다."
			}     
		, "columnDefs": [
			{
				"targets": [1]
				, "class": "hideColumn"
			}
			, {
				"targets": [2]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
			, {
				"targets": [3]
				, "class": "dt-head-center dt-body-left dtPercent30"
			}
			, {
				"targets": [4]
				, "class": "dt-head-center dt-body-left dtPercent25"
			}
			, {
				"targets": [5]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
			, {
				"targets": [6]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
			, {
				"targets": [7]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
		]
	});
	callback();
};

function fun_clickjdtListAdminUser() {
	var table = $("#jdtListAdminUser").DataTable();
	var row = table.rows('.selected').data()[0];
	var checkData = row.adminUserSeq;

	if (checkData != undefined) {
		$("#hdf_adminUserSeq").val(row.adminUserSeq);
		// $("#txt_userId").val(row.userId);
		// $("#txt_userId").attr("disabled",true); 
		// $("#txt_userName").val(row.userName);
		// $("#txt_userName").attr("disabled",true); 
		// $("#sel_userTypeCode").val(row.userTypeCode);
		$("#divUser").hide();
		$("#divProgram").show();
		fun_clickJdtListProgram(row.adminUserSeq, function(){});     // jdtListProgram Data Binding
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
		, "scrollY": "635"              // 테이블 높이 설정 ( 테이블의 스크롤 Y축 설정 )
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


function fun_clickJdtListProgram(adminUserSeq, callback) {
	//체크상태가 있을 수 있는 row값을 초기화한다
	for(var i=0; i<$("#jdtListProgram tbody tr").length;i++){
		$("input:checkbox[name=chk-program]")[i].checked = false;
	}

	var inputData = { "adminUserSeq" : adminUserSeq };
	
	fun_ajaxPostSend("/admin/select/permissionOfAdminUser.do", inputData, true, function(msg){
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
function fun_SelectAll_jdtListProgramDetail() {
	var chk_SelectAll = $("#cbx_SelectAll").is(':checked');             // 전체선택 체크시 true
	var tr = $("#jdtListProgramDetail tbody tr");

	if (tr[0].innerText != "데이터가 없습니다.") {                              // Row에 추가된 값이 있을시
		if (chk_SelectAll) {
			//$("#Content_jdt_ListMain tbody tr").addClass('selected');           // 클래스 추가
			$("input[name='chk-row']").prop('checked', true);
			$("#jdtListProgramDetail tbody tr").removeClass('selected');            // .selected 클래스 제거
		} else {
			//$("#Content_jdt_ListMain tbody tr").removeClass('selected');        // 클래스 삭제
			$("input[name='chk-row']").prop('checked', false);
			$("#jdtListProgramDetail tbody tr").removeClass('selected');            // .selected 클래스 제거
		}
		fun_changeAfterinit();

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
		
		// var jdtListProgramData = $("#jdtListProgram").tableToJSON({
		// 	// 테이블 값을 JSON Data로 변경전 해당 컬럼 실행 함수
		// 	textExtractor: {
		// 		0: function (cellIndex, $cell) {            // index[1]컬럼 체크여부 bool값 toString()
		// 			return {
		// 				name:"check"
		// 				, result:($cell.find('input[type=checkbox]').prop('checked')).toString()
		// 			}
		// 			// var result = ($cell.find('input[type=checkbox]').prop('checked')).toString();
		// 			// return result;
		// 		}
		// 	}
		// });

		var tempPermission = [];
		for(var i=0; i<$("#jdtListProgram tbody tr").length; i++){
			if($("#jdtListProgram tbody tr")[i].children[0].children[0].checked){
				var adminProgramSeq = $("#jdtListProgram tbody tr")[i].children[1].innerText;
				var permission = {"adminProgramSeq": adminProgramSeq, "adminUserSeq":$("#hdf_adminUserSeq").val()};
				tempPermission.push(permission);
			}
		}

		var inputData = {
			'password': shaPassword
			, "permission" : tempPermission
		};
		fun_ajaxPostSend("/admin/insert/programPermissionOfAdminUser.do", inputData, true, function(msg){
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
   	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header" style="font-size:24px">사용자 권한관리</h1>
	    </div>
	    <!-- /.col-lg-12 -->
    </div>

    <div class="row" id="divUser">
	    <div class="col-lg-12">
	        <div id="accordion1" class="accordion-style1 panel-group accordion-style2">
	            <div class="panel panel-default" id="tog_Head">
	                <div class="panel-heading clearfix" style="font-size:16px">
	                    <span class="toggle_accordion">
	                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse1" >
						    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
						    &nbsp;ADMIN USER 목록
						                        
						   </a>
	                    </span>
	                    <span class="toggle_accordionSearch">
	                        
	                    </span>
	                </div>
	                <div id="collapse1" class="panel-collapse collapse in">
	                    <div class="panel panel-body">
	                        <div class="dataTable_wrapper">
	                            <!-- 프로그램 레벨 표시를 위해 stripe 클래스 제거 -->
	                            <table id="jdtListAdminUser" class="table table-bordered table-hover">
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


    <div class="row" id="divProgram">
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
	                            <table id="jdtListProgram" class="table table-bordered table-hover">
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
		    <div class="col-lg-4 col-md-4">
			</div>
			<div class="hidden-lg hidden-md col-sm-12"><p></p></div>
			<div class="col-lg-3 col-md-3">

			</div>
			<div class="col-lg-2 col-md-2">				
				<div class="col-lg-4 col-md-4">				
					로그인<br>비밀번호
				</div>
				<div class="col-lg-8 col-md-8">
					<input type="password" id="txt_adminPassword" class="form-control" value="" />
				</div>
			</div>
			<div class="col-lg-2 col-md-2">
			    <div class="pull-right" style="padding-right:20px">
				<button id="btn_Modify" type="button" class="btn btn-white btn-info btn-bold" onclick="return fun_clickButtonOfModify();">
				 <i class="ace-icon fa fa-floppy-o bigger-120 blue"></i>
				 수정
				</button>
                 <button id="btn_Del" type="button" class="btn btn-white btn-warning btn-bold" onclick="return fun_clickButtonOfCancel();">
				 <i class="ace-icon fa fa-remove bigger-120 red"></i>
				 취소
				</button> 
	            </div>
	        </div>
	    </div>
	</div>
	 <input type="hidden" id="hdf_adminProgramSeq" value="" />
     <input type="hidden" id="hdf_adminUserSeq" value="" />
</form>
