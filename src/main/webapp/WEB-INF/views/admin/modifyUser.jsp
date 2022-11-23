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

	$('.panel').on('shown.bs.collapse', function (e) {
		$('#jdtListAdminUser').dataTable().fnAdjustColumnSizing();
	});

	fun_initializeClickEvent();
	fun_setjdtListAdminUser(function(){
		fun_selectjdtListAdminUser(function(){

		});
	});
	$("#hdf_adminUserSeq").val('-1');

	
	// $("#txt_userId").val("test");
	// $("#txt_newPassword").val("");
	// $("#txt_userName").val("test11");
	// $("#sel_userTypeCode").val("1");
});



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

function fun_initializeClickEvent(){
	$('#jdtListAdminUser').delegate('tr', 'click', function () {
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
				$("#dtp_visitDate").val(date);
				
				$("#txt_postCode").val('');
				$("#txt_address").val('');
				$("#txt_addressDetail").val('');
				$("#txt_headerRemarks").val('');
				$("#rdi_sex1").prop('checked', true);
				$("#cbx_age").val('5');
				
				var t = $("#jdtListAdminUserDetail").dataTable();
				t.fnClearTable();
				setTimeout(function () {
					t.fnAdjustColumnSizing();
				}, 200);
				
				fun_changeAfterinit();
			} else {
				$("#jdtListAdminUser tbody tr").removeClass('selected');
				$("#cbx_SelectAll").attr('checked', false);         // 전체선택 체크 해제
				$("input[name='chk-admin']").prop('checked', false);  // 선택 줄 외 체크 해제
				$(this).toggleClass('selected');
				this.children[0].lastChild.checked = true;
				//$(this)[0].children(0).lastChild.checked = true;
				
				fun_clickjdtListAdminUser();   // 선택한 줄 값 라인에 입력
			}
		}
		
		
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
	});


	//테이블 검색시
	$("#txt_searchParcelInfo").on('keyup click', function () {
		$("#jdtListAdminUser").DataTable().search(
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
		var oTable = $("#jdtListAdminUserDetail").DataTable();
		var t = $("#jdtListAdminUserDetail").dataTable();
		
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
			, { "title": "아이디", "data": "userId"}
			, { "title": "이름", "data": "userName"}
			, { "title": "코드", "data": "userTypeCode"}
			, { "title": "패스워드오류", "data": "passwordErrorCount" }
			, { "title": "마지막로그인", "data": "lastloginDate" }
			, { "title": "블록", "data": "blockYn" }
			
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
		$("#txt_userId").val(row.userId);
		$("#txt_userId").attr("disabled",true); 
		$("#txt_userName").val(row.userName);
		$("#txt_userName").attr("disabled",true); 
		$("#sel_userTypeCode").val(row.userTypeCode);
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


function fun_clickButtonInsertAdminUser(){
	
	
	if (confirm('등록 및 수정하시겠습니까?')){
		var password = $("#txt_adminPassword").val();
		var newPassword = $("#txt_newPassword").val();
		var shaPassword = "";
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
   	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header" style="font-size:24px">사용자 등록 및 수정</h1>
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
				    &nbsp;사용자 조회
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                            <input type="text" id="txt_searchParcelInfo" class="form-control" placeholder="테이블 내 검색" />
                        </span>
                    </div>
                    <div id="collapse1" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="dataTable_wrapper">
                                <table id="jdtListAdminUser" class="table table-striped table-bordered table-hover">
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

	<div class="row">
            <div class="col-lg-12">
                <div id="accordion2" class="accordion-style1 panel-group accordion-style2">
                    <div class="panel panel-default" id="tog_Detail">
                        <div class="panel-heading clearfix" style="font-size:16px">
                            <span class="toggle_accordion">
                                <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse2" >
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
                                    <div class="col-lg-1 col-sm-2" style="padding-top:4px;">아이디</div>
                                    <div class="col-lg-2 col-sm-4">
                                        <input type="text" id="txt_userId" class="form-control" placeholder="Ex) admin" />
                                    </div>
                                    <div class="col-lg-1 col-sm-2" style="padding-top:4px;">비밀번호</div>
                                    <div class="col-lg-2 col-sm-4">
                                        <input type="password" id="txt_newPassword" class="form-control" placeholder="" />
									</div>
									<div class="col-lg-1 col-sm-2" style="padding-top:4px;">이름</div>
                                    <div class="col-lg-2 col-sm-4">
                                        <input type="text" id="txt_userName" class="form-control" placeholder="" />
                                    </div>
                                </div>
                                <div class="row form-group form-group-sm">
                                	<div class="col-lg-12 col-sm-12" style="color: Red">
                                		※ 비밀번호는 공란으로 둘 경우 비밀번호는 변경되지 않습니다
                                	</div>
                                </div>
                                <div class="row form-group form-group-sm">
                                	<div class="col-lg-1 col-sm-2" style="padding-top:4px;">유저타입</div>
                                    <div class="col-lg-2 col-sm-4">
                                        <select id="sel_userTypeCode">
											<option value="-1">---선택---</option>
											<option value="00">관리자</option>
											<option value="01">마케팅</option>
                                        </select>
                                    </div>
                                    <div class="hidden-lg hidden-xs col-md-12">
                                    	<p></p>
                                 	</div>
                                    <div class="col-lg-1 col-sm-2">로그인<br>패스워드</div>
				                	<div class="col-lg-2 col-sm-4">
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
                     <input type="button" ID="btn_block" value="블럭설정" class="btn btn-danger btn-sm" onclick="return fun_clickButtonBlockAdminUser();" />
                     &nbsp;
                     <input type="button" ID="btn_unblock" value="블럭해제" class="btn btn-primary btn-sm" onclick="return fun_clickButtonUnBlockAdminUser();" />
                     &nbsp;
                     <input type="button" ID="btn_Save" value="추가 및 수정" class="btn btn-primary btn-sm" onclick="return fun_clickButtonInsertAdminUser();" />
                 </div> 
             </div>
         </div>
     </div>
	 <input type="hidden" id="hdf_adminUserSeq" value="" />
</form>
