<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="../assets/js/cryptoJs/aes.js"></script>
<script>

var jdtListCalculate;

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
		$('#jdtListCalculate').dataTable().fnAdjustColumnSizing();
	});

	$('.panel').on('shown.bs.collapse', function (e) {
		$('#jdtListCalculate').dataTable().fnAdjustColumnSizing();
	});

	fun_seletAffiliateChannalCode();
	
	fun_initializeClickEvent();

	fun_setJdtListCalculate();

	//var table = $("#jdtListCalculate").DataTable();
	
	// var tempj = 31;
	// var textTest = "";
	// for(var tempi=0; 31>=tempi; tempi++){
	// 	table.row.add({
	// 		"total": tempi
	// 		, "count": tempj
	// 	}).draw();
	// 	textTest += tempi + "\t" + tempj + "\n";
	// 	tempj--;
	// }
	// $("#txt_tempTextArea").val(textTest);
	// $("#sel_mdn").val("서울");
	// $("#txt_businessName").val("사업명테스트");
	// $("#txt_builder").val("건설사테스트");
	// $("#txt_notidate").val("2021.11.30");
	// $("#sel_state").val("청약중");
	//$("#txt_mdn").val("010-5555-4444");
});

let affiliateChannalCode;

function fun_seletAffiliateChannalCode(){
	var inputData = {"codeGroup" : "affiliate_channel_code"};
	fun_ajaxPostSend("/common/select/tb/affiliateChannelCode.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					if(tempResult.length!=0){
						affiliateChannalCode = tempResult;
					}
					break;
				case "0001":
					break;
				case "0002":
			}
			// var t = $("#jdtListCalculate").dataTable();
			// t.fnClearTable();
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

	$("#sel_years, #sel_months").change(function(){
		fun_changeDate();
	});

	var tempToday = new Date();
	var tempYears = tempToday.toISOString().substring(0, 4);
	var tempMonths = tempToday.getMonth();
	//이전 달을 불러와야 함
	switch(tempMonths){
	case 0:
		tempYears = parseInt(tempYears);
		tempMonths = "12";
		break;
	case 11:
		tempMonths = tempMonths.toString();
	case 10:
		tempMonths = "09";
		break;
	default:
		tempMonths = + "0" + tempMonths.toString();
	}
	
	for(var i=2020; i<=2030; i++){
		$('#sel_years').append($('<option></option>').val(i).html(i+"년"));
	}

	$('#sel_years').val(tempYears.toString());
	$('#sel_months').val(tempMonths);
	fun_changeDate();
	
	$("#txt_mdn").mask("999-9999-9999", {'translation': {0: {pattern: /[0-9*]/}}});

	$("#sel_serviceCode").change(function(){
		var serviceCode = $("#sel_serviceCode option:selected").val();
		$('#sel_affiliateChannelCode *').remove();
		$('#sel_affiliateChannelCode').append($('<option></option>').val("90000000").html("---전체---"));
		if(serviceCode == "SC005"){
			//$("#sel_affiliateChannelCode").
			for(var i=0;i<affiliateChannalCode.length;i++){
				$('#sel_affiliateChannelCode').append($('<option></option>').val(affiliateChannalCode[i].codeValue).html(affiliateChannalCode[i].codeValue + " | " + affiliateChannalCode[i].codeName));
			}
			//$('#sel_affiliateChannelCode').append($('<option></option>').val("000").html("000" + " | " + "제휴채널없음."));
			//$('#sel_affiliateChannelCode').append($('<option></option>').val("001").html("001" + " | " + "다뷰"));
			//$('#sel_affiliateChannelCode').append($('<option></option>').val("002").html("002" + " | " + "TMS"));
			//$('#sel_affiliateChannelCode').append($('<option></option>').val("003").html("003" + " | " + "핀크럭스"));
			$("#sel_affiliateChannelCode").prop("disabled", false);
		}
		else{
			$("#sel_affiliateChannelCode").prop("disabled", true);
		}

	});
	//$("#sel_affiliateChannelCode")


	$('#btn_DeleteSelect').click(function () {
		var oTable = $("#jdtListCalculate").DataTable();
		var t = $("#jdtListCalculate").dataTable();
		
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

function fun_changeDate(){
	//var today = fun_getToday();
	var tempYears = $("#sel_years option:selected").val();
	var tempMonths = parseInt($("#sel_months option:selected").val());
	
	switch(tempMonths){
	case 0:
		tempYears = parseInt(tempYears) - 1;
		tempMonths = "12";
		break;
	case -1:
		tempYears = parseInt(tempYears) - 1;
		tempMonths = "11";
		break;
	case 10:
	case 11:
	case 12:
		tempMonths = tempMonths;
		break;
	default:
		tempMonths = + "0" + tempMonths.toString();
	}
	var tempStartDate = tempYears + "-" + tempMonths + "-" + "01";
	$("#dtp_startDate").datepicker( "setDate", tempStartDate );
	
	
	var tempYears = $("#sel_years option:selected").val();
	var tempMonths = parseInt($("#sel_months option:selected").val()) + 1;
	
	//이전 달을 불러와야 함
	switch(tempMonths){
	case 10:
	case 11:
	case 12:
		tempMonths = tempMonths;
		break;
	case 13:
		tempYears = parseInt(tempYears) + 1;
		tempMonths = "01";
		break;
	default:
		tempMonths = + "0" + tempMonths.toString();
	}
	var tempCloseDate = tempYears + "-" + tempMonths + "-" + "01";
	$("#dtp_closeDate").datepicker( "setDate", tempCloseDate );
}

//=== jdt_List Setting
function fun_setJdtListCalculate() {
	jdtListCalculate = $("#jdtListCalculate").DataTable({
		"columns": [
			{ "title": "total", "data": "total"}
			, { "title": "count", "data": "count"}
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
		, "dom": "Btp"
		, "buttons" : ["copy"]
		//, "buttons":[ {"extend":"copy", "text": "Copy to clipboard", "className": "exportExcel", "exportOptions": { "modifier": { "page": "all"}}}] 
		//, "dom": 't<"bottom"p><"clear">'
		, "language": {
			// "buttons": {
            // 	"copyTitle": 'Data copied',
            // 	"copyKeys": 'Use your keyboard or menu to select the copy command'
        	// },
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
				"targets": [0]
				, "class": "dt-head-center dt-body-center dtPercent15"
			}
			, {
				"targets": [1]
				, "class": "dt-head-center dt-body-left dtPercent15"
			}
		]
	});
};
//==================================JQuery DataTable Setting 끝==================================


function fun_selectCalculateMember() {
	$("#txt_tempTextArea").val("");
	var serviceCode = $("#sel_serviceCode").val();
	if(serviceCode==""){
		$("#sel_serviceCode").focus();
		alert("서비스를 선택해주세요");
		return;
	}
	$("#btn_clipboard").prop("disabled", true);
	var t = $("#jdtListCalculate").dataTable();
	t.fnClearTable();
	
	var affiliateChannelCode = $("#sel_affiliateChannelCode").val();;
	//2022-07-14 제휴채널 조회 가능토록 변경
	switch(affiliateChannelCode){
		case "90000000":
			affiliateChannelCode = null;
			break;
	}
	/*
	switch(affiliateChannelCode){
		case "001":
			affiliateChannelCode = "001";
			break;
		default:
			affiliateChannelCode = null;
	}*/
	var startDate = $("#dtp_startDate").val();
	var closeDate = $("#dtp_closeDate").val();
	
	var inputData = {"serviceCode":serviceCode, "affiliateChannelCode": affiliateChannelCode, "startDate":startDate, "closeDate": closeDate};

	fun_ajaxPostSend("/management/select/calculate.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					if(tempResult.length!=0){
						fun_jdtListdraw(tempResult, function(tempResult){
							setTimeout(function(){
								var tempText = ""; 
								for(var i=0; i<tempResult.length; i++){
									tempText += $("#jdtListCalculate tbody tr")[i].innerText + "\n";
								}
								$("#txt_tempTextArea").val(tempText);
								$("#btn_clipboard").prop("disabled", false);
							},600);
						});
						//fun_dataTableAddData("#jdtListCalculate", tempResult);
					}
					break;
				case "0001":
					break;
				case "0002":
			}
			// var t = $("#jdtListCalculate").dataTable();
			// t.fnClearTable();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
	return false;
};

function fun_jdtListdraw(tempResult, callback){
	var table = $("#jdtListCalculate").DataTable();
	for(var i=0; i<tempResult.length; i++){
		table.row.add({
			"total": tempResult[i].total
			, "count": tempResult[i].count
		}).draw();
	}
	callback(tempResult);
}

function fun_copyToClipboard(){
	$("#txt_tempTextArea").select();
	document.execCommand("copy");
	alert("클립보드에 복사되었습니다.")
}
</script>



<form id="membership" method="post" enctype="multipart/form-data" action="">
   	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header" style="font-size:24px">정산기준 사용자</h1>
	    </div>
	    <!-- /.col-lg-12 -->
    </div>
	
	<div class="space-6"></div>
	
	<!--자동완성 제거목적-->
	<div class="row" id="div_row1">
		<div class="col-lg-12">
			<div class="col-lg-1" style="padding-top:10px">
				서비스 : 
			</div>
			<div class="col-lg-1">
				<select id="sel_serviceCode" class="form-control">
					<option value="">---선택---</option>
					<option value="SC001">통신비안심</option>
					<option value="SC002">주식레터</option>
					<option value="SC005">부동산레터</option>
					<option value="SC008">마이풀</option>
					<option value="SC009">오토레터</option>
					<option value="SC010">마인드케어</option>
				</select>
			</div>
			<div class="col-lg-1" style="padding-top:10px">
				제휴채널 : 
			</div>
			<div class="col-lg-1">
				<select id="sel_affiliateChannelCode" class="form-control" disabled>
					<option value="">---전체---</option>
				</select>
			</div>

			<div class="col-lg-1" style="padding-top:10px">
				조회년 : 
			</div>
			<div class="col-lg-2">
				<div class="form-group">
					<div class="col-lg-6">
						<select id="sel_years" class="form-control"></select>
					</div>
					<div class="col-lg-6">
						<select id="sel_months" class="form-control">
							<option value="01">1월</option>
							<option value="02">2월</option>
							<option value="03">3월</option>
							<option value="04">4월</option>
							<option value="05">5월</option>
							<option value="06">6월</option>
							<option value="07">7월</option>
							<option value="08">8월</option>
							<option value="09">9월</option>
							<option value="10">10월</option>
							<option value="11">11월</option>
							<option value="12">12월</option>
						</select>
					</div>
				</div>
			</div>

			<div class="col-lg-1" style="padding-top:10px;">
				시작일자 : 
			</div>
			<div class="col-lg-1">
				<div class="input-group">
					<input type="text" id="dtp_startDate" class="form-control" autocomplete="no" disabled>
                    <span class="input-group-addon">
				        <i class="fa fa-calendar"></i>
			        </span>
                </div>
			</div>
			<div class="col-lg-1" style="padding-top:10px">
				종료일자 : 
			</div>
			<div class="col-lg-1">
				<div class="input-group">
					<input type="text" id="dtp_closeDate" class="form-control" autocomplete="no"  disabled>
					<span class="input-group-addon">
				        <i class="fa fa-calendar"></i>
			        </span>
				</div>
			</div>
			<div class="col-lg-1">
				<input type="button" id="btn_excel" onclick="fun_selectCalculateMember();" class="btn btn-info btn-xs" value="조회">
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
				    &nbsp;정산
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
							<input type="button" id="btn_clipboard" onclick="fun_copyToClipboard();" class="btn btn-info btn-sm" value="클립보드" />
                        </span>
                    </div>
                    <div id="collapse3" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="dataTable_wrapper">
                                <table id="jdtListCalculate" class="table table-striped table-bordered table-hover">
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
	<textarea id="txt_tempTextArea" style="height:300px; width:600px;opacity:0"></textarea>
</form>
