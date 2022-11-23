<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="../assets/js/cryptoJs/aes.js"></script>
<script>

var jdtListWithoutMember;
var jdtListMms;
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
		$('#jdtListWithoutMember').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
		var dataTableWrapperHeight = $("#dataTable_wrapper1").height();
		$("#loading_jdtListMms").height(dataTableWrapperHeight);
		//$('#jdtListMember').dataTable().fnAdjustColumnSizing();
	});

	$('.panel').on('shown.bs.collapse', function (e) {
		$('#jdtListWithoutMember').dataTable().fnAdjustColumnSizing();
		var dataTableWrapperHeight = $("#dataTable_wrapper1").height();
		$("#loading_jdtListMms").height(dataTableWrapperHeight);
		//$('#jdtListMember').dataTable().fnAdjustColumnSizing();
	});

	fun_initializeClickEvent();

	fun_setJdtListMember();

	fun_setJdtListMms();
	
	var dataTableWrapperHeight = $("#dataTable_wrapper1").height();
	$("#loading_jdtListMms").height(dataTableWrapperHeight);

	// $("#sel_mdn").val("서울");
	// $("#txt_businessName").val("사업명테스트");
	// $("#txt_builder").val("건설사테스트");
	// $("#txt_notidate").val("2021.11.30");
	// $("#sel_state").val("청약중");
	
	$("#txt_mdn").on("keyup", function(e){
		$("#txt_sendSmsMdn").val($("#txt_mdn").val());
		$("#txt_blockMdn").val($("#txt_mdn").val());
		fun_certReset();
		$("#txt_withoutMdn").val($("#txt_mdn").val());
		$("#txt_withoutMdnOfFreefortune").val($("#txt_mdn").val());
	});

	$("#txt_withoutMdn").on("keyup", function(e){
		$("#txt_sendSmsMdn").val($("#txt_withoutMdn").val());
		$("#txt_blockMdn").val($("#txt_withoutMdn").val());
		$("#txt_mdn").val($("#txt_withoutMdn").val());
		$("#txt_withoutMdnOfFreefortune").val($("#txt_withoutMdn").val());	
	});

	$("#txt_withoutMdnOfFreefortune").on("keyup", function(e){
		$("#txt_sendSmsMdn").val($("#txt_withoutMdnOfFreefortune").val());
		$("#txt_blockMdn").val($("#txt_withoutMdnOfFreefortune").val());
		fun_certReset();
		$("#txt_mdn").val($("#txt_withoutMdnOfFreefortune").val());
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

var allServiceCode = [];
function fun_selectServiceCode(callback){
	var inputData = {  };
	if(parentsProgramPageNumber == "60000000"){		//CS(고객센터)에서는 부동산레터 코드만 오픈되면 됨
		$('#sel_serviceCode').prop("disabled", true);
		if(myProgramPageNumber == "60000001"){
			$("#h1_title").empty();
			$("#h1_title").append("부동산레터");
			$("#btn_withoutToMdlOfFreefortune").hide();
			$("#div_row3").show();	
			setTimeout(function(){
				$("#jdtListMms").dataTable().fnAdjustColumnSizing();
			}, 600);
		}
		else if(myProgramPageNumber == "60000003"){
			$("#h1_title").empty();
			$("#h1_title").append("운세레터");
			$("#btn_withoutToMdl").hide();
		}
	}
	else{
		$("#btn_blockToMdl").show();
		$('#sel_serviceCode').prop("disabled", false);
		//$('#sel_serviceCodeBlock').prop("disabled", false);
		//$('#sel_serviceCodeWithout').prop("disabled", false);
		$('#sel_serviceCodeSendSms').prop("disabled", false);
	}


	fun_ajaxPostSend("/management/select/serviceCode.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					$('#sel_serviceCode').append($('<option></option>').val("").html("---선택---"));
					//$('#sel_serviceCode2').append($('<option></option>').val("").html("------"));
					
					$.each(tempResult, function (key, value) {
						$('#sel_serviceCode').append($('<option></option>').val(value.serviceCode).html(value.serviceCode + " | " + value.serviceName));
						$('#sel_serviceCodeBlock').append($('<option></option>').val(value.serviceCode).html(value.serviceCode + " | " + value.serviceName));
						$('#sel_serviceCodeWithout').append($('<option></option>').val(value.serviceCode).html(value.serviceCode + " | " + value.serviceName));
						$('#sel_serviceCodeSendSms').append($('<option></option>').val(value.serviceCode).html(value.serviceCode + " | " + value.serviceName));
						//$('#sel_serviceCode2').append($('<option></option>').val(value.serviceCode).html(value.serviceCode + " | " + value.serviceName));
						allServiceCode.push({"code": value.serviceCode, "name": value.serviceName});
                    });
					break;
				case "0001":
			}
			for(var i=0;i<allServiceCode.length;i++){
				var tempServiceCode = mid(allServiceCode[i].code, 2, 3);
				if(myProgramPageNumber == "60000001"){
					$("#h1_title").empty();
					$("#h1_title").append("부동산레터");
					if(tempServiceCode == "005"){	//부동산레터만 선택
						$('#sel_serviceCode').val(allServiceCode[i].code);
						$("#txt_callbackMdn").prop("disabled", true);
						$("#txt_callbackMdn").val("02-718-0021");
						$("#sel_msgType").val("40");
						$("#sel_msgType").prop("disabled", true);
						$('#sel_serviceCodeBlock').val(allServiceCode[i].code);
						$('#sel_serviceCodeWithout').val(allServiceCode[i].code);
						$('#sel_serviceCodeSendSms').val(allServiceCode[i].code);
					}
				}
				else if(myProgramPageNumber == "60000003"){
					$("#h1_title").empty();
					$("#h1_title").append("운세레터");
					if(tempServiceCode == "006"){	//운세레터만 선택
						$('#sel_serviceCode').val(allServiceCode[i].code);
						$("#txt_callbackMdn").prop("disabled", true);
						$("#txt_callbackMdn").val("02-718-0021");
						$("#sel_msgType").val("40");
						$("#sel_msgType").prop("disabled", true);
						$('#sel_serviceCodeBlock').val(allServiceCode[i].code);
						$('#sel_serviceCodeWithout').val(allServiceCode[i].code);
						$('#sel_serviceCodeSendSms').val(allServiceCode[i].code);
					}
				}
				else{
					if(tempServiceCode == "005"){	//부동산레터만 선택
						$('#sel_serviceCodeBlock').val(allServiceCode[i].code);
						$('#sel_serviceCodeWithout').val(allServiceCode[i].code);
						$('#sel_serviceCodeSendSms').val(allServiceCode[i].code);
					}
				}
			}
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
		
		var inputData = { "mdn" : encrypt.mdn, "serviceCode": serviceCode, "password":shaPassword, "iv": encrypt.iv };
		
		fun_ajaxPostSend("/management/select/member.do", inputData, true, function(msg){
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
								, "serviceCode": msgResult.serviceCode
								, "incomeCode": msgResult.incomeCode
								, "affiliateChannelCode": msgResult.affiliateChannelCode
								, "regDate": msgResult.regDate
								, "cancelDate": "가입완료"
								, "cancelReason": ""
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
	// if(password==''||password==null){
	// 	$("#txt_adminPassword").focus();
	// 	alert('로그인 비밀번호를 입력해주세요');
	// 	return false;
	// }
	
	if(confirm("검색한 후에는 서버에 해당 전화번호를 조회한 이력이 남습니다.\n해당 전화번호 대해 검색하시겠습니까?")){
		fun_search();
	}
}

function fun_search(){
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

	var encrypt = fun_encryptMdn($("#txt_mdn").val());

	var t = $("#jdtListWithoutMember").dataTable();
	t.fnClearTable();	
	setTimeout(function(){
		fun_certReset();
		$("#txt_withoutMdn").val($("#txt_mdn").val());				
		var inputData = { "mdn" : encrypt.mdn, "serviceCode": serviceCode, "password":shaPassword, "iv": encrypt.iv };
		
		fun_ajaxPostSend("/management/select/without/member.do", inputData, true, function(msg){
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
	}, 300);
}


function fun_searchMms(){
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


	$("#loading_jdtListMms").show();
	
	var encrypt = fun_encryptMdn(requsetMdn);
	var startDate = $("#dtp_startDate").val() + " 00:00:00";
	var closeDate = $("#dtp_closeDate").val() + " 23:59:59";
	
	var inputData = { "mdn" : encrypt.mdn, "serviceCode": serviceCode, "password":shaPassword, "iv": encrypt.iv, "startDate":startDate, "closeDate":closeDate };
	
	fun_ajaxPostSend("/management/select/mms.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					if(tempResult.length!=0){
						var t = $("#jdtListMms").dataTable();
						t.fnClearTable();
						setTimeout(function(){
							fun_dataTableAddData("#jdtListMms", tempResult);
							$("#loading_jdtListMms").hide();
							$("#txt_adminPassword").val("");
						}, 100);
						setTimeout(function(){
							jdtListMms.order([4, 'desc']).draw();
						}, 100);
					}
					else{
						var t = $("#jdtListMms").dataTable();
						t.fnClearTable();
						$("#loading_jdtListMms").hide();
						alert("검색 결과가 없습니다.");
						$("#txt_adminPassword").val("");
					}
					break;
				case "0001":
					var t = $("#jdtListMms").dataTable();
					t.fnClearTable();
					$("#loading_jdtListMms").hide();
					alert("검색 결과가 없습니다.");
					$("#txt_adminPassword").val("");
					break;
			}
				
		}
		else{
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
	
	var inputData = { "mdn" : encrypt.mdn, "password":shaPassword, "iv": encrypt.iv };
	
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
	
	var inputData = { "mdn" : encrypt.mdn, "serviceCode": serviceCode, "password":shaPassword, "iv": encrypt.iv };
	
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
	
	var inputData = { "mdn" : encrypt.mdn, "serviceCode": serviceCode, "password":shaPassword, "iv": encrypt.iv };
	
	fun_ajaxPostSend("/management/insert/block.do", inputData, true, function(msg){
		if(msg!=null){
			var tempServiceCode = "";
			for(var i=0; i<allServiceCode.length; i++){
				if(allServiceCode[i].code == serviceCode){
					tempServiceCode = allServiceCode[i].code + "|" + allServiceCode[i].name; 
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
	
	var inputData = { "mdn" : encrypt.mdn, "serviceCode": serviceCode, "password":shaPassword, "iv": encrypt.iv };
	
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
	var serviceCode = $("#sel_serviceCodeBlock").val();
	if(serviceCode==""){
		$("#sel_serviceCodeBlock").focus();
		alert("서비스 코드를 선택해주세요");
		return false;
	}

	var requsetMdn = $("#txt_withoutMdn").val();
	if(requsetMdn==""){
		$("#txt_withoutMdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	
	var password = "비밀번호 없음";//$("#txt_adminPasswordWithout").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	if(password==''||password==null){
		$("#txt_adminPasswordWithout").focus();
		alert('로그인 비밀번호를 입력해주세요');
		return false;
	}
	fun_timerStart();
	$("#loading_without").show();
	$("#txt_withoutMdn").prop("disabled", true);
	$('#btn_smsReq').prop('disabled', true);
	
	fun_search();
	var encrypt = fun_encryptMdn(requsetMdn);
	//BLMCP의 model을 동일하게 사용하기 위하여 mdn을 부득이하게 MDN으로 설정함
	var inputData = { "MDN" : encrypt.mdn, "SERVICE_CODE": serviceCode, "password":shaPassword, "iv": encrypt.iv };
	
	fun_ajaxPostSend("/management/request/withoutSms.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					if(tempResult.RESULT == "F"){
						certId = "N";
						if(tempResult.RESULT_CODE == "UE1001"){
							alert("이미 가입하셨습니다.");
						}
						else if(tempResult.RESULT_CODE == "UE1002"){
							alert("지원하지 않는 이통사입니다.");
						}
						else if(tempResult.RESULT_CODE == "UE1003"){
							alert("해당 이통사 가입자가 아닙니다.");
						}
						else if(tempResult.RESULT_CODE == "UE1004"){
							alert("미성년 명의의 휴대폰은 서비스신청을 하실 수 없습니다.");		
						}
						else if(tempResult.RESULT_CODE == "UE1006"){
							alert("법인 명의의 휴대폰은 서비스신청을 하실 수 없습니다.");	
						}
						else{
							alert("서비스가 일시적으로 원활하지 않습니다. 해당 서비스는 SKT 고객센터에서도 신청이 가능합니다.");	
						}
					}
					else{
						certId = tempResult.CERT_ID;
						$("#txt_withoutSmsNum").prop("disabled", false);
						$("#txt_withoutSmsNum").focus();
						$("#txt_smsRandNum").empty();
						$("#txt_smsRandNum").append(tempResult.randNum);
					}
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
	var serviceCode = $("#sel_serviceCodeBlock").val();
	if(serviceCode==""){
		$("#sel_serviceCodeBlock").focus();
		alert("서비스 코드를 선택해주세요");
		return false;
	}

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

	var password = "비밀번호 없음";//$("#txt_adminPasswordWithout").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	if(password==''||password==null){
		$("#txt_adminPasswordWithout").focus();
		alert('로그인 비밀번호를 입력해주세요');
		return false;
	}
	$('#btn_smsReq').prop('disabled', true);
	$("#loading_without").show();

	var encrypt = fun_encryptMdn(requsetMdn);
	
	//BLMCP의 model을 동일하게 사용하기 위하여 mdn을 부득이하게 MDN으로 설정함
	var inputData = { "MDN" : encrypt.mdn, "SERVICE_CODE": serviceCode, "CERT_ID": certId, "CERT_NUM":certNum, "password":shaPassword, "iv": encrypt.iv };
	
	fun_ajaxPostSend("/management/request/checkWithoutSms.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					if(tempResult.RESULT_CODE == "US0000"){
						fun_timerEnd();
						$("#txt_smsReq").empty();
						$("#txt_smsReq").append("일치");
						certToken = tempResult.CERT_YN;
						if(certToken.length > 1){
							certToken = certToken.substring(2);
						}
						$("#btn_without").prop("disabled", false);
						//alert("이미 가입하셨습니다.");
					}
					else if(tempResult.RESULT_CODE == "UE2005"){
						fun_certReset();
						alert("입력시간이 초과되었습니다. 인증요청 버튼을 다시 눌러주세요.");
					}
					else if(tempResult.RESULT_CODE == "UE2007"){
						fun_certReset();
						alert("인증번호가 3회 불일치 되었습니다. 인증요청 버튼을 다시 눌러주세요.");
					}
					else if(tempResult.RESULT_CODE == "UE2008"){
						fun_certReset();
						alert("알수없는 인증번호 입니다. 인증요청 버튼을 다시 눌러주세요.");
					}
					else{
						alert("입력하신 인증번호가 올바르지 않습니다.");
						// $("#txt_smsReq").empty();
						// $("#txt_smsReq").append("불일치");
						$("#btn_without").prop("disabled", true);	
					}
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
			fun_certReset();
			alert('서비스가 일시적으로 원활하지 않습니다.');
		}
		$("#loading_without").hide();
	});
}


function fun_requestWithoutMdn(){
	var serviceCode = $("#sel_serviceCodeWithout").val();
	if(serviceCode==""){
		$("#sel_serviceCodeWithout").focus();
		alert("서비스 코드를 선택해주세요");
		return false;
	}

	var requsetMdn = $("#txt_withoutMdn").val();
	if(requsetMdn==""){
		$("#txt_withoutMdn").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	
	var password = "비밀번호 없음";//$("#txt_adminPasswordWithout").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	if(password==''||password==null){
		$("#txt_adminPasswordWithout").focus();
		alert('로그인 비밀번호를 입력해주세요');
		return false;
	}
	$("#loading_without").show();
	
	var encrypt = fun_encryptMdn(requsetMdn);
	
	var inputData = { "MDN" : encrypt.mdn, "SERVICE_CODE": serviceCode, "CERT_YN":certToken, "password":shaPassword, "iv": encrypt.iv };
	
	fun_ajaxPostSend("/management/request/withoutMdn.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					if(tempResult.RESULT_CODE == "US0000"){
						fun_certReset();
						alert("부동산레터 해지가 완료되었습니다.");
					}
					else if(tempResult.RESULT_CODE == "UE1011"){
						fun_certReset();
						alert("빌레터 부동산레터 신청 회원이 아닙니다.");
					}
					else if(tempResult.RESULT_CODE == "UE1002"){
						fun_certReset();
						alert("지원하지 않는 이통사입니다.");
					}
					else if(tempResult.RESULT_CODE == "UE1003"){
						fun_certReset();
						alert("해당 이통사 가입자가 아닙니다.");
					}
					else{
						fun_certReset();
						alert('서비스가 일시적으로 원활하지 않습니다.');
					}
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
		fun_search();
		$("#loading_without").hide();
	});
}


function fun_requestWithoutMdnOfFreefortune(){
	var serviceCode = $("#sel_serviceCode").val();
	if(serviceCode==""){
		$("#sel_serviceCode").focus();
		alert("서비스 코드를 선택해주세요");
		return false;
	}

	var requsetMdn = $("#txt_withoutMdnOfFreefortune").val();
	if(requsetMdn==""){
		$("#txt_withoutMdnOfFreefortune").focus();
		alert("전화번호를 입력 해주세요");
		return false;
	}
	
	var password = "비밀번호 없음";//$("#txt_adminPasswordWithout").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	if(password==''||password==null){
		$("#txt_adminPasswordWithout").focus();
		alert('로그인 비밀번호를 입력해주세요');
		return false;
	}
	$("#loading_without").show();
	
	var encrypt = fun_encryptMdn(requsetMdn);
	
	var inputData = { "MDN" : encrypt.mdn, "SERVICE_CODE": serviceCode, "password":shaPassword, "iv": encrypt.iv };
	
	fun_ajaxPostSend("/management/request/withoutMdnOfFreefortune.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					if(tempResult.RESULT_CODE == "US0000"){
						alert("운세레터 해지가 완료되었습니다.");
					}
					else if(tempResult.RESULT_CODE == "UE1011"){
						alert("빌레터 운세레터 신청 회원이 아닙니다.");
					}
					else if(tempResult.RESULT_CODE == "UE1002"){
						alert("지원하지 않는 이통사입니다.");
					}
					else if(tempResult.RESULT_CODE == "UE1003"){
						alert("해당 이통사 가입자가 아닙니다.");
					}
					else{
						alert('서비스가 일시적으로 원활하지 않습니다.');
					}
					break;
				case "0001":
					alert("로그인 비밀번호를 확인해주세요.");
					break;
				case "0003":
					alert("전화번호가 없습니다");
					break;
			}
		}
		else{
			alert('서비스가 일시적으로 원활하지 않습니다.');
		}
		fun_search();
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
			"mdn" : encrypt.mdn
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
	$("#sel_serviceCode").on("change", function(e){
		var serviceCode = $("#sel_serviceCode").val();
		if(serviceCode=="SC005"){		//부동산레터만 MMS확인 가능
			$("#div_row3").show();	
			setTimeout(function(){
				$("#jdtListMms").dataTable().fnAdjustColumnSizing();
			}, 600);
		}
		else{
			$("#div_row3").hide();	
		}
	});
	
	$("#txt_withoutSmsNum").on("keyup", function(e){
		var certNum = $("#txt_withoutSmsNum").val();
		if(certNum.length==4){
			fun_requestCheckSms();
		}	
	});
	
	$("#dtp_startDate, #dtp_closeDate").datepicker({
		format: "yyyy-mm-dd"
		, language: "kr"
		, autoclose: "true"
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
	$("#txt_withoutMdnOfFreefortune").mask("999-9999-9999", {'translation': {0: {pattern: /[0-9*]/}}});
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
	$('#jdtListMms').delegate('tr', 'click', function () {
		// 빈테이블이 아닐때
		if (this.innerText != "데이터가 없습니다.") {
			var chk = $(this).hasClass('selected');
			if (chk) {
				$(this).removeClass('selected');
				this.children[0].lastChild.checked = false;
				//$(this)[0].children(0).lastChild.checked = false;
				fun_changeAfterinit();
			} else {
				$("#jdtListMms tbody tr").removeClass('selected');
				$("#cbx_selectMmsAll").attr('checked', false);         // 전체선택 체크 해제
				$("input[name='chk-rowMms']").prop('checked', false);  // 선택 줄 외 체크 해제
				$(this).addClass('selected');
				
				this.children[0].lastChild.checked = true;
				//$(this)[0].children(0).lastChild.checked = true;
				fun_setJdtListMmsToTextbox();   // 선택한 줄 값 라인에 입력
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
function fun_setJdtListMember() {
	jdtListWithoutMember = $("#jdtListWithoutMember").DataTable({
		"columns": [
			{ 
				//"title": "<input type='checkbox' id='cbx_selectAll' onclick='fun_SelectAll_jdt_ListMain();' class='ace' />"
				"title": "<input type='checkbox' id='cbx_selectAll' onclick='fun_selectAllJdtListMember();'></input>"
				,"data": null
				, "width": "20px"
				, "defaultContent": "<input type='checkbox' name='chk-row'></input>"
				, "sortable": false
			}   
			, { "title": "코드", "data": "serviceCode"}
			, { "title": "인입경로", "data": "incomeCode"}
			, { "title": "제휴채널", "data": "affiliateChannelCode"}
			, { "title": "가입시간", "data": "regDate"}
			, { "title": "해지시간", "data": "cancelDate"}
			, { "title": "해지이유", "data": "cancelReason"}
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
				, "class": "dt-head-center dt-body-left dtPercent15"
				, "render": function (data, type, row) {
					var tempServiceCode = "";
					for(var i=0; i<allServiceCode.length; i++){
						if(allServiceCode[i].code == row.serviceCode){
							tempServiceCode = allServiceCode[i].code + " | " + allServiceCode[i].name; 
							break;
						}
					}
					return tempServiceCode;
				}
			}
			, {
				"targets": [2]
				, "class": "dt-head-center dt-body-left dtPercent10"
				, "render": function (data, type, row) {
					var code = parseInt(row.incomeCode);
					var result = "";

					switch(code){
						case 1:
							result = "빌레터";
							break;
						case 2:
							result = "CP";
							break;
						case 3:
							result = "통신사";
							break;
					}
                   return result;
                }
			}
			, {
				"targets": [3]
				, "class": "dt-head-center dt-body-left dtPercent15"
				, "render": function (data, type, row) {
					var code = parseInt(row.affiliateChannelCode);
					var result = "";

					switch(code){
						case 0:
							result = "";
							break;
						case 1:
							result = "다뷰";
						break;
						case 2:
							result = "TMS";
							break;
						case 3:
							result = "핀크럭스";
							break;
					}
                   return result;
                }
			}
			, {
				"targets": [4]
				, "class": "dt-head-center dt-body-left dtPercent20"
				, "render": function (data, type, row) {
					var timestamp = parseInt(row.regDate);
					var timezoneOffset = new Date().getTimezoneOffset() * 60000;
					var isoString = new Date(timestamp - timezoneOffset).toISOString()
					.replace(/T/, ' ')      // replace T with a space
					.replace(/\..+/, '');     // delete the dot and everything after
                   return isoString;
                }
			}
			, {
				"targets": [5]
				, "class": "dt-head-center dt-body-left dtPercent20"
				, "render": function (data, type, row) {
					if(row.cancelDate!="가입완료"){
						var timestamp = parseInt(row.cancelDate);
						var timezoneOffset = new Date().getTimezoneOffset() * 60000;
						var isoString = new Date(timestamp - timezoneOffset).toISOString()
						.replace(/T/, ' ')      // replace T with a space
						.replace(/\..+/, '');     // delete the dot and everything after
						return isoString;
					}
					else{
						return row.cancelDate;
					}
                }
			}
			, {
				"targets": [6]
				, "class": "dt-head-center dt-body-left dtPercent30"
					, "render": function (data, type, row) {
						var code = parseInt(row.cancelReason);
						var result = "";

						switch(code){
							case "DownWebServer":
								result = "ECG 다운로드(SKT)";
								break;
							case "BillLetter-Cancel":
								result = "빌레터 API를 통한";
								break;
							case "통신사미가입":
								result = "SKT이용자 아님";
								break;
							case "overlap_mem":
								result = "이미 DB에 가입자가 있어 기존정보 삭제 후 재가입";
								break;
						}
	                   return result;
	                }
			}
		]
	});

};


//=== jdt_List Setting
function fun_setJdtListMms() {
	jdtListMms = $("#jdtListMms").DataTable({
		"columns": [
			{ 
				"title": "<input type='checkbox' id='cbx_selectMmsAll' onclick='fun_selectAllJdtListMms();'></input>"
				,"data": null
				, "width": "20px"
				, "defaultContent": "<input type='checkbox' name='chk-rowMms'></input>"
				, "sortable": false
			}   
			, { "title": "제목", "data": "msgTitle"}
			, { "title": "내용", "data": "shortMsg"}
			, { "title": "msg", "data": "msg"}
			, { "title": "발송일자", "data": "sendDate"}
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
				, "class": "dt-head-center dt-body-center dtPercent30"
			}
			, {
				"targets": [2]
				, "class": "dt-head-center dt-body-left dtPercent60"
				, "render": function (data, type, row) {
					var msg = row.msg;
					var shortMsg = msg;
					var msgLength = fun_getTextLength(msg);
					if(msgLength>50){
						shortMsg = mid(msg, 0, 50);
					}
					else{
						shortMsg = msg;
					}
					return shortMsg;
                }
			}
			, {
				"targets": [3]
				, "class": "hideColumn"
			}
			, {
				"targets": [4]
				, "class": "dt-head-center dt-body-left dtPercent10"
				, "render": function (data, type, row) {
					var timestamp = parseInt(row.sendDate);
					var timezoneOffset = new Date().getTimezoneOffset() * 60000;
					var isoString = new Date(timestamp - timezoneOffset).toISOString()
					.replace(/T/, ' ')      // replace T with a space
					.replace(/\..+/, '');     // delete the dot and everything after
					return isoString;
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

function fun_setJdtListMmsToTextbox() {
	var table = $("#jdtListMms").DataTable();
	var selRow = table.rows('.selected').data()[0];

	if (selRow != undefined) {
		$("#txt_preViewMsgTitle").val(selRow.msgTitle);
		var msg = selRow.msg.replaceAll("|", "\n");
		$("#txt_preViewMsg").val(msg);
		$("#txt_preViewOriginalMsg").val(selRow.msg);
		$("#mdl_mms").modal({"show":true});
	} else {
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
function fun_selectAllJdtListMms() {
	var cbx_selectAll = $("#cbx_selectMmsAll").is(':checked');             // 전체선택 체크시 true
	var tr = $("#jdtListMms tbody tr");

	if (tr[0].innerText != "데이터가 없습니다.") {                              // Row에 추가된 값이 있을시
		if (cbx_selectAll) {
			//$("#Content_jdt_ListMain tbody tr").addClass('selected');           // 클래스 추가
			$("input[name='chk-rowMms']").prop('checked', true);
			$("#jdtListMms tbody tr").removeClass('selected');            // .selected 클래스 제거
		} else {
			//$("#Content_jdt_ListMain tbody tr").removeClass('selected');        // 클래스 삭제
			$("input[name='chk-rowMms']").prop('checked', false);
			$("#jdtListMms tbody tr").removeClass('selected');            // .selected 클래스 제거
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
</script>



<form id="membership" method="post" enctype="multipart/form-data" action="">
   	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header" style="font-size:24px" id="h1_title">회원관리</h1>
	    </div>
	    <!-- /.col-lg-12 -->
    </div>
	
	<div class="space-6"></div>

	<!--자동완성 제거목적-->
	<div class="row" id="div_row1">
		<div class="col-lg-12">
			<div class="col-lg-1" style="padding-top:10px;color:red">
				*서비스 코드
			</div>
			<div class="col-lg-1">
				<select id="sel_serviceCode" class="form-control">
				</select>
			</div>
			<div class="col-lg-1" style="padding-top:10px;color:red">
				*전화번호 : 
			</div>
			<div class="col-lg-2">
				<input type="text" id="txt_mdn" class="form-control" placeholder="010-xxxx-xxxx" autocomplete="no">
			</div>
			<!--
			<div class="col-lg-1" style="color:red">
				*로그인<br>비밀번호 
			</div>
			<div class="col-lg-2">
				<div class="col-lg-10">
					<input type="password" id="txt_adminPassword" class="form-control" autocomplete="no">
				</div>
				<div class="col-lg-2">
					
				</div>
			</div>
			<div class="col-lg-1">
			</div>
			-->
		</div>
	</div>

	<!--<div class="row" id="div_row2">
        <div class="col-lg-12">
            <div id="accordion1" class="accordion-style1 panel-group accordion-style2">
                <div class="panel panel-default" id="tog_Head">
                    <div class="panel-heading clearfix" style="font-size:16px">
                        <span class="toggle_accordion">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse1" >
				    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
				    &nbsp;가입자 확인(현재 가입자 정보)
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                            
                        </span>
                    </div>
                    <div id="collapse1" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="row">
								<div class="col-lg-1" style="padding-top:10px">
									서비스 코드
								</div>
								<div class="col-lg-3">
									<select id="sel_serviceCode2" class="form-control" style="color:black" disabled>
									</select>
								</div>
								<div class="col-lg-1" style="padding-top:10px">
									가입경로
								</div>
								<div class="col-lg-2">
									<select id="sel_incomeCode" class="form-control" style="color:black" disabled>
										<option value="">------</option>
										<option value="1">빌레터에서</option>
										<option value="2">CP에서</option>
										<option value="3">통신사에서</option>
									</select>
								</div>
								<div class="col-lg-1" style="padding-top:10px">
									가입일자
								</div>
								<div class="col-lg-2">
									<input type="text" id="txt_regDate" class="form-control" style="color:black" disabled>
								</div>
							</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</div>

	<div class="space-16"></div>	 -->

	<div class="row" id="div_row2">
        <div class="col-lg-12">
            <div id="accordion2" class="accordion-style1 panel-group accordion-style2">
                <div class="panel panel-default" id="tog_Head">
                    <div class="panel-heading clearfix" style="font-size:16px">
                        <span class="toggle_accordion">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse2" >
				    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
				    &nbsp;가입 이력 조회
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
							<input type="button" id="btn_selectMdn" onclick="fun_searchMdnWithoutMember();" class="btn btn-info btn-sm" value="조회" />
                            <!--<input type="button" id="btn_selectMdnWithoutMember" onclick="fun_searchMdnWithoutMember();" class="btn btn-info btn-sm" value="조회" />-->
                        </span>
                    </div>
                    <div id="collapse2" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="dataTable_wrapper">
                                <table id="jdtListWithoutMember" class="table table-striped table-bordered table-hover">
                                    <thead>

                                    </thead>
                                    <tbody>

                                    </tbody>
                                </table>
							</div>
							<div style="color:red;">※ 인입경로 : 빌레터, CP, 통신사</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</div>
	

	<div class="row" id="div_row3" style="display: none;">
        <div class="col-lg-12">
            <div id="accordion3" class="accordion-style1 panel-group accordion-style2">
                <div class="panel panel-default" id="tog_Head">
                    <div class="panel-heading clearfix" style="font-size:16px">
                        <span class="toggle_accordion">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse3" >
				    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
				    &nbsp;MMS발송 이력 조회
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                            <input type="button" id="btn_selectMms" onclick="fun_searchMms();" class="btn btn-info btn-sm" value="MMS조회" />
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
							<div id="loading_jdtListMms" class="loadingDataTable" style="display:none;">
								<img src="../assets/img/loading.gif" alt="loading">
							</div>
                            <div class="dataTable_wrapper" id="dataTable_wrapper1">
                                <table id="jdtListMms" class="table table-striped table-bordered table-hover">
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


	<div tabindex="-1" class="modal fade" id="mdl_mms" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button id="mdl_mms_close" class="close" aria-hidden="true" type="button" data-dismiss="modal">×</button>
                    <h4 class="modal-title" id="H5">MMS전문보기</h4>
                </div>
                <div class="modal-body">
                	<input type="text" id="txt_preViewMsgTitle" class="form-control">
					<textarea id="txt_preViewMsg" class="form-control" style="height:300px"></textarea>
					<div style="color:red">※ "|" 이 기호는 엔터로 치환(시안성을 위함)</div>
					<textarea id="txt_preViewOriginalMsg" class="form-control" style="height:30px"></textarea>
                </div>
            </div>
        </div>
    </div>

	<div class="row">
		<div class="col-lg-2">
			<button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#mdl_block" id="btn_blockToMdl" style="display:none;">가입제한 설정</button>
		</div>
		<div class="col-lg-2">
			<button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#mdl_sendSms" id="btn_sendSmsToMdl">문자발송</button>
		</div>
		<div class="col-lg-2">
			<button type="button" class="btn btn-danger btn-sm" data-toggle="modal" data-target="#mdl_without" id="btn_withoutToMdl">부동산레터 해지</button>
		</div>
		<div class="col-lg-2">
			<button type="button" class="btn btn-danger btn-sm" data-toggle="modal" data-target="#mdl_withoutFreefortune" id="btn_withoutToMdlOfFreefortune">운세레터 해지</button>
		</div>
	</div>

	<div tabindex="-1" class="modal fade" id="mdl_block" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" style="margin-left: 45%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button id="mdl_mms_close" class="close" aria-hidden="true" type="button" data-dismiss="modal">×</button>
                    <h4 class="modal-title" id="H5">부동산레터 가입제한 설정(강성고객)</h4>
                </div>
                <div class="modal-body">
					<div class="row form-group">
						<div class="col-lg-2" style="color: red;padding-top:8px;">
							서비스코드 
						</div>
						<div class="col-lg-10">
							<select id="sel_serviceCodeBlock" class="form-control" disabled>
							</select>
						</div>
					</div>
					<div class="row form-group">
						<div class="col-lg-2" style="padding-top:8px;color:red">
							*전화번호 : 
						</div>
						<div class="col-lg-10">
							<input type="text" id="txt_blockMdn" class="form-control" placeholder="010-xxxx-xxxx">
						</div>
					</div>
					<div class="row form-group">
						<div class="col-lg-2" style="color:red">
							<button type="button" class="btn btn-danger btn-sm" onclick="fun_insertAllBlockMdn();">전체설정</button>
							<!--*로그인<br>비밀번호 :-->
						</div>
						<div class="col-lg-2" style="color:red">
							<button type="button" class="btn btn-danger btn-sm" onclick="fun_insertAllUnBlockMdn();">전체해제</button>
						</div>
						<div class="col-lg-4">

							<!--<input type="password" id="txt_adminPasswordBlock" class="form-control" autocomplete="no">-->
						</div>
						<div class="col-lg-2">
							<button type="button" class="btn btn-danger btn-sm" onclick="fun_insertBlockMdn();">설정</button>
						</div>
						<div class="col-lg-2">
							<button type="button" class="btn btn-primary btn-sm" onclick="fun_insertUnBlockMdn();">해제</button>
						</div>
					</div>
					<div class="row form-group">
						<div style="color:red">※ 타 서비스는 제공하지 않습니다(부동산레터만 가능)</div>
					</div>
                </div>
            </div>
        </div>
	</div>
	
	<div tabindex="-1" class="modal fade" id="mdl_without" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog" style="margin-left: 45%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button id="mdl_mms_close" class="close" aria-hidden="true" type="button" data-dismiss="modal">×</button>
                    <h4 class="modal-title" id="H5">부동산레터 해지</h4>
                </div>
                <div class="modal-body">
                	<div id="loading_without" class="loadingDataTable" style="display:none;margin-left: -15px;margin-top: -15px;">
						<img src="../assets/img/loading.gif" alt="loading">
					</div>
					<div class="row form-group">
						<div class="col-lg-2" style="color: red;padding-top:8px;">
							서비스코드
						</div>
						<div class="col-lg-10">
							<select id="sel_serviceCodeWithout" class="form-control" disabled></select>
						</div>
					</div>
					<div class="row form-group">
						<div class="col-lg-2" style="padding-top:8px;color:red">
							*전화번호 : 
						</div>
						<div class="col-lg-4">
							<input type="text" id="txt_withoutMdn" class="form-control" placeholder="010-xxxx-xxxx">
						</div>
						<div class="col-lg-2" style="color:red">
							<button type="button" class="btn btn-warning btn-sm" onclick="fun_requestSms();" id="btn_smsReq">인증요청</button>
							<!--*로그인<br>비밀번호 :-->
						</div>
						<div class="col-lg-2" style="padding-top:8px">
							인증번호
							<!--<input type="password" id="txt_adminPasswordWithout" class="form-control" autocomplete="no">-->
						</div>
						<div class="col-lg-2">
							<label id="txt_smsRandNum" class="form-control" style="border: 0px;"></label>
						</div>
					</div>
					<div class="row form-group">
						<div class="col-lg-2" style="padding-top:8px;color:red">
							*인증번호 : 
						</div>
						<div class="col-lg-4">
							<input type="text" class="form-control" id="txt_withoutSmsNum" maxlength="4" placeholder="인증번호 입력" title="인증번호 입력" disabled>
						</div>
						<div class="col-lg-2">
							<label id="txt_smsReq" class="form-control" style="border: 0px;"></label>
						</div>
						<div class="col-lg-4">
							<button type="button" class="btn btn-danger btn-sm" onclick="fun_requestWithoutMdn();" id="btn_without" disabled>해지처리</button>
						</div>
					</div>
					<div class="row form-group">
						<div style="color:red">※ 타 서비스는 제공하지 않습니다(부동산레터만 가능)</div>
					</div>
                </div>
            </div>
        </div>
	</div>
	
	
	<div tabindex="-1" class="modal fade" id="mdl_sendSms" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog" style="margin-left: 45%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button id="mdl_mms_close" class="close" aria-hidden="true" type="button" data-dismiss="modal">×</button>
                    <h4 class="modal-title" id="H5">문자발송</h4>
                </div>
                <div class="modal-body">
					<div class="row form-group">
						<div class="col-lg-2" style="color: red;padding-top:8px;">
							부동산코드 
						</div>
						<div class="col-lg-10">
							<select id="sel_serviceCodeSendSms" class="form-control" disabled>
							</select>
						</div>
					</div>
					<div class="row form-group">
						<div class="col-lg-2" style="color: red;padding-top:8px;">
							*문자형태
						</div>
						<div class="col-lg-10">
							<select id="sel_msgType" class="form-control">
								<option value="">---선택---</option>
								<option value="10">일반문자</option>
								<option value="40">MMS문자</option>
							</select>
							<div style="color:red">긴 문장의 경우 MMS문자</div>
						</div>
					</div>
					<div class="row form-group">
						<div class="col-lg-2" style="padding-top:8px;color:red">
							*전화번호 : 
						</div>
						<div class="col-lg-4">
							<input type="text" id="txt_sendSmsMdn" class="form-control" placeholder="010-xxxx-xxxx">
						</div>
						<div class="col-lg-2" style="color:red">
							<!--*로그인<br>비밀번호 :-->
						</div>
						<div class="col-lg-4">
							<!--<input type="password" id="txt_adminPasswordSendSms" class="form-control" autocomplete="no">-->
						</div>
					</div>
					<div class="row form-group">
						<div class="col-lg-2" style="padding-top:8px;color:red">
							*제목 : 
						</div>
						<div class="col-lg-10">
							<input type="text" class="form-control" id="txt_sendTitle" placeholder="제목">
						</div>
					</div>
					<div class="row form-group">
						<div class="col-lg-2" style="padding-top:8px;color:red">
							*내용 : 
						</div>
						<div class="col-lg-10">
							<textarea id="txt_sendSmsMsg" class="form-control" style="height:300px"></textarea>
							<div style="color:red">※ "|" 이 기호는 엔터로 치환(시안성을 위함)</div>
						</div>
					</div>
					<div class="row form-group">
						<div style="color:red">※ 타 서비스는 제공하지 않습니다(부동산레터만 가능)</div>
					</div>
					<div class="row form-group">
						<div class="col-lg-2" style="padding-top:8px;color:red">
							*회신전화번호 : 
						</div>
						<div class="col-lg-4">
							<input type="text" class="form-control" id="txt_callbackMdn" placeholder="02-718-0021">
						</div>
						<div class="col-lg-4">
							<button type="button" class="btn btn-danger btn-sm" onclick="fun_sendSms();" id="btn_without">발송</button>
						</div>
						
					</div>
                </div>
            </div>
        </div>
	</div>



	<div tabindex="-1" class="modal fade" id="mdl_withoutFreefortune" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog" style="margin-left: 45%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button id="mdl_freefortune_close" class="close" aria-hidden="true" type="button" data-dismiss="modal">×</button>
                    <h4 class="modal-title" id="H5">운세레터 해지</h4>
                </div>
                <div class="modal-body">
                	<div id="loading_without" class="loadingDataTable" style="display:none;margin-left: -15px;margin-top: -15px;">
						<img src="../assets/img/loading.gif" alt="loading">
					</div>
					<div class="row form-group">
						<div class="col-lg-2" style="padding-top:8px;color:red">
							*전화번호 : 
						</div>
						<div class="col-lg-4">
							<input type="text" id="txt_withoutMdnOfFreefortune" class="form-control" placeholder="010-xxxx-xxxx">
						</div>
					</div>
					<div class="row form-group">
						<div class="col-lg-4">
							<button type="button" class="btn btn-danger btn-sm" onclick="fun_requestWithoutMdnOfFreefortune();" id="btn_withoutOfFreefortune">해지처리</button>
						</div>
					</div>
					<div class="row form-group">
						<div style="color:red">※ 타 서비스는 제공하지 않습니다(운세레터만 가능)</div>
					</div>
                </div>
            </div>
        </div>
	</div>
</form>
