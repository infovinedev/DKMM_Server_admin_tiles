<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="../assets/js/cryptoJs/aes.js"></script>
<script>

var jdtListLogHistory;
var jdtListMms;
var key = CryptoJS.enc.Utf8.parse("${crypto}");
var timeloop;
var certId = "";
var certToken = "";
window.onload = function(){
	$("#jdtListLogHistory_paginate").on('click', function(event) {
		jdtListLogHistory.rows('.selected').nodes().to$().removeClass('selected');
		$("#cbx_selectAll").attr('checked', false);         // 전체선택 체크 해제
		$("input[name='chk-row']").prop('checked', false);  // 선택 줄 외 체크 해
	});
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
		$('#jdtListLogHistory').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
		var dataTableWrapperHeight = $("#dataTable_wrapper1").height();
		$("#loading_jdtListMms").height(dataTableWrapperHeight);
		//$('#jdtListMember').dataTable().fnAdjustColumnSizing();
	});

	$('.panel').on('shown.bs.collapse', function (e) {
		$('#jdtListLogHistory').dataTable().fnAdjustColumnSizing();
		var dataTableWrapperHeight = $("#dataTable_wrapper1").height();
		$("#loading_jdtListMms").height(dataTableWrapperHeight);
		//$('#jdtListMember').dataTable().fnAdjustColumnSizing();
	});

	fun_initializeClickEvent();

	fun_setJdtListLogHistory();
	
	var dataTableWrapperHeight = $("#dataTable_wrapper1").height();
	$("#loading_jdtListMms").height(dataTableWrapperHeight);

});


//탈퇴한 회원들 불러오기
function fun_searchLogHistory(){
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
	
	var startDate = $("#dtp_startDate").val().replaceAll("-", "") + "000000" + "000";		//20210701000000000
	var closeDate = $("#dtp_closeDate").val().replaceAll("-", "") + "235959" + "999";		//20210831235959999
	var inputData = { "startDate" : startDate, "closeDate" : closeDate };
	
	fun_ajaxPostSend("/admin/select/log.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					if(tempResult.length!=0){
						for(var i=0; i<tempResult.length;i++){
							var userName = tempResult[i].tbAdminScaleDownUserModel.userName;
							tempResult[i].name = userName;
						}

						fun_dataTableAddData("#jdtListLogHistory", tempResult);
					}
					break;
				case "0001":
					alert("오류가 발생하였습니다. 관리자에게 문의해주세요");
					return false;
					break;
				case "0001":
					alert("시작일자와 종료일자를 확인해주세요");
					return false;
					break;
			}
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}



function fun_initializeClickEvent(){
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
		tempMonth = + "0" + tempMonth.toString();
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
	

	$('#jdtListLogHistory').delegate('tr', 'click', function () {
		// 빈테이블이 아닐때
		if (this.innerText != "데이터가 없습니다.") {
			var chk = $(this).hasClass('selected');
			if (chk) {
				$(this).removeClass('selected');
				
				this.children[0].lastChild.checked = false;
				//$(this)[0].children(0).lastChild.checked = false;
			} else {
				$("#jdtListLogHistory tbody tr").removeClass('selected');
				$("#cbx_selectAll").attr('checked', false);         // 전체선택 체크 해제
				$("input[name='chk-row']").prop('checked', false);  // 선택 줄 외 체크 해제
				$(this).toggleClass('selected');
				this.children[0].lastChild.checked = true;
				//$(this)[0].children(0).lastChild.checked = true;
				
				fun_setJdtListLogHistoryToTextbox();   // 선택한 줄 값 라인에 입력
			}
		}
	});

	//테이블 검색시
	$("#txt_searchLogHistory").on('keyup click', function () {
		$("#jdtListLogHistory").DataTable().search(
			$("#txt_searchLogHistory").val()
		).draw();
	});

}

//=== jdt_List Setting
function fun_setJdtListLogHistory() {
	jdtListLogHistory = $("#jdtListLogHistory").DataTable({
		"columns": [
			{ 
				//"title": "<input type='checkbox' id='cbx_selectAll' onclick='fun_SelectAll_jdt_ListMain();' class='ace' />"
				"title": "<input type='checkbox' id='cbx_selectAll' onclick='fun_selectAllJdtListMember();'></input>"
				,"data": null
				, "width": "20px"
				, "defaultContent": "<input type='checkbox' name='chk-row'></input>"
				, "sortable": false
			}   
			, { "title": "idx", "data": "seq"}
			, { "title": "이름", "data": "name"}
			, { "title": "URL", "data": "requestUrl"}
			, { "title": "param", "data": "shortParam"}
			, { "title": "param", "data": "param"}
			, { "title": "decrypt", "data": "decrypt"}
			, { "title": "일자", "data": "regDate"}
		]
		, "paging": true            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "autoWidth": false
		, "scrollY": "550px"
		, "scrollCollapse": true
		, "scrollX": true
		, "scrollXInner": "100%"
		//, "orderClasses": false
		//, "order": [[ 7, "desc" ]]
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
				, "class": "dt-head-center dt-body-left dtPercent5"
			}
			, {
				"targets": [2]
				, "class": "dt-head-center dt-body-left dtPercent5"
			}
			, {
				"targets": [3]
				, "class": "dt-head-center dt-body-left dtPercent25"
			}
			, {
				"targets": [4]
				, "class": "dt-head-center dt-body-left dtPercent55"
				, "render": function (data, type, row) {
					var msg = row.param;
					var shortMsg = msg;
					// var msgLength = fun_getTextLength(msg);
					// if(msgLength>50){
					// 	shortMsg = mid(msg, 0, 50);
					// }
					// else{
					// 	shortMsg = msg;
					// }
					return shortMsg;
                }
			}
			, {
				"targets": [5]
				, "class": "hideColumn"
			}
			, {
				"targets": [6]
				, "class": "hideColumn"
				, "render": function (data, type, row) {
					var msg = JSON.parse(row.param);
					var resultMdn = "";
					if(row.requestUrl=="/realestate/insert/promotionWinner.do"){
						console.log("test");
					}
					if(mid(row.param, 0, 1)=="["){
						
					}
					else if(mid(row.param, 0, 1)=="{"){			//배열이 아닐경우
						if(msg.cryptKey!=undefined){
							if(msg.jsonObject.promotionWinner!=undefined){
								for(var i=0; i<msg.jsonObject.promotionWinner.length; i++){
									if(msg.cryptKey!=undefined){
										var mdn = "";
										if(msg.jsonObject.promotionWinner[i].mdn!=undefined){
											mdn = msg.jsonObject.promotionWinner[i].mdn;
										}
										if(msg.jsonObject.promotionWinner[i].MDN!=undefined){
											mdn = msg.jsonObject.promotionWinner[i].MDN;
										}
										if(msg.jsonObject.promotionWinner[i].tel!=undefined){
											mdn = msg.jsonObject.promotionWinner[i].tel;
										}
										var iv = msg.jsonObject.promotionWinner[i].iv;
										resultMdn += fun_decryptMdn(msg.cryptKey, mdn, iv) + "\n";
									}
									else{
										break;
									}
								}
							}
							else{
								var mdn = "";
								if(msg.jsonObject.mdn!=undefined){
									mdn = msg.jsonObject.mdn;
								}
								if(msg.jsonObject.MDN!=undefined){
									mdn = msg.jsonObject.MDN;
								}
								if(msg.jsonObject.tel!=undefined){
									mdn = msg.jsonObject.tel;
								}
								var iv = msg.jsonObject.iv;
								resultMdn += fun_decryptMdn(msg.cryptKey, mdn, iv) + "";
							}
						}
						else{
							resultMdn = row.param;
						}
					}
					
					return resultMdn;
                }
			}
			, {
				"targets": [7]
				, "class": "dt-head-center dt-body-left dtPercent10"
				, "render": function (data, type, row) {
					var regDate = row.regDate;
					regDate = mid(regDate, 0, 4) + "-" + mid(regDate, 4, 2) + "-" + mid(regDate, 6, 2) + " " + mid(regDate, 8, 2) + ":" + mid(regDate, 10, 2) + ":" + mid(regDate, 12, 2);
					return regDate;
                }
			}
		]
	});

};

function fun_decryptMdn(cryptKey, mdn, iv){
	var key = CryptoJS.enc.Utf8.parse(cryptKey);
	var bytes = [];
	var arrayBuffer = new ArrayBuffer(16);
	for (var j=0; j< iv.length; ++j) {
		var code = iv[j];
		bytes = bytes.concat([code]);
	}
	var arrayBuffer = new Uint8Array(bytes);
	var wordIv = byteArrayToWordArray(arrayBuffer);
	var data = CryptoJS.AES.decrypt(mdn, key, { iv: wordIv });
	return hex2a(data.toString());
}

//==================================JQuery DataTable Setting 끝==================================


function fun_setJdtListLogHistoryToTextbox() {
	var table = $("#jdtListLogHistory").DataTable();
	var selRow = table.rows('.selected').data()[0];

	if (selRow != undefined) {
		$("#txt_preViewMsgUrl").val(selRow.requestUrl);
		var msg = JSON.parse(selRow.param);
		var resultMdn = "";
		if(mid(selRow.param, 0, 1)=="["){
			
		}
		else if(mid(selRow.param, 0, 1)=="{"){			//배열이 아닐경우
			if(msg.cryptKey!=undefined){
				if(msg.jsonObject.promotionWinner!=undefined){
					for(var i=0; i<msg.jsonObject.promotionWinner.length; i++){
						if(msg.cryptKey!=undefined){
							var mdn = "";
							if(msg.jsonObject.promotionWinner[i].mdn!=undefined){
								mdn = msg.jsonObject.promotionWinner[i].mdn;
							}
							if(msg.jsonObject.promotionWinner[i].MDN!=undefined){
								mdn = msg.jsonObject.promotionWinner[i].MDN;
							}
							if(msg.jsonObject.promotionWinner[i].tel!=undefined){
								mdn = msg.jsonObject.promotionWinner[i].tel;
							}
							var iv = msg.jsonObject.promotionWinner[i].iv;
							resultMdn += fun_decryptMdn(msg.cryptKey, mdn, iv) + "\n";
						}
						else{
							break;
						}
					}
				}
				else{
					var mdn = "";
					if(msg.jsonObject.mdn!=undefined){
						mdn = msg.jsonObject.mdn;
					}
					if(msg.jsonObject.MDN!=undefined){
						mdn = msg.jsonObject.MDN;
					}
					if(msg.jsonObject.tel!=undefined){
						mdn = msg.jsonObject.tel;
					}
					var iv = msg.jsonObject.iv;
					resultMdn += fun_decryptMdn(msg.cryptKey, mdn, iv) + "";
				}
			}
			else{
				resultMdn = selRow.param;
			}
		}
		
		
		$("#txt_preViewParam").val(resultMdn);
		$("#mdl_url").modal({"show":true});
	} 
	// else {
	// 	//table.rows('.selected').removeClass('selected');
	// 	table.rows('.selected').nodes().to$().removeClass('selected');
	// }
	
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

</script>



<form id="membership" method="post" enctype="multipart/form-data" action="">
   	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header" style="font-size:24px">로그확인</h1>
	    </div>
	    <!-- /.col-lg-12 -->
    </div>
	
	<div class="space-6"></div>

	<!--자동완성 제거목적-->
	<div class="row" id="div_row1">
		<div class="col-lg-12">
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
	</div>


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
							<input type="button" id="btn_selectMdn" onclick="fun_searchLogHistory();" class="btn btn-info btn-sm" value="조회" />
                            <!--<input type="button" id="btn_selectMdnWithoutMember" onclick="fun_searchLogHistory();" class="btn btn-info btn-sm" value="조회" />-->
                        </span>
                    </div>
                    <div id="collapse2" class="panel-collapse collapse in">
                        <div class="panel-body">
							<div>
								<input type="text" id="txt_searchLogHistory" placeholder="테이블 내 검색" class="form-control" />
							</div>
                            <div class="dataTable_wrapper">
                                <table id="jdtListLogHistory" class="table table-striped table-bordered table-hover">
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
	

	<div tabindex="-1" class="modal fade" id="mdl_url" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button id="mdl_url_close" class="close" aria-hidden="true" type="button" data-dismiss="modal">×</button>
                    <h4 class="modal-title" id="H5">전문보기</h4>
                </div>
                <div class="modal-body">
                	<input type="text" id="txt_preViewMsgUrl" class="form-control">
					<textarea id="txt_preViewParam" class="form-control" style="height:300px"></textarea>
                </div>
            </div>
        </div>
    </div>

</form>
