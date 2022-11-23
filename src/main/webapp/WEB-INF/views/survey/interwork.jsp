<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="../assets/js/cryptoJs/aes.js"></script>
<script>
var jdtListWithoutMember;
var jdtListInterWork;
var key = CryptoJS.enc.Utf8.parse("${crypto}");
var timeloop;
var certId = "";
var certToken = "";
window.onload = function(){
	setTimeout(function(){		//left메뉴를 불러오는 시간으로 인해 늦게 실행되어야함
		//CS에서 접근했는지 관리에서 접근했는지에 따라 다르게 동작해야함
		fun_selectServiceCode(function(){});
	}, 300);
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
		$('#jdtListInterWork').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
		var dataTableWrapperHeight = $("#dataTable_wrapper1").height();
		$("#loading_jdtListInterWork").height(dataTableWrapperHeight);
		//$('#jdtListMember').dataTable().fnAdjustColumnSizing();
	});

	$('.panel').on('shown.bs.collapse', function (e) {
		$('#jdtListInterWork').dataTable().fnAdjustColumnSizing();
		var dataTableWrapperHeight = $("#dataTable_wrapper1").height();
		$("#loading_jdtListInterWork").height(dataTableWrapperHeight);
		//$('#jdtListMember').dataTable().fnAdjustColumnSizing();
	});

	fun_initializeClickEvent();

	fun_setjdtListInterWork();
	
	var dataTableWrapperHeight = $("#dataTable_wrapper1").height();
	$("#loading_jdtListInterWork").height(dataTableWrapperHeight);

	 //$("#txt_mdn").val("010-5295-7411");
	// $("#txt_businessName").val("사업명테스트");
	// $("#txt_builder").val("건설사테스트");
	// $("#txt_notidate").val("2021.11.30");
	// $("#sel_state").val("청약중");
	
	$("#txt_mdn").on("keyup", function(e){
		$("#txt_sendSmsMdn").val($("#txt_mdn").val());
		$("#txt_blockMdn").val($("#txt_mdn").val());
		fun_certReset();
		$("#txt_withoutMdn").val($("#txt_mdn").val());
	});

	// $("#txt_mdn").on("paste", function(e){
// 		var pasteObj = (event.clipboardData || window.clipboardData);
// //		console.log("전화번호들을 붙여넣기 했습니다", pasteObj.getData('text/html'));
// 		//console.log("전화번호들을 붙여넣기 했습니다", pasteObj.getData('text'));
		
// 		var texts = pasteObj.getData('text').split('\r\n');
// 		var table = $("#jdtListMember").DataTable();
// 		table.rows('.selected').nodes().to$().removeClass('selected');
// 		check_hasSel = true;
// 		var temp_alert = ""; 
// 		for(var i=0; i<texts.length; i++){
// 			if(texts[i]!=undefined){
// 				var mdn = texts[i].replaceAll("-", "");
// 				if(mdn!=""){
// 					mdn = mid(mdn, 0, 3) + "-" + mid(mdn, 3, 4) + "-" + mid(mdn, 7, 4);
// 					var patternTel = /^\d{2,3}-\d{3,4}-\d{4}$/;
// 					if(!patternTel.test(mdn)){
// 						$("#txt_mdn").focus();
// 						alert("전화번호 형식은 xxx-xxxx-xxxx입니다");
// 						return false;
// 					}
// 					var insertDatatable = true;
// 					for(var j=0; j<table.rows()[0].length; j++){
// 						var tableMdn = table.rows(j).data()[0].mdn;
// 						if(tableMdn == mdn){
// 							temp_alert += mdn + "\n";
// 							insertDatatable = false;
// 						}
// 					}
// 					if(insertDatatable){
// 						table.row.add({
// 							"<input type='checkbox' id='cbx_selectAll' onclick='fun_selectAllJdtListMember();'></input>": ""
// 							, "pro_yyyy":$("#sel_years option:selected").val()
// 							, "pro_mm":$("#sel_months option:selected").val()
// 							, "mdn": mdn
// 							, "tempEmpty":""
// 						}).draw();
// 					}
// 				}
// 			}
// 		}
// 		if(temp_alert!=""){
// 			alert(temp_alert + "동일한 전화번호가 있습니다\n테이블에 삽입되지 않았습니다");
// 		}
// 		setTimeout(function(){
// 			$("#txt_mdn").val("");
// 		}, 300);
// 	});
});

var allCommonCode = [];
function fun_selectServiceCode(callback){
	var inputData = {  };
	
	fun_ajaxPostSend("/survey/common/code.do", inputData, true, function(msg){
		if(msg!=null){
			var tempResult = JSON.parse(msg.result);
			allCommonCode = tempResult;
			callback();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}

var checkError = false;
var checkMember = false;
function fun_searchMdn(){
	var serviceCode = $("#sel_serviceCode").val();
	if(serviceCode==""){
		$("#sel_serviceCode").focus();
		alert("서비스 코드를 선택해주세요");
		return false;
	}
	
	var requsetMdn = $("#txt_mdn").val();
	if(requsetMdn==""){
		$("#txt_mdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}

	var password = "비밀번호 없음"; //$("#txt_adminPassword").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	// if(password==''||password==null){
	// 	$("#txt_adminPassword").focus();
	// 	alert('로그인 비밀번호를 입력해주세요');
	// 	return false;
	// }


	// if(confirm("검색한 후에는 서버에 해당 전화번호를 조회한 이력이 남습니다.\n해당 전화번호 대해 검색하시겠습니까?")){
		var encrypt = fun_encryptMdn(requsetMdn);
		
		var inputData = { "secMdn" : encrypt.mdn, "serviceCode": serviceCode, "password":shaPassword, "iv": encrypt.iv };
		
		fun_ajaxPostSend("/survey/select/member.do", inputData, true, function(msg){
			if(msg!=null){
				switch(msg.code){
					case "0000":
						var msgResult = msg.result;
						if(msgResult==null||msgResult==undefined||msgResult==""){
						}
						else{
							msgResult = JSON.parse(msgResult);
								// var regDate = new Date(msgResult.regDate);
								// var date = regDate.toISOString().substring(0, 19).replaceAll("T", " ");
							var table = $("#jdtListWithoutMember").DataTable();
							
							table.row.add({
								"<input type='checkbox' id='cbx_selectAll' onclick='fun_selectAllJdtListMember();'></input>": ""
								, "affiliateCode": msgResult.affiliateCode
								, "telecomCode": msgResult.telecomCode
								, "joinDttm": msgResult.joinDttm
								, "cancelDttm": "가입완료"
								, "cancelReason": ""
								, "surveySeq":msgResult.surveySeq
							}).draw();
							// $("#sel_serviceCode2").val(msgResult.serviceCode);
							// $("#sel_incomeCode").val(msgResult.incomeCode);
							
							// $("#txt_regDate").val(date);
							// $("#txt_adminPassword").val("");
							$("#txt_adminPassword").val("");
							checkMember = true;
						}
						break;
					case "0001":
						// $("#sel_serviceCode2").val("");
						// $("#sel_incomeCode").val("");
						// $("#txt_regDate").val("");
						// $("#txt_adminPassword").val("");
						// $("#sel_serviceCode").val("");
						// alert("검색 결과가 없습니다.");
						$("#txt_adminPassword").val("");
						checkError = false;
						break;
					case "0002":
						$("#txt_adminPassword").val("");
						checkMember = false;
						// alert("가입자가 아닙니다.");
						break;
					case "0003":
						checkMember = false;
						$("#txt_adminPassword").val("");
						alert("전화번호가 없습니다");
						break;
				}
				if(checkError){
					alert("오류가 발생하였습니다. 관리자에게 문의해주세요");
				}
				if(!checkMember){
				}
				setTimeout(function(){
					jdtListWithoutMember.order([4, 'desc']).draw();
				},100);
			}
			else{
				//alert('서비스가 일시적으로 원활하지 않습니다.');
			}
		});
	// }
}

//탈퇴한 회원들 불러오기
function fun_searchMdnWithoutMember(){
	var serviceCode = $("#sel_serviceCode").val();
	if(serviceCode==""){
		$("#sel_serviceCode").focus();
		alert("서비스 코드를 선택해주세요");
		return false;
	}
	
	var password = "비밀번호 없음"; //$("#txt_adminPassword").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	// if(password==''||password==null){
	// 	$("#txt_adminPassword").focus();
	// 	alert('로그인 비밀번호를 입력해주세요');
	// 	return false;
	// }
	
	var encrypt = fun_encryptMdn($("#txt_mdn").val());
	if(confirm("검색한 후에는 서버에 해당 전화번호를 조회한 이력이 남습니다.\n해당 전화번호 대해 검색하시겠습니까?")){
		fun_certReset();
		$("#txt_withoutMdn").val($("#txt_mdn").val());				
		var inputData = { "secMdn" : encrypt.mdn, "serviceCode": serviceCode, "password":shaPassword, "iv": encrypt.iv };
		
		fun_ajaxPostSend("/survey/select/without/member.do", inputData, true, function(msg){
			if(msg!=null){
				switch(msg.code){
					case "0000":
						var tempResult = JSON.parse(msg.result);
						if(tempResult.length!=0){
							fun_dataTableAddData("#jdtListWithoutMember", tempResult);

							// for(var i=0; i<tempResult.length;i++){
							// var table = $("#jdtListWithoutMember").DataTable();
							// 	table.row.add({
							// 		"<input type='checkbox' id='cbx_selectAll' onclick='fun_selectAllJdtListMember();'></input>": ""
							// 		, "serviceCode": msgResult.serviceCode
							// 		, "incomeCode": msgResult.incomeCode
							// 		, "regDate": msgResult.regDate
							// 		, "cancelDate": "가입완료"
							// 		, "cancelReason": ""
							// 	}).draw();
							// }
							checkMember = true;
						}
						break;
					case "0001":
						checkError = true;
						alert("오류가 발생하였습니다. 관리자에게 문의해주세요");
						return false;
						break;
				}
				fun_searchMdn();
			}
			else{
				//alert('서비스가 일시적으로 원활하지 않습니다.');
			}
		});
	}
}


function fun_resendCoupon(){
	$("#loading_resendCoupon").show();
	var url = encodeURI("/survey/" + $("#txt_surveyTargetId").val() + "/reSendCoupon.do"); 
	
	$.ajax({
        type: 'GET'
        , url: url
        , dataType: "json"
        , success: function (msg) {
            if(msg!=null){
				switch(msg.code){
					case "E000001":
						alert("쿠폰 재발행에 실패하였습니다.");	
						$("#loading_resendCoupon").show();
						break;
					case "S000001":
						fun_searchSurveyInterwork();
						var tempResult = JSON.parse(msg.result);
						$("#txt_couponResendCnt").val(tempResult.couponResendCnt);
						var regDate = tempResult.couponResendDttm;
						if(regDate==null || regDate ==""){ 
						}
						else{
							$("#txt_couponResendDttm").val(mid(regDate, 0, 4) + "-" + mid(regDate, 4, 2) + "-" + mid(regDate, 6, 2) + " " + mid(regDate, 8, 2) + ":" + mid(regDate, 10, 2) + ":" + mid(regDate, 12, 2));
						}
						$("#txt_couponResendReturnCode").val(tempResult.couponResendReturnCode);
						alert("쿠폰 재발행이 완료되었습니다.");
						$("#loading_resendCoupon").hide();
						break;
				}
					
			}
			else{
				//alert('서비스가 일시적으로 원활하지 않습니다.');
			}
			$("#btn_resendCoupon").prop('disabled', false);
        } // end success
        , error: function (xhr, status, error) {
			if(xhr.status==403){
				alert("세션이 만료되었습니다");
				location.href='/admin/loginView.do';
			}
			if(xhr.responseText=="E000001"){
				alert("쿠폰 재발행에 실패하였습니다.");
			}
			$("#loading_resendCoupon").hide();
        } // end error
    }); // end ajax
}

function fun_searchSurveyInterwork(){
	var serviceCode = $("#sel_serviceCode").val();
	if(serviceCode==""){
		$("#sel_serviceCode").focus();
		alert("서비스 코드를 선택해주세요");
		return false;
	}

	var requsetMdn = $("#txt_mdn").val();
	if(requsetMdn==""){
		$("#txt_mdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	
	var password = "비밀번호 없음"; //$("#txt_adminPassword").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	// if(password==''||password==null){
	// 	$("#txt_adminPassword").focus();
	// 	alert('로그인 비밀번호를 입력해주세요');
	// 	return false;
	// }


	$("#loading_jdtListInterWork").show();
	
	var startDate = $("#dtp_startDate").val().replaceAll("-", "") + "000000";
	var closeDate = $("#dtp_closeDate").val().replaceAll("-", "") + "235959";
	
	var inputData = { "startDttm":startDate, "closeDttm":closeDate }; //, "startDate":startDate, "closeDate":closeDate 
	
	fun_ajaxPostSend("/survey/select/interwork.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					if(tempResult.length!=0){
						var t = $("#jdtListInterWork").dataTable();
						t.fnClearTable();
						setTimeout(function(){
							fun_dataTableAddData("#jdtListInterWork", tempResult);
							$("#loading_jdtListInterWork").hide();
							$("#txt_adminPassword").val("");
						}, 100);
						setTimeout(function(){
							jdtListInterWork.order([1, 'desc']).draw();
						}, 100);
					}
					else{
						var t = $("#jdtListInterWork").dataTable();
						t.fnClearTable();
						$("#loading_jdtListInterWork").hide();
						alert("검색 결과가 없습니다.");
						$("#txt_adminPassword").val("");
					}
					break;
				case "0001":
					var t = $("#jdtListInterWork").dataTable();
					t.fnClearTable();
					$("#loading_jdtListInterWork").hide();
					alert("검색 결과가 없습니다.");
					$("#txt_adminPassword").val("");
					break;
			}
				
		}
		else{
			$("#loading_jdtListInterWork").show();
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}

function fun_insertAllBlockMdn(){
	var serviceCode = $("#sel_serviceCodeBlock").val();
	if(serviceCode==""){
		$("#sel_serviceCodeBlock").focus();
		alert("서비스 코드를 선택해주세요");
		return false;
	}

	var requsetMdn = $("#txt_blockMdn").val();
	if(requsetMdn==""){
		$("#txt_blockMdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	
	var password = "비밀번호 없음";//$("#txt_adminPasswordBlock").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	if(password==''||password==null){
		$("#txt_adminPasswordBlock").focus();
		alert('로그인 비밀번호를 입력해주세요');
		return false;
	}

	
	var encrypt = fun_encryptMdn(requsetMdn);
	
	var inputData = { "secMdn" : encrypt.mdn, "password":shaPassword, "iv": encrypt.iv };
	
	fun_ajaxPostSend("/management/insert/all/block.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					var alertMessage = "";
					if(tempResult.length!=0){
						
						for(var tempi=0;tempi<tempResult.length;tempi++){
							if(tempi==0){
								alertMessage += tempResult[tempi].serviceCode + "|" + tempResult[tempi].serviceName + "\n";
							}
							else{
								alertMessage += ", " + tempResult[tempi].serviceCode + "|" + tempResult[tempi].serviceName + "\n";
							}
						}
					}
					if(alertMessage!=""){
						alert("가입제한 설정이 완료되었습니다.\n(이제부터 전체 서비스에 가입 할 수 없습니다)\n이미 등록된 아래의 코드는 제외 하였습니다.\n" + alertMessage);
					}
					else{
						alert("가입제한 설정이 완료되었습니다.\n(이제부터 전체 서비스에 가입 할 수 없습니다)" + alertMessage);
					}
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
					break;
				case "0001":
					alert("오류가 발생 하였습니다.");
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
					break;
				case "0002":
					alert(serviceCode + "이미 설정된 고객입니다.");
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
					break;
				case "0003":
					alert("전화번호가 없습니다");
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
					break;
			}
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}

function fun_insertAllUnBlockMdn(){
	var serviceCode = $("#sel_serviceCodeBlock").val();
	if(serviceCode==""){
		$("#sel_serviceCodeBlock").focus();
		alert("서비스 코드를 선택해주세요");
		return false;
	}

	var requsetMdn = $("#txt_blockMdn").val();
	if(requsetMdn==""){
		$("#txt_blockMdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	
	var password = "비밀번호 없음";//$("#txt_adminPasswordBlock").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	if(password==''||password==null){
		$("#txt_adminPasswordBlock").focus();
		alert('로그인 비밀번호를 입력해주세요');
		return false;
	}
	
	var encrypt = fun_encryptMdn(requsetMdn);
	
	var inputData = { "secMdn" : encrypt.mdn, "serviceCode": serviceCode, "password":shaPassword, "iv": encrypt.iv };
	
	fun_ajaxPostSend("/management/delete/all/block.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					alert("해당고객의 가입제한이 해제되었습니다.");
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
					break;
				case "0001":
					alert("설정되어 있지 않은 사용자 입니다.");
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
					break;
				case "0003":
					alert("전화번호가 없습니다");
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
			}
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}

function fun_insertBlockMdn(){
	var serviceCode = $("#sel_serviceCodeBlock").val();
	if(serviceCode==""){
		$("#sel_serviceCodeBlock").focus();
		alert("서비스 코드를 선택해주세요");
		return false;
	}

	var requsetMdn = $("#txt_blockMdn").val();
	if(requsetMdn==""){
		$("#txt_blockMdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	
	var password = "비밀번호 없음";//$("#txt_adminPasswordBlock").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	if(password==''||password==null){
		$("#txt_adminPasswordBlock").focus();
		alert('로그인 비밀번호를 입력해주세요');
		return false;
	}

	
	var encrypt = fun_encryptMdn(requsetMdn);
	
	var inputData = { "secMdn" : encrypt.mdn, "serviceCode": serviceCode, "password":shaPassword, "iv": encrypt.iv };
	
	fun_ajaxPostSend("/management/insert/block.do", inputData, true, function(msg){
		if(msg!=null){
			var tempServiceCode = "";
			for(var i=0; i<allCommonCode.length; i++){
				if(allCommonCode[i].code == serviceCode){
					tempServiceCode = allCommonCode[i].code + "|" + allCommonCode[i].name; 
					break;
				}
			}
			switch(msg.code){
				case "0000":
					alert("가입제한 설정이 완료되었습니다.\n(이제부터 " + tempServiceCode + "은(는) 가입 할 수 없습니다)");
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
					break;
				case "0001":
					alert("오류가 발생 하였습니다.");
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
					break;
				case "0002":
					alert(tempServiceCode + "은(는) 이미 설정된 고객입니다.");
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
					break;
				case "0003":
					alert("전화번호가 없습니다");
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
					break;
			}
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}

function fun_insertUnBlockMdn(){
	var serviceCode = $("#sel_serviceCodeBlock").val();
	if(serviceCode==""){
		$("#sel_serviceCodeBlock").focus();
		alert("서비스 코드를 선택해주세요");
		return false;
	}

	var requsetMdn = $("#txt_blockMdn").val();
	if(requsetMdn==""){
		$("#txt_blockMdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	
	var password = "비밀번호 없음";//$("#txt_adminPasswordBlock").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	if(password==''||password==null){
		$("#txt_adminPasswordBlock").focus();
		alert('로그인 비밀번호를 입력해주세요');
		return false;
	}
	
	var encrypt = fun_encryptMdn(requsetMdn);
	
	var inputData = { "secMdn" : encrypt.mdn, "serviceCode": serviceCode, "password":shaPassword, "iv": encrypt.iv };
	
	fun_ajaxPostSend("/management/delete/block.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					alert("해당고객의 가입제한이 해제되었습니다.");
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
					break;
				case "0001":
					alert("설정되어 있지 않은 사용자 입니다.");
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
					break;
				case "0003":
					alert("전화번호가 없습니다");
					$("#txt_blockMdn").val("");
					$("#txt_adminPasswordBlock").val("");
			}
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}


function fun_requestSms(){
	var requsetMdn = $("#txt_withoutMdn").val();
	if(requsetMdn==""){
		$("#txt_withoutMdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	
	fun_timerStart();
	$("#loading_without").show();
	$("#txt_withoutMdn").prop("disabled", true);
	$('#btn_smsReq').prop('disabled', true);
	
	var encrypt = fun_encryptMdn(requsetMdn);
	
	//BLMCP의 model을 동일하게 사용하기 위하여 mdn을 부득이하게 MDN으로 설정함
	var inputData = { "secMdn" : encrypt.mdn, "iv": encrypt.iv };
	
	fun_ajaxPostSend("/survey/request/withoutSms.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					
					$("#txt_withoutSmsNum").prop("disabled", false);
					$("#txt_withoutSmsNum").focus();
					$("#txt_smsRandNum").empty();
					$("#txt_smsRandNum").append(tempResult);
					break;
				case "0001":
					fun_certReset();
					alert("로그인 비밀번호를 확인해주세요.");
					break;
				case "0003":
					fun_certReset();
					alert("전화번호가 없습니다");
			}
		}
		else{
			$('#btn_smsReq').prop('disabled', false);
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
		$("#loading_without").hide();
	});
}



function fun_requestCheckSms(){
	var requsetMdn = $("#txt_withoutMdn").val();
	if(requsetMdn==""){
		$("#txt_withoutMdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	
	var certNum = $("#txt_withoutSmsNum").val();
	if(certNum==""){
		$("#txt_withoutSmsNum").focus();
		alert("인증번호를 입력 해주세요");
		return false;
	}
	
	$('#btn_smsReq').prop('disabled', true);
	$("#loading_without").show();
	
	var encrypt = fun_encryptMdn(requsetMdn);
	
	//BLMCP의 model을 동일하게 사용하기 위하여 mdn을 부득이하게 MDN으로 설정함
	var inputData = { "secMdn" : encrypt.mdn, "certNumber":certNum, "iv": encrypt.iv };
	
	fun_ajaxPostSend("/survey/request/checkWithoutSms.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					fun_timerEnd();
					$("#txt_smsReq").empty();
					$("#txt_smsReq").append("일치");
					
					$("#txt_cancelReason").prop("disabled", false);
					$("#btn_without").prop("disabled", false);
					break;
				case "0001":
					fun_certReset();
					alert("로그인 비밀번호를 확인해주세요.");
					break;
				case "0003":
					fun_certReset();
					alert("전화번호가 없습니다");
					break;
				case "0906":
					fun_certReset();
					alert("인증번호가 3회 불일치 되었습니다. 인증요청 버튼을 다시 눌러주세요.");
					break;
				case "0907":
					alert("입력하신 인증번호가 올바르지 않습니다.");
					$("#btn_without").prop("disabled", true);
					break;
				case "0908":
					fun_certReset();
					alert("입력시간이 초과되었습니다. 인증요청 버튼을 다시 눌러주세요.");
					break;
			}
		}
		else{
			fun_certReset();
			alert('서비스가 일시적으로 원활하지 않습니다.');
		}
		$("#loading_without").hide();
	});
}


function fun_requestWithoutMdn(){
	var requsetMdn = $("#txt_withoutMdn").val();
	if(requsetMdn==""){
		$("#txt_withoutMdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	
	var certNum = $("#txt_withoutSmsNum").val();
	if(certNum==""){
		$("#txt_withoutSmsNum").focus();
		alert("인증번호를 입력 해주세요");
		return false;
	}

	var cancelReason = $("#txt_cancelReason").val();
	
	$("#loading_without").show();
	
	var encrypt = fun_encryptMdn(requsetMdn);
	
	var inputData = { "secMdn" : encrypt.mdn, "cancelReason" : cancelReason, "certNumber":certNum, "iv": encrypt.iv };
	
	fun_ajaxPostSend("/survey/request/withoutMdn.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					fun_certReset();
					alert("설문조사레터 해지가 완료되었습니다.");
					break;
				case "0001":
					fun_certReset();
					alert("로그인 비밀번호를 확인해주세요.");
					break;
				case "0003":
					fun_certReset();
					alert("전화번호가 없습니다");
					break;
			}
		}
		else{
			fun_certReset();
			alert('서비스가 일시적으로 원활하지 않습니다.');
		}
		$("#loading_without").hide();
	});
}



function fun_sendSms(){
	var serviceCode = $("#sel_serviceCodeSendSms").val();
	if(serviceCode==""){
		$("#sel_serviceCodeSendSms").focus();
		alert("서비스 코드를 선택해주세요");
		return false;
	}
	
	var requestMsgType = $("#sel_msgType").val();
	if(requestMsgType==""){
		$("#sel_msgType").focus();
		alert("문자형태를 선택해주세요");
		return false;
	}

	var requsetMdn = $("#txt_sendSmsMdn").val();
	if(requsetMdn==""){
		$("#txt_sendSmsMdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	
	var requsetTitle = $("#txt_sendTitle").val();
	if(requsetTitle==""){
		$("#txt_sendTitle").focus();
		alert("제목을 입력 해주세요");
		return false;
	}
	
	var requsetMsg = $("#txt_sendSmsMsg").val();
	if(requsetMsg==""){
		$("#txt_sendSmsMsg").focus();
		alert("내용을 입력 해주세요");
		return false;
	}
	
	var requsetCallbackMdn = $("#txt_callbackMdn").val();
	if(requsetCallbackMdn==""){
		$("#txt_callbackMdn").focus();
		alert("회신받을 전화번호를 입력 해주세요");
		return false;
	}
	
	
	var password = "비밀번호 없음";//$("#txt_adminPasswordSendSms").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	if(password==''||password==null){
		$("#txt_adminPasswordSendSms").focus();
		alert('로그인 비밀번호를 입력해주세요');
		return false;
	}
	
	var encrypt = fun_encryptMdn(requsetMdn);
	
	var inputData = { 
			"secMdn" : encrypt.mdn
			, "serviceCode": serviceCode
			, "password":shaPassword
			, "iv": encrypt.iv
			, "msgType" : requestMsgType
			, "title" : requsetTitle
			, "msg": requsetMsg
			, "callbackMdn" : requsetCallbackMdn
			};
	
	fun_ajaxPostSend("/management/send/sms.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					alert("문자발송이 완료되었습니다.");
					$("#txt_sendSmsMdn").val("");
					$("#txt_adminPasswordSendSms").val("");
					break;
				case "0001":
					alert("오류가 발생 하였습니다.");
					$("#txt_sendSmsMdn").val("");
					$("#txt_adminPasswordSendSms").val("");
					break;
				case "0003":
					alert("전화번호가 없습니다");
					$("#txt_sendSmsMdn").val("");
					$("#txt_adminPasswordSendSms").val("");
			}
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}



function fun_initializeClickEvent(){
	$("#dtp_startDate, #dtp_closeDate").datepicker({
		format: "yyyy-mm-dd"
		, language: "kr"
		, autoclose: "true"
	});
	
	$("#txt_withoutSmsNum").on("keyup", function(e){
		var certNum = $("#txt_withoutSmsNum").val();
		if(certNum.length==4){
			fun_requestCheckSms();
		}	
	});
	
	var tempToday = new Date();
	var tempYears = tempToday.toISOString().substring(0, 4);
	var tempCloseYears = tempToday.toISOString().substring(0, 4);
	var tempMonth = tempToday.getMonth() - 1;
	//이전 달을 불러와야 함
	switch(tempMonth){
	case 0:
		tempYears = parseInt(tempYears) - 1;
		tempMonth = "12";

		break;
	case 11:
		tempMonth = tempMonth.toString();
	case 10:
		tempMonth = "09";
		break;
	default:
		tempMonth = + "0";
	}
	
	var tempCloseMonth = tempToday.getMonth();
	//이전 달을 불러와야 함
	switch(tempCloseMonth){
	case 0:
		tempCloseMonth = "12";
		break;
	case 11:
		tempCloseMonth = tempCloseMonth.toString();
	case 10:
		tempCloseMonth = "09";
		break;
	default:
		tempCloseMonth = + "0" + tempCloseMonth.toString();
	}

	var tempStartDate = new Date(mid(tempYears.toString(), 0, 4), tempMonth, 1, 0, 0, 0, 0);
	$("#dtp_startDate").datepicker( "setDate", tempStartDate );

	var tempCloseDate = new Date(mid(tempCloseYears.toString(), 0, 4), tempCloseMonth, 31, 0, 0, 0, 0);
	$("#dtp_closeDate").datepicker( "setDate", tempCloseDate );
	

	$("#txt_mdn").mask("999-9999-9999", {'translation': {0: {pattern: /[0-9*]/}}});
	$("#txt_blockMdn").mask("999-9999-9999", {'translation': {0: {pattern: /[0-9*]/}}});
	$("#txt_withoutMdn").mask("999-9999-9999", {'translation': {0: {pattern: /[0-9*]/}}});
	$("#txt_sendSmsMdn").mask("999-9999-9999", {'translation': {0: {pattern: /[0-9*]/}}});
	$("#txt_withoutSmsNum").mask("9999", {'translation': {0: {pattern: /[0-9*]/}}});
	

	$('#jdtListWithoutMember').delegate('tr', 'click', function () {
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
				
				var t = $("#jdtListMember").dataTable();
				t.fnClearTable();
				setTimeout(function () {
					t.fnAdjustColumnSizing();
				}, 200);
				
				fun_changeAfterinit();
			} else {
				$("#jdtListWithoutMember tbody tr").removeClass('selected');
				$("#cbx_selectAll").attr('checked', false);         // 전체선택 체크 해제
				$("input[name='chk-row']").prop('checked', false);  // 선택 줄 외 체크 해제
				$(this).toggleClass('selected');
				this.children[0].lastChild.checked = true;
				//$(this)[0].children(0).lastChild.checked = true;
				
				fun_clickjdtListWithoutMember();   // 선택한 줄 값 라인에 입력
			}
		}
		
		
		
		/* var table = $("#jdtListWithoutMember").DataTable();
		var row = table.rows('.selected').data()[0];
		table.rows('.selected').nodes().to$().removeClass('selected');
			
		$(this).toggleClass('selected');
		
		// 클릭 시 실행 함수
		fun_clickjdtListWithoutMember(); */
	});

	//=== IE 이외 브라우저 구동을 위한 교체
	$('#jdtListInterWork').delegate('tr', 'click', function () {
		// 빈테이블이 아닐때
		if (this.innerText != "데이터가 없습니다.") {
			var chk = $(this).hasClass('selected');
			if (chk) {
				$(this).removeClass('selected');
				this.children[0].lastChild.checked = false;
				//$(this)[0].children(0).lastChild.checked = false;
				fun_changeAfterinit();
			} else {
				$("#jdtListInterWork tbody tr").removeClass('selected');
				$("#cbx_selectMmsAll").attr('checked', false);         // 전체선택 체크 해제
				$("input[name='chk-rowMms']").prop('checked', false);  // 선택 줄 외 체크 해제
				$(this).addClass('selected');
				
				this.children[0].lastChild.checked = true;
				//$(this)[0].children(0).lastChild.checked = true;
				fun_setjdtListInterWorkToTextbox();   // 선택한 줄 값 라인에 입력
			}
		}
	});

	//테이블 검색시
	$("#txt_searchParcelInfo").on('keyup click', function () {
		$("#jdtListWithoutMember").DataTable().search(
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
		var oTable = $("#jdtListMember").DataTable();
		var t = $("#jdtListMember").dataTable();
		
		var chk = $("#cbx_selectAll").is(':checked');
		if (chk) {
			t.fnClearTable();                               // 전체 선택 시 테이블 클리어
		} else {
			oTable.row('.selected').remove().draw(false);   // 해당 클래스의 줄 삭제
		}
		
		check_hasSel = true;
		$("#cbx_selectAll").attr('checked', false);             // 전체선택 체크 해제
		fun_changeAfterinit();                          // 라인 입력값 삭제
	});
}

//=== jdt_List Setting
function fun_setjdtListInterWork() {
	jdtListInterWork = $("#jdtListInterWork").DataTable({
		"columns": [
			{ 
				"title": "<input type='checkbox' id='cbx_selectMmsAll' onclick='fun_selectAlljdtListInterWork();'></input>"
				,"data": null
				, "defaultContent": "<input type='checkbox' name='chk-rowMms'></input>"
				, "sortable": false
			}   
			, { "title": "일련번호", "data": "surveySeq"}
			, { "title": "제목", "data": "serveyTitle"}
			, { "title": "시작일시", "data": "startDttm"}
			, { "title": "종료일시", "data": "closeDttm"}
			, { "title": "고객제한수", "data": "limitTargetCnt"}
			, { "title": "쿠폰코드", "data":"couponCode"}
			, { "title": "쿠폰가격", "data":"couponPrice"}
			, { "title": "쿠폰마감일", "data":"couponLimitDay"}
			, { "title": "쿠폰할인율", "data":"couponDiscountRate"}
			, { "title": "오픈여부", "data":"openYn"}
			, { "title": "요청URL", "data":"requestUrl"}
			, { "title": "설명", "data":"description"}
			, { "title": "문항개수", "data":"surveyQuestionCount"}
			, { "title": "설문전 체크", "data":"preValidationYn"}
			, { "title": "설문전 문항", "data":"preValidationComment"}
			, { "title": "설문연동건수", "data":"interwork"}
			, { "title": "설문완료건수", "data":"doneInterwork"}
			, { "title": "쿠폰연동건수", "data":"interworkCoupon"}
			, { "title": "쿠폰발행건수", "data":"doneInterworkCoupon"}
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
			  { "targets": [0], "class": "dt-head-center dt-body-left dtPercent1" }
			, { "targets": [1], "class": "dt-head-center dt-body-left dtPercent5" }
			, { "targets": [2], "class": "dt-head-center dt-body-left dtPercent10" }
			, { "targets": [3], "class": "dt-head-center dt-body-left dtPercent9"
				, "render": function (data, type, row) {
					var regDate = row.startDttm;
					regDate = mid(regDate, 0, 4) + "-" + mid(regDate, 4, 2) + "-" + mid(regDate, 6, 2) + " " + mid(regDate, 8, 2) + ":" + mid(regDate, 10, 2) + ":" + mid(regDate, 12, 2);
					return regDate;
                }
			}
			, { "targets": [4], "class": "dt-head-center dt-body-left dtPercent9"
				, "render": function (data, type, row) {
					var regDate = row.closeDttm;
					regDate = mid(regDate, 0, 4) + "-" + mid(regDate, 4, 2) + "-" + mid(regDate, 6, 2) + " " + mid(regDate, 8, 2) + ":" + mid(regDate, 10, 2) + ":" + mid(regDate, 12, 2);
					return regDate;
                }
			}
			, { "targets": [5], "class": "dt-head-center dt-body-left dtPercent5" 
				, "render": function (data, type, row) {
					var result = row.limitTargetCnt;
					return addCommas(result);
				}
			}
			, { "targets": [6], "class": "hideColumn" }
			, { "targets": [7], "class": "hideColumn" }
			, { "targets": [8], "class": "hideColumn" }
			, { "targets": [9], "class": "hideColumn" }
			, { "targets": [10], "class": "dt-head-center dt-body-left dtPercent4" }
			, { "targets": [11], "class": "hideColumn" }
			, { "targets": [12], "class": "hideColumn" }
			, { "targets": [13], "class": "hideColumn" }
			, { "targets": [14], "class": "hideColumn" }
			, { "targets": [15], "class": "hideColumn" }
			, { "targets": [16], "class": "dt-head-center dt-body-left dtPercent10" 
				, "render": function (data, type, row) {
					var result = row.interwork;
					return addCommas(result);
				}
			}
			, { "targets": [17], "class": "dt-head-center dt-body-left dtPercent10" 
				, "render": function (data, type, row) {
					var result = row.doneInterwork;
					return addCommas(result);
                }
			}
			, { "targets": [18], "class": "dt-head-center dt-body-left dtPercent10" 
				, "render": function (data, type, row) {
					var result = row.interworkCoupon;
					return addCommas(result);
                }
			}
			, { "targets": [19], "class": "dt-head-center dt-body-left dtPercent10" 
				, "render": function (data, type, row) {
					var result = row.doneInterworkCoupon;
					return addCommas(result);
                }
			}
			
		]
	});

};
//==================================JQuery DataTable Setting 끝==================================


//=== 수정 버튼 이벤트
function fun_clickButtonModifyLine() {
	if (fun_checkValidation()) {
		var table = $("#jdtListMember").DataTable();
		var row = table.rows('.selected');          // 선택된 로우
		var idx = table.row('.selected').index();   // 선택된 로우의 인덱스값
		var t = $("#jdtListMember").dataTable();

		if (row == undefined) {
			alert('라인 수정 상태가 아닙니다.');
		} else {
			t.fnUpdate({
				"<input type='checkbox' id='cbx_selectAll' onclick='fun_selectAllJdtListMember();'></input>": ""
				, "pro_yyyy":$("#sel_years option:selected").val()
				, "pro_mm":$("#sel_months option:selected").val()
				, "mdn": $("#txt_mdn").val()
				, "tempEmpty":""
			}, idx);        // 해당 인덱스값의 로우 데이터 업데이트

			// 수정 후 초기화
			fun_changeAfterinit();

			// 수정 후 라인 선택 해제
			//row.removeClass('selected');
			row.nodes().to$().removeClass('selected');
			check_hasSel = true;
		}
	} else {
		return;
	}
	return false;
};

function fun_setjdtListInterWorkToTextbox() {
	var table = $("#jdtListInterWork").DataTable();
	var selRow = table.rows('.selected').data()[0];

	if (selRow != undefined) {
		$("#txt_surveySeq").val(selRow.surveySeq);
		for(var i=0; i<allCommonCode.length; i++){
			if(allCommonCode[i].codeGroup == "telecom_code"){
				if(allCommonCode[i].codeValue == selRow.affiliateCode){
					$("#txt_telecomCode").val(allCommonCode[i].codeValue + " | " + allCommonCode[i].codeName); 
					break;
				}
			}
		}
		
		$("#txt_affiliateCode").val(selRow.affiliateCode);
		for(var i=0; i<allCommonCode.length; i++){
			if(allCommonCode[i].codeGroup == "telecom_code"){
				if(allCommonCode[i].codeValue == selRow.telecomCode){
					
					$("#txt_telecomCode").val(tempServiceCode = allCommonCode[i].codeValue + " | " + allCommonCode[i].codeName); 
					break;
				}
			}
		}
		// $("#txt_affiliateCode").val(selRow.affiliateCode);
		// $("#txt_telecomCode").val(selRow.telecomCode);
		$("#txt_certNumber").val(selRow.certNumber);
		var regDate = selRow.certDttm;
		if(regDate==null || regDate ==""){ 
		}
		else{
			$("#txt_certDttm").val(mid(regDate, 0, 4) + "-" + mid(regDate, 4, 2) + "-" + mid(regDate, 6, 2) + " " + mid(regDate, 8, 2) + ":" + mid(regDate, 10, 2) + ":" + mid(regDate, 12, 2));
		}
		
		// $("#txt_certDttm").val(regDate);
		$("#txt_certCount").val(selRow.certCount);
		$("#txt_certRequestCount").val(selRow.certRequestCount);
		$("#txt_surveyTargetStatus").val(selRow.surveyTargetStatus);
		$("#txt_surveyTargetId").val(selRow.surveyTargetId);
		$("#txt_couponStatus").val(selRow.couponStatus);
		$("#txt_couponReturnCode").val(selRow.couponReturnCode);
		$("#txt_couponNumber").val(selRow.couponNumber);

		var regDate = selRow.couponReturnDttm;
		if(regDate==null || regDate ==""){ 
		}
		else{
			$("#txt_couponReturnDttm").val(mid(regDate, 0, 4) + "-" + mid(regDate, 4, 2) + "-" + mid(regDate, 6, 2) + " " + mid(regDate, 8, 2) + ":" + mid(regDate, 10, 2) + ":" + mid(regDate, 12, 2));
		}

		// $("#txt_couponReturnDttm").val(selRow.couponReturnDttm);

		var regDate = selRow.surveyTargetStatusDttm;
		if(regDate==null || regDate ==""){ 
		}
		else{
			$("#txt_surveyTargetStatusDttm").val(mid(regDate, 0, 4) + "-" + mid(regDate, 4, 2) + "-" + mid(regDate, 6, 2) + " " + mid(regDate, 8, 2) + ":" + mid(regDate, 10, 2) + ":" + mid(regDate, 12, 2));
		}
		//$("#txt_surveyTargetStatusDttm").val(selRow.surveyTargetStatusDttm);
		$("#txt_couponResendCnt").val(selRow.couponResendCnt);
		
		var regDate = selRow.couponResendDttm;
		if(regDate==null || regDate ==""){ 
		}
		else{
			$("#txt_couponResendDttm").val(mid(regDate, 0, 4) + "-" + mid(regDate, 4, 2) + "-" + mid(regDate, 6, 2) + " " + mid(regDate, 8, 2) + ":" + mid(regDate, 10, 2) + ":" + mid(regDate, 12, 2));
		}
		// $("#txt_couponResendDttm").val(selRow.couponResendDttm);
		$("#txt_couponResendReturnCode").val(selRow.couponResendReturnCode);




		$("#mdl_coupon").modal({"show":true});
	} else {
		$("#txt_affiliateCode").val("");
		$("#txt_telecomCode").val("");
		$("#txt_certNumber").val("");
		$("#txt_certDttm").val("");
		$("#txt_certCount").val("");
		$("#txt_certRequestCount").val("");
		$("#txt_surveyTargetStatus").val("");
		$("#txt_surveyTargetId").val("");
		$("#txt_couponStatus").val("");
		$("#txt_couponReturnCode").val("");
		$("#txt_couponNumber").val("");
		$("#txt_couponReturnDttm").val("");
		$("#txt_surveyTargetStatusDttm").val("");
		$("#txt_couponResendCnt").val("");
		$("#txt_couponResendDttm").val("");
		$("#txt_couponResendReturnCode").val("");
		//table.rows('.selected').removeClass('selected');
		table.rows('.selected').nodes().to$().removeClass('selected');
	}
	
};


//=== 추가 버튼 이벤트
function fun_clickButtonAddLine() {
	if (fun_checkValidation()) {
		var table = $("#jdtListMember").DataTable();
		
		// 라인 선택 해제
		//row.removeClass('selected');
		table.rows('.selected').nodes().to$().removeClass('selected');
		check_hasSel = true;
		var temp_alert = ""; 
		var insertDatatable = true;
		var mdn = $("#txt_mdn").val();
		for(var j=0; j<table.rows()[0].length; j++){
			var tableMdn = table.rows(j).data()[0].mdn;
			if(tableMdn == mdn){
				temp_alert += mdn + "\n";
				insertDatatable = false;
			}
		}
		if(insertDatatable){
			table.row.add({
				"<input type='checkbox' id='cbx_selectAll' onclick='fun_selectAllJdtListMember();'></input>": ""
				, "pro_yyyy":$("#sel_years option:selected").val()
				, "pro_mm":$("#sel_months option:selected").val()
				, "mdn": mdn
				, "tempEmpty":""
			}).draw();
		}
		if(temp_alert!=""){
			alert(temp_alert + "동일한 전화번호가 있습니다\n테이블에 삽입되지 않았습니다");
		}
		// 수정 후 초기화
		fun_changeAfterinit();
	} 
	else {
		return;
	}
	return false;
};


function fun_validationSaveChk(){
	chk = 0;
	alert_temp = "";
	
	if($("#hdf_memberId").val()==""){
		if (confirm('고객정보가 없습니다\n추가하시겠습니까?')) {
			setTimeout(function () {
				$("#btn_memberCode").trigger('click');
			}, 800);
		}
		return false;
	}
	
	
	var table = $("#jdtListMember").DataTable();
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

function fun_checkValidation(){
	var mdn =$("#txt_mdn").val(); 
	if(mdn==""){
		$("#txt_mdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	else{
		var patternTel = /^\d{2,3}-\d{3,4}-\d{4}$/;
		if(!patternTel.test(mdn)){
			$("#txt_mdn").focus();
			alert("전화번호 형식은 xxx-xxxx-xxxx입니다");
			return false;
		}
	}
	
	return true;
}


//=== 추가/수정 이후 히든값 및 텍스트 초기화
function fun_changeAfterinit() {
	$("#txt_preViewMmsTitle").val('');
	$("#txt_preViewMms").val('');
};	


//=== 전체선택 체크시 이벤트
function fun_selectAlljdtListInterWork() {
	var cbx_selectAll = $("#cbx_selectMmsAll").is(':checked');             // 전체선택 체크시 true
	var tr = $("#jdtListInterWork tbody tr");

	if (tr[0].innerText != "데이터가 없습니다.") {                              // Row에 추가된 값이 있을시
		if (cbx_selectAll) {
			//$("#Content_jdt_ListMain tbody tr").addClass('selected');           // 클래스 추가
			$("input[name='chk-rowMms']").prop('checked', true);
			$("#jdtListInterWork tbody tr").removeClass('selected');            // .selected 클래스 제거
		} else {
			//$("#Content_jdt_ListMain tbody tr").removeClass('selected');        // 클래스 삭제
			$("input[name='chk-rowMms']").prop('checked', false);
			$("#jdtListInterWork tbody tr").removeClass('selected');            // .selected 클래스 제거
		}
		fun_changeAfterinit();

	} else {                                                                    // Row에 추가된 값이 없을시
		$("#cbx_selectMmsAll").attr('checked', false);                     // 전체선택 체크 해제
	}
};




function fun_validationSaveChk(){
	var chk = 0;
	var alert_temp = "";
	
	var table = $("#jdtListMember").DataTable();
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


function byteArrayToWordArray(ba) {
	var wa = [],
		i;
	for (i = 0; i < ba.length; i++) {
		wa[(i / 4) | 0] |= ba[i] << (24 - 8 * i);
	}

	return CryptoJS.lib.WordArray.create(wa, ba.length);
}

function wordArrayToByteArray(wordArray, length) {
	if (wordArray.hasOwnProperty("sigBytes") && wordArray.hasOwnProperty("words")) {
		length = wordArray.sigBytes;
		wordArray = wordArray.words;
	}

	var result = [],
		bytes,
		i = 0;
	while (length > 0) {
		bytes = wordToByteArray(wordArray[i], Math.min(4, length));
		length -= bytes.length;
		result.push(bytes);
		i++;
	}
	return [].concat.apply([], result);
}

function wordToByteArray(word, length) {
	var ba = [],
		i,
		xFF = 0xFF;
	if (length > 0)
		ba.push(word >>> 24);
	if (length > 1)
		ba.push((word >>> 16) & xFF);
	if (length > 2)
		ba.push((word >>> 8) & xFF);
	if (length > 3)
		ba.push(word & xFF);

	return ba;
}

function hex2a(hex) {
    var str = '';
    for (var i = 0; i < hex.length; i += 2)
        str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
    return str;
}


function fun_outputExcel(){
	location.href = "/realestate/event/promotion.do?startDate=" + $("#dtp_startDate").val() + "&closeDate=" + $("#dtp_closeDate").val();
}

function fun_timeSet() {
	totalAmount--;
	
	if (totalAmount < 0) {
		totalAmount = 0;
		clearTimeout(timeloop);
		alert('입력시간이 초과되었습니다. 인증요청 버튼을 다시 눌러주세요.');
		$("#btn_smsReq").empty();
		$("#btn_smsReq").append("재발송");  // 재발송 버튼 표시
		$("#btn_without").prop("disabled", true);
		$('#btn_smsReq').prop('disabled', false);
		return;
	}

	else if (totalAmount < 150){
		$('#btn_smsReq').prop('disabled', false);
	}
	var minutes = parseInt(totalAmount / 60);
	var seconds = parseInt(totalAmount % 60);
	
	if(seconds < 10){
		seconds = "0" + seconds;
	}
	$('#txt_smsReq').empty();
	$('#txt_smsReq').append("0" + minutes + ":" + seconds);
	
	timeloop = setTimeout(fun_timeSet, 1000);
}

function fun_timerStart() {
	var reqVal = "3";
	var parAmt = parseInt(reqVal);
	
	if (timeloop) {
		clearTimeout(timeloop)
	}
	
	totalAmount = parAmt * 60;
	
	fun_timeSet();
}

function fun_timerEnd() {
	totalAmount = 0;
	clearTimeout(timeloop);
}

function fun_certReset() {
	fun_timerEnd();
	certId="";
	certToken="";
	$("#txt_withoutMdn").prop("disabled", false);
	$("#txt_withoutMdn").val("");
	$("#txt_withoutSmsNum").val("");
	$("#txt_adminPasswordWithout").val("");
	$("#txt_smsReq").empty();
	$("#btn_smsReq").empty();
	$("#txt_smsRandNum").empty();
	$("#btn_smsReq").append("인증요청");
	$("#btn_smsReq").prop("disabled", false);
	$("#btn_without").prop("disabled", true);
	$("#txt_withoutSmsNum").prop("disabled", true);
}


//todo

</script>

<script type="text/javascript">





function fun_requestWithoutMdn(){
	var requsetMdn = $("#txt_withoutMdn").val();
	if(requsetMdn==""){
		$("#txt_withoutMdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	
	var certNum = $("#txt_withoutSmsNum").val();
	if(certNum==""){
		$("#txt_withoutSmsNum").focus();
		alert("인증번호를 입력 해주세요");
		return false;
	}

	var cancelReason = $("#txt_cancelReason").val();
	
	$("#loading_without").show();
	
	var encrypt = fun_encryptMdn(requsetMdn);
	
	var inputData = { "secMdn" : encrypt.mdn, "cancelReason" : cancelReason, "certNumber":certNum, "iv": encrypt.iv };
	
	fun_ajaxPostSend("/survey/request/withoutMdn.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					fun_certReset();
					alert("설문조사레터 해지가 완료되었습니다.");
					break;
				case "0001":
					fun_certReset();
					alert("로그인 비밀번호를 확인해주세요.");
					break;
				case "0003":
					fun_certReset();
					alert("전화번호가 없습니다");
					break;
			}
		}
		else{
			fun_certReset();
			alert('서비스가 일시적으로 원활하지 않습니다.');
		}
		$("#loading_without").hide();
	});
}
</script>

<form id="customer" method="post" onsubmit="return false;">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header" style="font-size:24px">연동현황조회</h1>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	
	<div class="space-6"></div>
	

	<div class="row" id="div_row3">
        <div class="col-lg-12">
            <div id="accordion3" class="accordion-style1 panel-group accordion-style2">
                <div class="panel panel-default" id="tog_Head">
                    <div class="panel-heading clearfix" style="font-size:16px">
                        <span class="toggle_accordion">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse3" >
				    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
				    &nbsp;목록
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                            <input type="button" id="btn_selectMms" onclick="fun_searchSurveyInterwork();" class="btn btn-info btn-sm" value="조회" />
                        </span>
                    </div>
                    <div id="collapse3" class="panel-collapse collapse in">
                        <div class="panel-body">
							<div class="row" id="">
								<div class="col-lg-12">
									<div class="col-lg-1" style="padding-top:10px">
										시작일자 : 
									</div>
									<div class="col-lg-2">
										<div class="input-group">
											<input type="text" id="dtp_startDate" class="form-control" autocomplete="no">
											<span class="input-group-addon">
												<i class="fa fa-calendar"></i>
											</span>
										</div>
									</div>
									<div class="col-lg-1" style="padding-top:10px">
										종료일자 : 
									</div>
									<div class="col-lg-2">
										<div class="input-group">
											<input type="text" id="dtp_closeDate" class="form-control" autocomplete="no">
											<span class="input-group-addon">
												<i class="fa fa-calendar"></i>
											</span>
										</div>
									</div>
									<div class="col-lg-1">
									</div>
								</div>
							</div>
							<div class="space-4"></div>
							<div id="loading_jdtListInterWork" class="loadingDataTable" style="display:none;">
								<img src="../assets/img/loading.gif" alt="loading">
							</div>
                            <div class="dataTable_wrapper" id="dataTable_wrapper1">
                                <table id="jdtListInterWork" class="table table-striped table-bordered table-hover">
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

</form>
