<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page trimDirectiveWhitespaces="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>infovine Admin</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>
	<meta name="viewport" content="width=device-width, initial-scale=1"></meta>
	<meta name="description" content=""></meta>
	<meta name="author" content=""></meta>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width , initial-scale=1, maximum-scale=1">
	
	<link rel="shortcut icon" href="../assets/images/favicon.ico">
	<link rel="icon" type="image/png" href="../assets/images/favicon.png" sizes="192x192">
	<link rel="stylesheet" href="../assets/lib/chart/Chart.min.css">
	<link rel="shortcut icon" href="../assets/images/favicon.ico">
	<link rel="icon" type="image/png" href="../assets/images/favicon.png" sizes="192x192">
	<link rel="stylesheet" type="text/css" href="../assets/lib/fontawesome-free/css/all.css">
	<link rel="stylesheet" type="text/css" href="../assets/lib/bootstrap/css/bootstrap-select.min.css">
	<link rel="stylesheet" type="text/css" href="../assets/css/bootstrap.css">
	<link rel="stylesheet" type="text/css" href="../assets/lib/swiper/css/swiper.min.css">
	<link rel="stylesheet" type="text/css" href="../assets/lib/jquery-ui/jquery-ui.min.css">
	<link rel="stylesheet" href="../assets/lib/chart/Chart.min.css">
	<link rel="stylesheet" href="../assets/css/adminlte.css">
	<link rel="stylesheet" href="../assets/css/style.css">
	<!-- Additional style(개발단에서 수정 및 추가 필요한 경우 additional.css에 작성)  -->
	<link rel="stylesheet" href="../assets/css/additional.css">
	<link rel="stylesheet" href="../assets/css/custom_pagenate.css">
	
	<!-- 	Toast UI Editor -->
	<link rel="stylesheet" href="../assets/css/editor/toastui-editor.min.css">
	
	<script  src="../assets/js/jquery-3.3.1.js"></script>
	<script  src="../assets/js/c21.js"></script>
	<script  src="../assets/js/common.js"></script>
	<script src="../assets/lib/jquery-ui/jquery-ui.min.js"></script>
	<script src="../assets/js/ui.js" defer></script>
	<script  src="../assets/js/adminlte.min.js"></script>
	<!-- basic scripts -->
	<script src="../assets/js/bootstrap.js?version=0.0" type="text/javascript"></script>
	<script src="../assets/js/jquery-ui.custom.js" type="text/javascript"></script>
	<script src="../assets/js/jquery.ui.touch-punch.js" type="text/javascript"></script>

	<!-- Datatable Script -->
	<script src="../assets/js/dataTables/jquery.dataTables.js" type="text/javascript"></script>
	<script src="../assets/js/dataTables/jquery.dataTables.bootstrap.js" type="text/javascript"></script>

	<script src="../assets/js/excel/xlsx.full.min.js"></script>
	<script src="../assets/js/excel/FileSaver.min.js"></script>
	
	<script src="../assets/js/cryptoJs/sha512.js"></script>
	<script src="../assets/js/module.js?version=0.1"></script>
	<script src="../assets/js/blockUI.js?version=0.1"></script>
	
	<!-- 	Toast UI Editor -->
	<script src="../assets/js/editor/toastui-editor-all.min.js?version=0.1"></script>
	
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
		alert(alert_temp);
		return false;
	}
	else{
		chk++;
	}

	if(!patternPassword.test(newPassword2)){
		alert_temp = alert_temp + "비밀번호는 영문+숫자+특수문자의 조합으로 7자리 이상으로 작성해주세요\n";
		alert(alert_temp);
		return false;
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

			fun_ajaxPostSend("/admin/update/passWdReset.do", inputData, true, function(msg){
				if(msg!=null){
					switch(msg.code){
						case "0000":
							alert("변경이 완료되었습니다\n변경된 비밀번호로 다시 로그인 해주세요");
							location.href="/admin/loginView.do";
							break;
						default:
							$("#txt_oldPassword").focus();
							alert("변경이 실패하였습니다");
					}
					//fun_selectCommonJoinMessage(function(){});
					fun_changeAfterinit();
				}
				else{
					alert("변경시간이 초과하였습니다.\n로그인페이지로 이동합니다.");
					location.href="/admin/loginView.do";
					//alert('서비스가 일시적으로 원활하지 않습니다.');
				}
			});
		}
	}
	return false;
};
</script>

</head>
<body class="no-skin">
	<nav class="main-header navbar navbar-expand navbar-white navbar-light">
		<div id="top_user" class="ml-auto">
			<div class="d-flex align-items-center pr-2">
				<div class="d-flex align-items-center">
					<i class="fas fa-user-circle mr-2 font-size-30px"></i>
					<a href="">${userName}</a>
				</div>
				<button type="button" class="btn btn-light btn-round ml-4" onclick="javascript:location.href='/admin/logout.do'">로그아웃</button>
		</div>
		</div>
	</nav>
	<div class="main-container" id="main-container">
    
	    <!--Top Menu-->
	    <div id="top_menu" style="display:none;">
	        <div id="head_div" class="sidebar h-sidebar navbar-collapse collapse">
	            <div class="sidebar-shortcuts" id="sidebar-shortcuts">
					<div class="sidebar-shortcuts-large" id="sidebar-shortcuts-large">
						<a href="#" class="btn btn-danger">
	                        <i class="ace-icon fa fa-tachometer"></i>
						</a>
					</div>
	
					<div class="sidebar-shortcuts-mini" id="sidebar-shortcuts-mini">
						<a href="#" class="btn btn-danger"></a>
					</div>
				</div><!-- /.sidebar-shortcuts -->
	
	        </div>
	    </div>
	    
	   <aside class="main-sidebar sidebar-dark-primary">
            <a href="#none" class="brand-link text-center">
                대기몇명
                <div class="mt-1"></div>
            </a>
       </aside> 
        
	    
     <!-- Content -->
	 <div class="main-content">
	 	<div class="main-content-inner">
	    	<div class="page-content">
		    		
		    		
		    		<div class="wrapper">
			          <div class="content-wrapper">
			            <!-- 상단 title -->
			            <div class="content-header">
			               <div class="container-fluid">
			                  <div class="row">
			                     <div class="col">
			                        <h1 class="title">사용자 정보변경</h1>
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
			                                        <th>이름</th>
			                                        <td colspan="3">
			                                           <input type="text" ID="txt_webUserid" class="form-control" value="${userName}" placeholder="아이디" disabled="disabled" />
			                                        </td>
			                                    </tr>
			                                    <tr>
			                                        <th>변경전 비밀번호</th>
			                                        <td colspan="3">
			                                           <input type="password" ID="txt_oldPassword" class="form-control" placeholder="비밀번호" />
			                                        </td>
			                                    </tr>
			                                    <tr>
			                                        <th>변경할 비밀번호</th>
			                                        <td colspan="3">
			                                           <input type="password" ID="txt_newPassword1" class="form-control" placeholder="비밀번호" />
			                                           <div class="col-lg-6 col-md-6"  style="color:red;padding-top:4px;">
						                                	영문+숫자+특수문자의 조합으로 7자리 이상
						                                </div>
			                                        </td>
			                                    </tr>
			                                    <tr>
			                                        <th>변경할 비밀번호(확인)</th>
			                                        <td colspan="3">
			                                           <input type="password" ID="txt_newPassword2" class="form-control" placeholder="비밀번호" />
			                                           <div class="col-lg-6 col-md-6"  style="color:red;padding-top:4px;">
						                                	영문+숫자+특수문자의 조합으로 7자리 이상
						                                </div>
			                                        </td>
			                                    </tr>
			                                </tbody>
			                            </table>
			                            <div class="btns">
			                                <button type="button" class="btn btn-dark min-width-90px" onclick="return fun_clickButtonOfInserPassword();">수정</button>
			                            </div>
			                        </div>
			                    </section>
			
			                </div>
			                
			            </div>
			        </div>
			    </div>
		    		
		    		
		    </div>
		 </div>
	</div>
	</body>
	
</html>