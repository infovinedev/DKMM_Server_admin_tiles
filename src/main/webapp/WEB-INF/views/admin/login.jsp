<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="javax.servlet.http.*" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
 	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", -1);
 %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>관리자 시스템</title>
	<meta http-equiv="x-ua-compatible" content="ie=edge">
	<meta name="format-detection" content="telephone=no">
	<link rel="shortcut icon" href="../assets/images/favicon.png">
	<link rel="icon" type="image/png" href="../assets/images/favicon.png" sizes="192x192">
	<link rel="stylesheet" type="text/css" href="../assets/lib/fontawesome-free/css/all.css">
	<link rel="stylesheet" href="../assets/lib/bootstrap/css/bootstrap-select.min.css">
	<link rel="stylesheet" href="../assets/lib/swiper/css/swiper.min.css">
	<link rel="stylesheet" href="../assets/lib/jquery-ui/jquery-ui.min.css">
	<link rel="stylesheet" href="../assets/lib/chart/Chart.min.css">
	<link rel="stylesheet" href="../assets/css/adminlte.css">
	<link rel="stylesheet" href="../assets/css/style.css">
	<!-- Additional style(개발단에서 수정 및 추가 필요한 경우 additional.css에 작성)  -->
	<link rel="stylesheet" href="../assets/css/additional.css">

	<script src="../assets/lib/jquery/jquery.min.js"></script>
	<script src="../assets/lib/jquery-ui/jquery-ui.min.js"></script>
	<script src="../assets/lib/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="../assets/lib/moment/moment.min.js"></script>
	<script src="../assets/lib/bootstrap/js/bootstrap-select.js"></script>
	<script src="../assets/lib/swiper/js/swiper.min.js"></script>

	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-ui-timepicker-addon/1.6.3/jquery-ui-timepicker-addon.min.css">

	<script src="../assets/js/cryptoJs/sha512.js"></script>
	<script src="../assets/js/module.js"></script>
</head>
<script type="text/javascript">
	if ('ontouchstart' in document.documentElement) document.write("<script src='../assets/js/jquery.mobile.custom.js'>" + "<" + "/script>");
	var errorCode = '${param.errorCode}';
	var enterCount = 0;

	jQuery(function ($) {
		$("#username").focus();
		
		$(document).on('click', '.toolbar a[data-target]', function (e) {
			e.preventDefault();
			var target = $(this).data('target');
			$('.widget-box.visible').removeClass('visible'); //hide others
			$(target).addClass('visible'); //show target
		});
		
		$('.password-visiblity').on('click', function() {
			if (!$(this).hasClass('active')) {
				$(this).addClass('active');
				$('#password').attr('type', 'text');
			} else {
				$(this).removeClass('active');
				$('#password').attr('type', 'password');
			}
		});

		$("#username").on("keyup", function(e){
			if(e.keyCode==13){
				$("#password").focus();
				
			}
		});

		$("#password").on("keyup", function(e){
			if(e.keyCode==13){
				if(enterCount==0){
					enterCount++;
					$("#btn_login").trigger("click");
				}
			}
		});

		$("#btn_login").on("click", function(e){
			var username = $("#username").val();
			var password = $("#password").val();
			

			if(username == ""){
				$("#username").focus();
				alert("아이디를 입력해주세요");
				enterCount=0;
				return false;
			}

			if(password==""){
				$("#password").focus();
				alert("비밀번호를 입력해주세요");
				enterCount=0;
				return false;
			}
			
			var shaPassword = "";
			if(password != ""){
				shaPassword = hex_sha512(password);
			}
			$("#password").val(shaPassword);
			//$("#loading_login").show();
			$("#submitLogin").trigger("click");
		});

	});

	if(errorCode=="403"){
		alert("아이디나 비밀번호를 확인해주세요");
		location.href="/admin/loginView.do";
	}
	else if(errorCode=="session"){
		alert("세션이 만료되었습니다");
	}
	
	function fn_check_login(th){
		$(".check_text_div").css("display", "none");
		var v = $(th).val();
		if(v==""){
			$(th).closest("div").next().css("display", "");
		}
	}
</script>
</head>
<!-- <form id="loginForm" method="POST" action="/admin/loginSecurity.do">  -->
<body class="body-login">
<div id="login-wrap">
        <div class="login">
             <form id="loginForm" method="POST" action="/admin/loginSecurity.do">
            	<input name="menuType" type="hidden" value="admin"/>
                <div class="login-head">
                    <div class="login-logo">
                        <!-- <img src="/pub/admin/assets/images/logo-login.svg" alt="">-->
                    </div>
                    <h1>대기몇명 ADMIN </h1>
                </div>
                <div class="login-body">
                    <div class="form-group">
                        <input id="username" name="username" type="text" class="form-control form-control-lg" value="">
                    </div>
                    <div class="mb-1 check_text_div" style="display:none">
                        <p class="form-text text-danger">ⓘ 이메일(아이디)를 입력해주세요.</p>
                    </div>
                    <div class="form-group">
                        <input id="password" name="password" type="password" class="form-control form-control-lg" value="">
                        <a href="javascript:;" class="password-visiblity"><i class="fas fa-eye-slash"></i></a>
                    </div>
                    <div clsss="check_text_div" style="display:none">
                        <p class="form-text text-danger">ⓘ 비밀번호를 입력해주세요.</p>
                    </div>
                    <button type="button" class="btn btn-primary btn-block btn-lg mt-4" id="btn_login">로그인</button>
                </div>
                <div class="login-foot">
                    <p>
                        아이디, 비밀번호로 로그인 하시면 사용 가능한 메뉴를 보실 수 있습니다. <br>
                        이용에 관한 문의사항은 담당자에게 연락 주시기 바랍니다.
                    </p>
                </div>
               <input type="submit" id="dummySubmitLogin" style="opacity: 0;" onclick="return false;">
               <input type="submit" id="submitLogin" style="opacity: 0;">
            </form>
        </div>
    </div>
</body>
</html>