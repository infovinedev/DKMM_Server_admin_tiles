<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>

var jdtListParcelInfo;
var jdtListParcelInfoDetail;

window.onload = function(){
};

$(document).ready(function () {
	var ua = navigator.userAgent;
	var checker = {
		iphone: ua.match(/(iPhone|iPod|iPad)/),
		blackberry: ua.match(/BlackBerry/),
		android: ua.match(/Android/)
	};

	$("#sel_restateRegion").focus();
	
	//=== jdt_List 사이즈 변환시 테이블 리사이징
	$(window).bind('resize', function () {
		if (checker.android == null || checker.android == "" || checker.android == "null") {
			//$('#jdt_List').dataTable().fnAdjustColumnSizing();
		}
		$('#jdtListParcelInfo').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
		$('#jdtListParcelInfoDetail').dataTable().fnAdjustColumnSizing();
	});

	$('.panel').on('shown.bs.collapse', function (e) {
		$('#jdtListParcelInfo').dataTable().fnAdjustColumnSizing();
		$('#jdtListParcelInfoDetail').dataTable().fnAdjustColumnSizing();
	});

	fun_initializeClickEvent();
	fun_setJdtListParcelInfo(function(){
		fun_selectJdtListParcelInfo(function(){

		});
	});
	fun_setJdtListParcelInfoDetail();

	// $("#sel_restateRegion").val("서울");
	// $("#txt_businessName").val("사업명테스트");
	// $("#txt_builder").val("건설사테스트");
	// $("#txt_notiDay").val("2021.11.30");
	// $("#sel_state").val("청약중");
	$("#txt_notiDay").mask("9999.99.99", {'translation': {0: {pattern: /[0-9*]/}}});
	$("#txt_deadlineDate").mask("9999.99.99", {'translation': {0: {pattern: /[0-9*]/}}});
});



function fun_selectJdtListParcelInfo(callback){
	var inputData = { };
	
	fun_ajaxPostSend("/realestate/select/parcelInfo.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			fun_dataTableAddData("#jdtListParcelInfo", tempResult);
			callback();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}

function fun_initializeClickEvent(){
	$('#jdtListParcelInfo').delegate('tr', 'click', function () {
		// 빈테이블이 아닐때
		if (this.innerText != "데이터가 없습니다.") {
			var chk = $(this).hasClass('selected');
			if (chk) {
				$(this).removeClass('selected');
				
				this.children[0].lastChild.checked = false;
				//$(this)[0].children(0).lastChild.checked = false;
				$("#hdf_purchase_history_id").val('');
				var today = new Date();
				var date = today.toISOString().substring(0, 10);
				
				$("#hdf_idx").val(-1);
			} else {
				$("#jdtListParcelInfo tbody tr").removeClass('selected');
				$("#cbx_SelectAll").attr('checked', false);         // 전체선택 체크 해제
				$("input[name='chk-row']").prop('checked', false);  // 선택 줄 외 체크 해제
				$(this).toggleClass('selected');
				this.children[0].lastChild.checked = true;
				//$(this)[0].children(0).lastChild.checked = true;
				
				fun_clickJdtListParcelInfo();   // 선택한 줄 값 라인에 입력
			}
		}
		
		
		
		/* var table = $("#jdtListParcelInfo").DataTable();
		var row = table.rows('.selected').data()[0];
		table.rows('.selected').nodes().to$().removeClass('selected');
			
		$(this).toggleClass('selected');
		
		// 클릭 시 실행 함수
		fun_clickJdtListParcelInfo(); */
		
	});


	//=== IE 이외 브라우저 구동을 위한 교체
	$('#jdtListParcelInfoDetail').delegate('tr', 'click', function () {
		// 빈테이블이 아닐때
		if (this.innerText != "데이터가 없습니다.") {
			var chk = $(this).hasClass('selected');
			if (chk) {
				$(this).removeClass('selected');
				this.children[0].lastChild.checked = false;
				//$(this)[0].children(0).lastChild.checked = false;
				fun_changeAfterinit();
			} else {
				$("#jdtListParcelInfoDetail tbody tr").removeClass('selected');
				$("#cbx_SelectAll").attr('checked', false);         // 전체선택 체크 해제
				$("input[name='chk-row']").prop('checked', false);  // 선택 줄 외 체크 해제
				$(this).addClass('selected');
				
				this.children[0].lastChild.checked = true;
				//$(this)[0].children(0).lastChild.checked = true;
				fun_setJdtListParcelInfoDetailToTextbox();   // 선택한 줄 값 라인에 입력
			}
		}
	});

	//테이블 검색시
	$("#txt_searchParcelInfo").on('keyup click', function () {
		$("#jdtListParcelInfo").DataTable().search(
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
		var oTable = $("#jdtListParcelInfoDetail").DataTable();
		var t = $("#jdtListParcelInfoDetail").dataTable();
		
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

	$("#sel_restateRegion").change(function(e){
		$("#txt_businessName").focus();
	});

	$("#txt_businessName").on("keyup", function(e){
		if(e.keyCode==13){
			$("#txt_builder").focus();
		}
	});

	$("#txt_builder").on("keyup", function(e){
		if(e.keyCode==13){
			$("#sel_state").focus();
		}
	});

	$("#sel_state").change(function(e){
		$("#txt_notiDay").focus();
	});
	
	
	$("#txt_notiDay").on("keyup", function(e){
		if(e.keyCode==13){
			$("#txt_deadlineDate").focus();
		}
	});
	
	$("#txt_deadlineDate").on("keyup", function(e){
		if(e.keyCode==13){
			if(jdtListParcelInfoDetailRowIndex == -1){
				$("#btn_AddLine").trigger("click");
			}
			else{
				$("#btn_ModiLine").trigger("click");
			}
		}
	});
}


function fun_setJdtListParcelInfo(callback) {
	jdtListParcelInfo = $("#jdtListParcelInfo").DataTable({
		"columns": [
			{ 
				//"title": "<input type='checkbox' id='cbx_SelectAll' onclick='fun_SelectAll_jdt_ListMain();' class='ace' />"
				"data": null
				, "width": "20px"
				, "defaultContent": "<input type='checkbox' name='chk-parcel'></input>"
				, "sortable": false
			}   
			, { "title": "idx", "data": "idx"}      
			, { "title": "지역", "data": "restateRegion"}
			, { "title": "사업명", "data": "businessName"}
			, { "title": "건설사", "data": "builder"}
			, { "title": "공지일자", "data": "notiDay" }
			, { "title": "마감일자", "data": "deadlineDate" }
			, { "title": "상태", "data": "state" }
			, { "title": "등록일자", "data": "regDate" }
			
		]
		, "paging": true            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "autoWidth": false
		, "scrollY": "350px"
		, "scrollCollapse": true
		, "scrollX": true
		, "scrollXInner": "100%"
		//, "orderClasses": false
		, "order": [[ 1, "desc" ]]
		, "deferRender": true           // defer
		, "lengthMenu": [[10], [10]]           // Row Setting [-1], ["All"]
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
				, "class": "dt-head-center dt-body-right dtPercent5"
			}
			, {
				"targets": [2]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
			, {
				"targets": [3]
				, "class": "dt-head-center dt-body-left dtPercent25"
			}
			, {
				"targets": [4]
				, "class": "dt-head-center dt-body-left dtPercent20"
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
			, {
				"targets": [8]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
		]
	});
	callback();
};


function fun_clickJdtListParcelInfo(){
	var table = $("#jdtListParcelInfo").DataTable();
	var row = table.rows('.selected').data()[0];
	var checkData = row.idx;
	if (checkData != undefined) {
		$("#hdf_idx").val(row.idx);
	}
}

//=== jdt_List Setting
function fun_setJdtListParcelInfoDetail() {
	jdtListParcelInfoDetail = $("#jdtListParcelInfoDetail").DataTable({
		"columns": [
			{ 
				//"title": "<input type='checkbox' id='cbx_SelectAll' onclick='fun_SelectAll_jdt_ListMain();' class='ace' />"
				"title": "<input type='checkbox' id='cbx_SelectAll' onclick='fun_SelectAll_jdtListParcelInfoDetail();'></input>"
				,"data": null
				, "width": "20px"
				, "defaultContent": "<input type='checkbox' name='chk-row'></input>"
				, "sortable": false
			}   
			, { "title": "지역", "data": "restateRegion"}
			, { "title": "사업명", "data": "businessName"}
			, { "title": "건설사", "data": "builder"}
			, { "title": "공지일자", "data": "notiDay" }
			, { "title": "마감일자", "data": "deadlineDate" }
			, { "title": "상태", "data": "state" }
		]
		, "paging": false            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "autoWidth": false
		, "scrollY": "300px"
		, "scrollCollapse": true
		, "scrollX": true
		, "scrollXInner": "100%"
		//, "orderClasses": false
		//, "order": [[ 1, "desc" ]]
		, "deferRender": true           // defer
		, "lengthMenu": [[10], [10]]           // Row Setting [-1], ["All"]
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
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
			, {
				"targets": [2]
				, "class": "dt-head-center dt-body-left dtPercent30"
			}
			, {
				"targets": [3]
				, "class": "dt-head-center dt-body-left dtPercent30"
			}
			, {
				"targets": [4]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
			, {
				"targets": [5]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
			, {
				"targets": [6]
				, "class": "dt-head-center dt-body-center dtPercent10"
			}
		]
	});

};
//==================================JQuery DataTable Setting 끝==================================

var jdtListParcelInfoDetailRowIndex = -1;
//=== 수정 버튼 이벤트
function fun_clickButtonModifyLine() {
	if (fun_checkValidation()) {
		var table = $("#jdtListParcelInfoDetail").DataTable();
		var row = table.rows('.selected');          // 선택된 로우
		var idx = table.row('.selected').index();   // 선택된 로우의 인덱스값
		jdtListParcelInfoDetailRowIndex = idx;
		var t = $("#jdtListParcelInfoDetail").dataTable();

		if (row == undefined) {
			alert('라인 수정 상태가 아닙니다.');
		} else {
			t.fnUpdate({
				"<input type='checkbox' id='cbx_SelectAll' onclick='fun_SelectAll_jdtListParcelInfoDetail();'></input>": ""
				, "restateRegion": $("#sel_restateRegion option:selected").val()
				, "businessName": $("#txt_businessName").val()
				, "builder": $("#txt_builder").val()
				, "notiDay": $("#txt_notiDay").val()
				, "deadlineDate": $("#txt_deadlineDate").val()
				, "state": $("#sel_state option:selected").val()
			}, idx);        // 해당 인덱스값의 로우 데이터 업데이트

			// 수정 후 초기화
			fun_changeAfterinit();

			// 수정 후 라인 선택 해제
			//row.removeClass('selected');
			row.nodes().to$().removeClass('selected');
			chk_HasSel = true;
			
			setTimeout(function () {
				$("#txt_eanCode").focus();
			}, 800);
		}
	} else {
		return;
	}
	return false;
};

function fun_setJdtListParcelInfoDetailToTextbox() {
	var table = $("#jdtListParcelInfoDetail").DataTable();
	var selRow = table.rows('.selected').data()[0];

	if (selRow != undefined) {
		$("#sel_restateRegion").val(selRow.restateRegion);
		$("#txt_businessName").val(selRow.businessName);
		$("#txt_builder").val(selRow.builder);
		$("#sel_state").val(selRow.state);
		$("#txt_notiDay").val(selRow.notiDay);
		$("#txt_deadlineDate").val(selRow.deadlineDate);
	} else {
		//table.rows('.selected').removeClass('selected');
		table.rows('.selected').nodes().to$().removeClass('selected');
	}
	
};


//=== 추가 버튼 이벤트
function fun_clickButtonAddLine() {
	if (fun_checkValidation()) {
		var table = $("#jdtListParcelInfoDetail").DataTable();
		
		// 라인 선택 해제
		//row.removeClass('selected');
		table.rows('.selected').nodes().to$().removeClass('selected');
		chk_HasSel = true;

		table.row.add({
			"<input type='checkbox' id='cbx_SelectAll' onclick='fun_SelectAll_jdtListParcelInfoDetail();'></input>": ""
			, "restateRegion": $("#sel_restateRegion option:selected").val()
			, "businessName": $("#txt_businessName").val()
			, "builder": $("#txt_builder").val()
			, "notiDay": $("#txt_notiDay").val()
			, "deadlineDate": $("#txt_deadlineDate").val()
			, "state": $("#sel_state option:selected").val()
		}).draw();

		// 수정 후 초기화
		fun_changeAfterinit();
		
		setTimeout(function () {
			$("#txt_eanCode").focus();
		}, 800);
	} else {
		return;
	}
	return false;
};


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

	if($("#sel_state option:selected").val()=="분양계획"||$("#sel_state option:selected").val()=="미분양"){
	}
	else{
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
	}
	
	if($("#txt_deadlineDate").val()==""){
	}
	else{
		var splitNotidate = $("#txt_deadlineDate").val().split(".");
		var patternDate = /[0-9]{4}.[0-9]{2}.[0-9]{2}/;
		if(!patternDate.test(splitNotidate)){
			$("#txt_deadlineDate").focus();
			alert("마감일자의 형식은 YYYY.MM.DD 입니다");
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
	$("#txt_deadlineDate").val('');
	jdtListParcelInfoDetailRowIndex = -1;
};	


//=== 전체선택 체크시 이벤트
function fun_SelectAll_jdtListParcelInfoDetail() {
	var chk_SelectAll = $("#cbx_SelectAll").is(':checked');             // 전체선택 체크시 true
	var tr = $("#jdtListParcelInfoDetail tbody tr");

	if (tr[0].innerText != "데이터가 없습니다.") {                              // Row에 추가된 값이 있을시
		if (chk_SelectAll) {
			//$("#Content_jdt_ListMain tbody tr").addClass('selected');           // 클래스 추가
			$("input[name='chk-row']").prop('checked', true);
			$("#jdtListParcelInfoDetail tbody tr").removeClass('selected');            // .selected 클래스 제거
		} else {
			//$("#Content_jdt_ListMain tbody tr").removeClass('selected');        // 클래스 삭제
			$("input[name='chk-row']").prop('checked', false);
			$("#jdtListParcelInfoDetail tbody tr").removeClass('selected');            // .selected 클래스 제거
		}
		fun_changeAfterinit();

	} else {                                                                    // Row에 추가된 값이 없을시
		$("#cbx_SelectAll").attr('checked', false);                     // 전체선택 체크 해제
	}
};




function fun_validationSaveChk(){
	var chk = 0;
	var alert_temp = "";
	
	var table = $("#jdtListParcelInfoDetail").DataTable();
	var length = table.rows().data().length;
	
	if (length == 0) {
		alert_temp = alert_temp + "세부이력 데이터가 없습니다\n";
	}
	else{
		chk ++;
	}
	
	
	if (chk == "1") {
		return true;
	}
	else {
		alert_temp = alert_temp + "추가 할 수 없습니다";
		alert(alert_temp);
		return false;
	}
	return false;
}

function fun_clickButtonOfSaveTempParcelInfo(){
	var tempData = $('#jdtListParcelInfoDetail').tableToJSON({"headings":["idx", "restateRegion", "businessName", "builder", "notiDay", "deadlineDate", "state"], "ignoreEmptyRows":true});
	if(tempData[0].idx=="데이터가 없습니다."){
		if(confirm("저장 할 임시데이터가 없습니다.\n기존에 있던 임시데이터를 제거하시겠습니까?")){
			localStorage.setItem("tempParcelInfo", "");	
		}
	}
	else{
		localStorage.setItem("tempParcelInfo", JSON.stringify(tempData));	
		alert("임시데이터가 저장되었습니다.");
	}
	
}

function fun_clickButtonOfLoadTempParcelInfo(){
	if(localStorage.getItem("tempParcelInfo")==""){
		
	}
	else{
		var tempParcelInfo = JSON.parse(localStorage.getItem("tempParcelInfo"));
		fun_dataTableAddData("#jdtListParcelInfoDetail", tempParcelInfo);
		alert("임시데이터를 불러왔습니다.");
	}
}

function fun_clickButtonOfDeleteParcelInfo(){
	var table = $("#jdtListParcelInfo").DataTable();
	var row = table.rows('.selected').data()[0];
	;
	var idx = $("#hdf_idx").val();
	if(idx==-1){
		alert("최신분양정보가 선택되어 있지 않습니다.");
		return false;
	}
	if(confirm("저장되어 있는 " + idx + ", " + row.restateRegion + ", " + row.businessName + "를 삭제 하시겠습니까?")){
		var password = "비밀번호 없음";//$("#txt_adminPassword").val();
		
		var shaPassword = "";
		if(password != ""){
			shaPassword = hex_sha512(password);
		}
		else{
			$("#txt_adminPassword").focus();
			alert("로그인 비밀번호를 입력해주세요");
		}
		var inputData = {
			'idx' : idx
			,'password': shaPassword
		}

		fun_ajaxPostSend("/realestate/delete/parcelInfo.do", inputData, true, function(msg){
			if(msg!=null){
				switch(msg.code){
					case "0000":
						alert("삭제되었습니다.");
						fun_selectJdtListParcelInfo(function(){
						});
						break;
					case "0001":
						alert("삭제에 실패 하였습니다.")
				}
			}
		});
	}
}

function fun_clickButtonOfInsertParcelInfo(){
	if(fun_validationSaveChk()){
	}
	else{
		return false;
	}
	
	//=== Save Line Data
	var inputData = $('#jdtListParcelInfoDetail').tableToJSON({"headings":["idx", "restateRegion", "businessName", "builder", "notiDay", "deadlineDate", "state"], "ignoreEmptyRows":true});

	fun_ajaxPostSend("/realestate/insert/parcelInfo.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var msgResult = msg.result;
					var cantSaveParcel = "";
					if(msgResult==null||msgResult==undefined||msgResult==""){
					}
					else{
						msgResult = JSON.parse(msgResult);
						for(var i=0; i<msgResult.length; i++){
							var businessName = msgResult[i].businessName;
							var restateRegion = msgResult[i].restateRegion;
							cantSaveParcel += "지역 : " + restateRegion + ", 사업명 : " + businessName + "\n";
						}
					}
					if(cantSaveParcel==""){
						alert("저장되었습니다");
					}
					else{
						alert("아래의 항목을 제외한 데이터는 저장하였습니다\n" + cantSaveParcel);
					}
					break;
				case "0001":
			}
			fun_selectJdtListParcelInfo(function(){
				var t = $("#jdtListParcelInfoDetail").dataTable();
				t.fnClearTable();
			});
			
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
	return false;
};
</script>



<form id="membership" method="post" enctype="multipart/form-data" action="">
   	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header" style="font-size:24px">최신분양정보</h1>
	    </div>
	    <!-- /.col-lg-12 -->
    </div>
	
	<div class="row" id="div_row2">
		<div class="col-lg-12">
			
		</div>
	</div>

	<div class="row" id="div_row2">
        <div class="col-lg-12">
            <div id="accordion1" class="accordion-style1 panel-group accordion-style2">
                <div class="panel panel-default" id="tog_Head">
                    <div class="panel-heading clearfix" style="font-size:16px">
                        <span class="toggle_accordion">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse1" >
				    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
				    &nbsp;최신분양정보 조회
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                            
                        </span>
                    </div>
                    <div id="collapse1" class="panel-collapse collapse in">
                        <div class="panel-body">
							<input type="text" id="txt_searchParcelInfo" class="form-control" placeholder="테이블 내 검색" />
                            <div class="dataTable_wrapper">
                                <table id="jdtListParcelInfo" class="table table-striped table-bordered table-hover">
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
	
	<div class="space-16"></div>

	<div class="row" id="div_row3">
        <div class="col-lg-12">
            <div id="accordion3" class="accordion-style1 panel-group accordion-style2">
                <div class="panel panel-default" id="tog_Head">
                    <div class="panel-heading clearfix" style="font-size:16px">
                        <span class="toggle_accordion">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse3" >
				    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
				    &nbsp;최신분양정보 등록
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                            
                        </span>
                    </div>
                    <div id="collapse3" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="dataTable_wrapper">
                                <table id="jdtListParcelInfoDetail" class="table table-striped table-bordered table-hover">
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
	

	<div class="row" id="div_row4">
        <div class="col-lg-12">
            <div id="accordion4" class="accordion-style1 panel-group accordion-style2">
                <div class="panel panel-default">
                    <div class="panel-heading clearfix" style="font-size:13px;font-family:'Malgun Gothic' !important;">
                        <span class="toggle_accordion">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse4" >
				    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
				    &nbsp;분양정보
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                            
                        </span>
                    </div>
                    <div id="collapse4" class="panel-collapse collapse in">
                        <div class="panel panel-body">
                            <div class="row form-group form-group-sm">
                                <div class="col-lg-1 col-md-2" style="padding-top:4px;">
									지역
                                </div>
                                <div class="col-lg-2 col-md-4">
									<select id="sel_restateRegion" class="form-control">
										<option value="">----선택----</option>
										<option value="서울">서울</option>
										<option value="경기">경기</option>
										<option value="인천">인천</option>
										<option value="세종">세종</option>
										<option value="부산">부산</option>
										<option value="울산">울산</option>
										<option value="광주">광주</option>
										<option value="대구">대구</option>
										<option value="대전">대전</option>
										<option value="강원">강원</option>
										<option value="충남">충남</option>
										<option value="충북">충북</option>
										<option value="전남">전남</option>
										<option value="전북">전북</option>
										<option value="경남">경남</option>
										<option value="경북">경북</option>
										<option value="제주">제주</option>
									</select>
                                </div>
                                <div class="hidden-lg hidden-xs col-md-12">
                                    <p></p>
                                </div>
                                <div class="col-lg-1 col-md-2" style="padding-top:4px;">
                                    사업명
                                </div>
                                <div class="col-lg-2 col-md-4">
                                    <input type="text" ID="txt_businessName" class="form-control" placeholder="사업명" onkeyup="">
                                </div>
                                <div class="col-lg-1 col-md-2" style="padding-top:4px;">
                                    건설사
                                </div>
                                <div class="col-lg-2 col-md-4">
                                	<input type="text" ID="txt_builder" class="form-control" placeholder="사업명" onkeyup="">
                                </div>
                                <div class="col-lg-1 col-md-2" style="padding-top:4px;">
                                    상태
                                </div>
                                <div class="col-lg-2 col-md-4">
                                	<select id="sel_state" class="form-control">
										<option value="">----선택----</option>
										<option value="청약중">청약중</option>
										<option value="분양중">분양중</option>
										<option value="분양계획">분양계획</option>
										<option value="미분양">미분양</option>
									</select>
                                </div>
                            </div>
	                        <div class="row form-group form-group-sm">
	                        	<div class="col-lg-1 col-md-2" style="padding-top:4px;">
	                           		공지일자
	                            </div>
	                            <div class="col-lg-2 col-md-4">
	                                <input type="text" ID="txt_notiDay" class="form-control" placeholder="2021.05.26">
	                            </div>
	                            <div class="col-lg-1 col-md-2" style="padding-top:4px;">
	                           		마감일자
	                            </div>
	                            <div class="col-lg-2 col-md-4">
	                                <input type="text" ID="txt_deadlineDate" class="form-control" placeholder="2021.05.26">
	                            </div>
	                        </div>
	                	</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    
    
    <div class="row">
        <div class="col-lg-12">
            <div class="col-lg-5 col-md-5">
                
            </div>
            <div class="hidden-lg hidden-md col-sm-12"><p></p></div>
            <div class="col-lg-7 col-md-7">
                <div class="btn-group btn-overlap pull-right" style="padding-right:20px;">
                    <div class="btn-group" data-toggle="tooltip" data-placement="top" data-original-title="라인선택삭제">
                        <button type="button" id="btn_DeleteSelect" class="btn btn-white btn-danger btn-bold">
                            <span><i class="ui-icon ace-icon fa fa-trash red"></i>&nbsp;항목삭제</span>
                        </button>
                        &nbsp;
                    </div>
                    <div class="btn-group" data-toggle="tooltip" data-placement="top" data-original-title="라인수정">
                    &nbsp;
                        <button type="button" id="btn_ModiLine" class="btn btn-white btn-inverse btn-bold" onclick="return fun_clickButtonModifyLine();">
                            <span><i class="ui-icon ace-icon fa fa-pencil black"></i>&nbsp;항목수정</span>
                        </button>
                    </div>
                    <div class="btn-group" data-toggle="tooltip" data-placement="top" data-original-title="라인추가">
                    	&nbsp;
                        <button type="button" id="btn_AddLine" class="btn btn-white btn-info btn-bold" onclick="return fun_clickButtonAddLine();">
                            <!--<span><i class="ui-icon ace-icon glyphicon glyphicon-plus blue"></i></span>-->
                            <span><i class="ui-icon ace-icon fa fa-plus blue"></i>&nbsp;항목추가</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="space-16"></div>
    
    <div class="row">
		<div class="col-lg-12">
			<div class="col-lg-4 col-md-4">
				<button type="button" id="btn_save" class="btn btn-white btn-default btn-bold" onclick="return fun_clickButtonOfSaveTempParcelInfo();">
					<i class="ace-icon fa fa-clipboard green"></i>
					임시저장
				</button> 
				<button type="button" id="btn_save" class="btn btn-white btn-default btn-bold" onclick="return fun_clickButtonOfLoadTempParcelInfo();">
					<i class="ace-icon fa fa-clipboard green"></i>
					임시저장된 데이터 불러오기
				</button> 
			</div>
			<div class="col-lg-4 col-md-4">
				<div class="col-lg-2 col-md-2">				
					
				</div>
				<div class="col-lg-2 col-md-2">				
					<!--  로그인<br>비밀번호 -->
				</div>
				<div class="col-lg-4 col-md-4">
					<!-- <input type="password" id="txt_adminPassword" class="form-control" value="" /> -->
				</div>
				<div class="col-lg-4 col-md-4">
				<button type="button" id="btn_Delete" class="btn btn-white btn-warning btn-bold" onclick="return fun_clickButtonOfDeleteParcelInfo();" >
					<i class="ace-icon fa fa-trash-o bigger-120 red"></i>
					최신분양정보 삭제
				</button>
				</div>
			</div>
			<div class="col-lg-4 col-md-4" style="text-align: right">
				<button type="button" id="btn_save" class="btn btn-white btn-default btn-bold" onclick="return fun_clickButtonOfInsertParcelInfo();">
					<i class="ace-icon fa fa-clipboard green"></i>
					저장
				</button> 
			</div>
		</div>
	</div>
	<input type="hidden" id="hdf_idx" value="-1" />
</form>
