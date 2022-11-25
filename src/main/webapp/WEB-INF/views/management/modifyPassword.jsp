<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>

var check = 'N';

window.onload = function(){
};

$(document).ready(function () {
	var ua = navigator.userAgent;
	var checker = {
		iphone: ua.match(/(iPhone|iPod|iPad)/),
		blackberry: ua.match(/BlackBerry/),
		android: ua.match(/Android/)
	};

	$("#txt_oldPassword").focus();
	fun_initializeClickEvent();
});


function fun_initializeClickEvent(){
	$("#txt_newPassword1").on('keyup', function(e){
		if(event.type=="keyup"){
			var pattern = /^(?=.*\d)(?=.*[~`!@#$%\^&*()-])(?=.*[a-zA-Z]).{7,20}$/;
			
			if(!pattern.test($("#txt_newPassword1").val())){
				$("#lbl_newPassword1").empty();
				$("#lbl_newPassword1").append('사용불가능');
				check = 'N';
			}
			else{
				$("#lbl_newPassword1").empty();
				$("#lbl_newPassword1").append('사용가능');
				check = 'Y';
				if(e.keyCode==13){
					$("#txt_newPassword2").focus();
				}
			}
			
		}
	});
	
	$("#txt_newPassword2").on('keyup', function(e){
		if(event.type=="keyup"){
			if($("#txt_newPassword1").val() == $("#txt_newPassword2").val()){
				$("#lbl_newPassword2").empty();
				$("#lbl_newPassword2").append('일치');
				check = 'Y';
				if(e.keyCode==13){
					$("#btn_Save").trigger("click");
				}
			}
			else{
				$("#lbl_newPassword2").empty();
				$("#lbl_newPassword2").append('불일치');
				check = 'N';
			}
			
		}
	});

	$("#txt_oldPassword").on("keyup", function(e){
		if(event.type=="keyup"){
			if(e.keyCode==13){
				$("#txt_newPassword1").focus();
			}
		}
	});
}

//=== 추가/수정 이후 히든값 및 텍스트 초기화
function fun_changeAfterinit() {
	$("#txt_oldPassword").val('');
	$("#txt_newPassword1").val('');
	$("#txt_newPassword2").val('');
	$("#lbl_newPassword1").empty();
	$("#lbl_newPassword2").empty();
};	


function fun_validationSaveChk(){
	var chk = 0;
	var alert_temp = "";

	var patternPassword = /^(?=.*\d)(?=.*[~`!@#$%&^*()\-_=+\[\]{}\\|;:,./<>?])(?=.*[a-zA-Z]).{7,20}$/;

	var oldPassword = $("#txt_oldPassword").val();
	var newPassword1 = $("#txt_newPassword1").val();
	var newPassword2 = $("#txt_newPassword2").val();

	if(check == 'N'){
		alert_temp = alert_temp + "변경 할 비밀번호와 변경 후 비밀번호를 확인 해주세요\n";
	}
	else{
		chk++;
	}

	if(!patternPassword.test(newPassword2)){
		alert_temp = alert_temp + "비밀번호는 영문+숫자+특수문자의 조합으로 7자리 이상으로 작성해주세요\n";
	}
	else{
		chk++;
	}
	
	if (chk == "2") {
		return true;
	}
	else {
		$("#txt_newPassword1").focus();
		alert_temp = alert_temp + "수정 할 수 없습니다";
		alert(alert_temp);
		return false;
	}
	return false;
}

function fun_clickButtonOfInserPassword() {
	if(fun_validationSaveChk()){
	}else{
		return false;
	}
	
	if(check == "Y"){
		if (confirm('수정하시겠습니까?')){
			var shaOldPassword = "";
			var shaNewPassword1 = "";
			var shaNewPassword2 = "";
			var oldPassword = $("#txt_oldPassword").val();
			var newPassword1 = $("#txt_newPassword1").val();
			var newPassword2 = $("#txt_newPassword2").val();
			
			
			if(oldPassword != ""){
				shaOldPassword = hex_sha512(oldPassword);
			}
			if(newPassword1 != ""){
				shaNewPassword1 = hex_sha512(newPassword1);
			}
			if(newPassword2 != ""){
				shaNewPassword2 = hex_sha512(newPassword2);
			}
			
			var inputData = { 
					'oldPassword': shaOldPassword
					, 'newPassword1': shaNewPassword1
					, 'newPassword2': shaNewPassword2
			};

			fun_ajaxPostSend("/management/update/password.do", inputData, true, function(msg){
				if(msg!=null){
					switch(msg.code){
						case "0000":
							alert("변경이 완료되었습니다");
							break;
						default:
							$("#txt_oldPassword").focus();
							alert("변경이 실패하였습니다");
					}
					//fun_selectCommonJoinMessage(function(){});
					fun_changeAfterinit();
				}
				else{
					//alert('서비스가 일시적으로 원활하지 않습니다.');
				}
			});
		}
	}
	return false;
};
</script>



<form id="membership" method="post" enctype="multipart/form-data" action="">
   	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header" style="font-size:24px">사용자 정보변경</h1>
	    </div>
	    <!-- /.col-lg-12 -->
    </div>

   
   	<div class="row" id="div_row1">
        <div class="col-lg-12">
            <div id="accordion1" class="accordion-style1 panel-group accordion-style2">
                <div class="panel panel-default">
                    <div class="panel-heading clearfix" style="font-size:13px;font-family:'Malgun Gothic' !important;">
                        <span class="toggle_accordion">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse1" >
				    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
				    &nbsp;ADMIN정보
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                            
                        </span>
                    </div>
                    <div id="collapse1" class="panel-collapse collapse in">
                        <div class="panel panel-body">
                            <div class="row form-group form-group-sm">
                                <div class="col-lg-2 col-md-4" style="padding-top:4px;">
                                    	이름
                                </div>
                                <div class="col-lg-2 col-md-4">
                                	<input type="text" ID="txt_webUserid" class="form-control" value="${userName}" placeholder="아이디" disabled="disabled" />
                                </div>
                                
                                <div class="hidden-lg hidden-xs col-md-12">
                                    <p></p>
                                </div>
                            </div>
                            <div class="row form-group form-group-sm">
                            	 <div class="col-lg-2 col-md-4" style="padding-top:4px;">
                                    	변경전 비밀번호
                                </div>
                                <div class="col-lg-2 col-md-4">
                                	<input type="password" ID="txt_oldPassword" class="form-control" placeholder="비밀번호" />
                                </div>
                            </div>
                            <div class="row form-group form-group-sm">
                                <div class="col-lg-2 col-md-4" style="padding-top:4px;">
                                    	변경할 비밀번호
                                </div>
                                <div class="col-lg-2 col-md-4">
                                	<input type="password" ID="txt_newPassword1" class="form-control" placeholder="비밀번호" />
                                </div>
                                <div class="col-lg-1 col-md-2" id="lbl_newPassword1" style="padding-top:4px;">
                                	
                                </div>
                            </div>
                            <div class="row form-group form-group-sm">
                            	 <div class="col-lg-6 col-md-6"  style="padding-top:4px;">
                                	영문+숫자+특수문자의 조합으로 7자리 이상
                                </div>
                            </div>
                            <div class="row form-group form-group-sm">
                                <div class="col-lg-2 col-md-4" style="padding-top:4px;">
                                    	변경할 비밀번호(확인)
                                </div>
                                <div class="col-lg-2 col-md-4">
                                	<input type="password" ID="txt_newPassword2" class="form-control" placeholder="비밀번호" />
                                </div>
                                <div class="col-lg-1 col-md-2" id="lbl_newPassword2" style="padding-top:4px;">
                                	
                                </div>
                                
                                <div class="hidden-lg hidden-xs col-md-12">
                                    <p></p>
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
                    <!-- <input type="button" ID="btn_Delete" value="삭제" class="btn btn-danger btn-sm" onclick="return fun_Click_btn_DelDoc();" /> -->
                    &nbsp;
                    <input type="button" ID="btn_Save" value="수정" class="btn btn-primary btn-sm" onclick="return fun_clickButtonOfInserPassword();" />
                </div> 
            </div>
        </div>
    </div>
	<input type="hidden" value="" id="hdf_check" />
</form>