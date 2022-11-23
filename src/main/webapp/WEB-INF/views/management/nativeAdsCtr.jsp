<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="../assets/js/cryptoJs/aes.js"></script>
<script>

var jdtListNativeAdsCtr;

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
		$('#jdtListNativeAdsCtr').dataTable().fnAdjustColumnSizing();
	});

	$('.panel').on('shown.bs.collapse', function (e) {
		$('#jdtListNativeAdsCtr').dataTable().fnAdjustColumnSizing();
	});

	fun_selectDate(function(){});
	
	fun_initializeClickEvent();

	fun_setJdtListCalculate();

	//var table = $("#jdtListNativeAdsCtr").DataTable();
	
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

function fun_selectDate(callback){
	var inputData = {  };
	
	fun_ajaxPostSend("/management/select/date.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			$("#dtp_startDate").datepicker( "setDate", tempResult.startDate );
			$("#dtp_closeDate").datepicker( "setDate", tempResult.closeDate );
			callback();
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


	$('#btn_DeleteSelect').click(function () {
		var oTable = $("#jdtListNativeAdsCtr").DataTable();
		var t = $("#jdtListNativeAdsCtr").dataTable();
		
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
	jdtListNativeAdsCtr = $("#jdtListNativeAdsCtr").DataTable({
		"columns": [
			{"title" :"일자","data" :"regDay" }	
			//이달의 최신 휴대폰 할인
			, {"title" :"E1_1","data" :"E1_1" }		
			, {"title" :"C1_1","data" :"C1_1" }		
			, {"title" :"CTR1","data" :"CTR1" }
			, {"title" :"R1_1","data" :"R1_1" }
			, {"title" :"CL1","data" :"CL1" }

			//나의 중고폰 시세
			, {"title" :"E1_2","data" :"E1_2" }
			, {"title" :"C1_2","data" :"C1_2" }
			, {"title" :"CTR2","data" :"CTR2" }
			, {"title" :"R1_2","data" :"R1_2" }
			, {"title" :"CL2","data" :"CL2" }

			//요금제 추천
			, {"title" :"E1_3","data" :"E1_3" }
			, {"title" :"C1_3","data" :"C1_3" }
			, {"title" :"CTR3","data" :"CTR3" }
			, {"title" :"R1_3","data" :"R1_3" }
			, {"title" :"CL3","data" :"CL3" }

			//실시간 인기 매물
			, {"title" :"E2_1","data" :"E2_1" }
			, {"title" :"C2_1","data" :"C2_1" }
			, {"title" :"CTR4","data" :"CTR4" }
			, {"title" :"R2_1","data" :"R2_1" }
			, {"title" :"CL4","data" :"CL4" }

			//나의 예산 맟춤 매물
			, {"title" :"E2_2","data" :"E2_2" }
			, {"title" :"C2_2","data" :"C2_2" }
			, {"title" :"CTR5","data" :"CTR5" }
			, {"title" :"R2_2","data" :"R2_2" }
			, {"title" :"CL5","data" :"CL5" }

			//신규청약진행
			, {"title" :"E2_3","data" :"E2_3" }
			, {"title" :"C2_3","data" :"C2_3" }
			, {"title" :"CTR6","data" :"CTR6" }
			, {"title" :"R2_3","data" :"R2_3" }
			, {"title" :"CL6","data" :"CL6" }

			//주식레터 TOPPICK
			, {"title" :"E3_1","data" :"E3_1" }
			, {"title" :"C3_1","data" :"C3_1" }
			, {"title" :"CTR7","data" :"CTR7" }
			, {"title" :"R3_1","data" :"R3_1" }
			, {"title" :"CL7","data" :"CL7" }

			//급등주 TOP10
			, {"title" :"E3_2","data" :"E3_2" }
			, {"title" :"C3_2","data" :"C3_2" }
			, {"title" :"CTR8","data" :"CTR8" }
			, {"title" :"R3_2","data" :"R3_2" }
			, {"title" :"CL8","data" :"CL8" }

			//무료운세
			, {"title" :"E3_3","data" :"E3_3" }
			, {"title" :"C3_3","data" :"C3_3" }
			, {"title" :"CTR9","data" :"CTR9" }
			, {"title" :"R3_3","data" :"R3_3" }
			, {"title" :"CL9","data" :"CL9" }

			//부동산 텍스트 배너(연말정산)
			, {"title" :"E4_1","data" :"E4_1" }
			, {"title" :"C4_1","data" :"C4_1" }
			, {"title" :"CTR10","data" :"CTR10" }
			, {"title" :"R4_1","data" :"R4_1" }
			, {"title" :"CL10","data" :"CL10" }

			//주식 텍스트 배너(연말정산)
			, {"title" :"E4_2","data" :"E4_2" }
			, {"title" :"C4_2","data" :"C4_2" }
			, {"title" :"CTR11","data" :"CTR11" }
			, {"title" :"R4_2","data" :"R4_2" }
			, {"title" :"CL11","data" :"CL11" }

			//통신비안심 텍스트 배너(연말정산)
			, {"title" :"E4_3","data" :"E4_3" }
			, {"title" :"C4_3","data" :"C4_3" }
			, {"title" :"CTR12","data" :"CTR12" }
			, {"title" :"R4_3","data" :"R4_3" }
			, {"title" :"CL12","data" :"CL12" }

			//오토레터 텍스트 배너(연말정산)
			, {"title" :"E4_4","data" :"E4_4" }
			, {"title" :"C4_4","data" :"C4_4" }
			, {"title" :"CTR13","data" :"CTR13" }

			//오토레터(연말정산)
			, {"title" :"E4_5","data" :"E4_5" }
			, {"title" :"C4_5","data" :"C4_5" }
			, {"title" :"CTR14","data" :"CTR14" }

			//주식 이미지 배너(연말정산)
			, {"title" :"E4_6","data" :"E4_6" }
			, {"title" :"C4_6","data" :"C4_6" }
			, {"title" :"CTR15","data" :"CTR15" }
			, {"title" :"R4_6","data" :"R4_6" }
			, {"title" :"CL15","data" :"CL15" }

			//부동산 이미지 배너(연말정산)
			, {"title" :"E4_7","data" :"E4_7" }
			, {"title" :"C4_7","data" :"C4_7" }
			, {"title" :"CTR16","data" :"CTR16" }
			, {"title" :"R4_7","data" :"R4_7" }
			, {"title" :"CL16","data" :"CL16" }

			//통신비 이미지 배너(연말정산)
			, {"title" :"E4_8","data" :"E4_8" }
			, {"title" :"C4_8","data" :"C4_8" }
			, {"title" :"CTR17","data" :"CTR17" }
			, {"title" :"R4_8","data" :"R4_8" }
			, {"title" :"CL17","data" :"CL17" }

			//실시간요금
			//이달의 최신 휴대폰 할인
			, {"title" :"E5_1","data" :"E5_1" }		
			, {"title" :"C5_1","data" :"C5_1" }		
			, {"title" :"CTR18","data" :"CTR18" }
			, {"title" :"R5_1","data" :"R5_1" }
			, {"title" :"CL18","data" :"CL18" }

			//나의 중고폰 시세
			, {"title" :"E5_2","data" :"E5_2" }
			, {"title" :"C5_2","data" :"C5_2" }
			, {"title" :"CTR19","data" :"CTR19" }
			, {"title" :"R5_2","data" :"R5_2" }
			, {"title" :"CL19","data" :"CL19" }

			//요금제 추천
			, {"title" :"E5_3","data" :"E5_3" }
			, {"title" :"C5_3","data" :"C5_3" }
			, {"title" :"CTR20","data" :"CTR20" }
			, {"title" :"R5_3","data" :"R5_3" }
			, {"title" :"CL20","data" :"CL20" }

			//요금제 추천
			, {"title" :"E5_4","data" :"E5_4" }
			, {"title" :"C5_4","data" :"C5_4" }
			, {"title" :"CTR21","data" :"CTR21" }
			, {"title" :"R5_4","data" :"R5_4" }
			, {"title" :"CL21","data" :"CL21" }
		]
		, "paging": false            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "autoWidth": false
		, "scrollY": "300px"
		, "scrollCollapse": true
		, "scrollX": true
		, "scrollXInner": "110%"
		//, "orderClasses": false
		, "order": [[ 0, "asc" ]]
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
			//일자
			{ "targets": [0], "class": "dt-head-center dt-body-center dtPercent15" }

			//이번달 최신 휴대폰 할인
			, { "targets": [1], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [2], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [3], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [4], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [5], "class": "dt-head-center dt-body-center dtPercent5" }
			
			//나의 휴대폰 중고시세
			, { "targets": [6], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [7], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [8], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [9], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [10], "class": "dt-head-center dt-body-center dtPercent5" }
			
			//요금제 추천
			, { "targets": [11], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [12], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [13], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [14], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [15], "class": "dt-head-center dt-body-center dtPercent5" }
			
			//실시간 인기 매물
			, { "targets": [16], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [17], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [18], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [19], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [20], "class": "dt-head-center dt-body-center dtPercent5" }
			
			//나의 예산 맞춤 매물
			, { "targets": [21], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [22], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [23], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [24], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [25], "class": "dt-head-center dt-body-center dtPercent5" }
			
			//신규청약진행
			, { "targets": [26], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [27], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [28], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [29], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [30], "class": "dt-head-center dt-body-center dtPercent5" }
			
			//주식레터 TOP PICK
			, { "targets": [31], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [32], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [33], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [34], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [35], "class": "dt-head-center dt-body-center dtPercent5" }
			
			//급등주 TOP10
			, { "targets": [36], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [37], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [38], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [39], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [40], "class": "dt-head-center dt-body-center dtPercent5" }
			
			//무료운세
			, { "targets": [41], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [42], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [43], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [44], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [45], "class": "dt-head-center dt-body-center dtPercent5" }

			//부동산 텍스트 배너(연말정산) 20220106 추가
			, { "targets": [46], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [47], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [48], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [49], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [50], "class": "dt-head-center dt-body-center dtPercent5" }

			//주식 텍스트 배너(연말정산)
			, { "targets": [51], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [52], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [53], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [54], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [55], "class": "dt-head-center dt-body-center dtPercent5" }

			//통신비안심 텍스트 배너(연말정산)		2022-01-19 추가
			, { "targets": [56], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [57], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [58], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [59], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [60], "class": "dt-head-center dt-body-center dtPercent5" }

			//오토레터 텍스트 배너(연말정산)		2022-01-19 추가
			, { "targets": [61], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [62], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [63], "class": "dt-head-center dt-body-center dtPercent5" }

			//오토레터 이미지 배너(연말정산)
			, { "targets": [64], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [65], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [66], "class": "dt-head-center dt-body-center dtPercent5" }
			
			//주식 이미지 배너(연말정산)
			, { "targets": [67], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [68], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [69], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [70], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [71], "class": "dt-head-center dt-body-center dtPercent5" }

			//부동산 이미지 배너(연말정산)
			, { "targets": [72], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [73], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [74], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [75], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [76], "class": "dt-head-center dt-body-center dtPercent5" }

			//통신비 이미지 배너(연말정산)
			, { "targets": [77], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [78], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [79], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [80], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [81], "class": "dt-head-center dt-body-center dtPercent5" }

			//실시간요금
			//이번달 최신 휴대폰 할인
			, { "targets": [82], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [83], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [84], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [85], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [86], "class": "dt-head-center dt-body-center dtPercent5" }
			
			//나의 휴대폰 중고시세
			, { "targets": [87], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [88], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [89], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [90], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [91], "class": "dt-head-center dt-body-center dtPercent5" }
			
			//요금제 추천
			, { "targets": [92], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [93], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [94], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [95], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [96], "class": "dt-head-center dt-body-center dtPercent5" }

			//통신비안심 버튼
			, { "targets": [97], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [98], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [99], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [100], "class": "dt-head-center dt-body-center dtPercent5" }
			, { "targets": [101], "class": "dt-head-center dt-body-center dtPercent5" }
		]
	});
};
//==================================JQuery DataTable Setting 끝==================================


function fun_selectNativeAdsCtr() {
	$("#txt_tempTextArea").val("");
	var startDate = $("#dtp_startDate").val();
	if(startDate==""){
		$("#dtp_startDate").focus();
		alert("시작 날짜를 입력해주세요.");
		return;
	}
	
	var closeDate = $("#dtp_closeDate").val();
	if(closeDate==""){
		$("#dtp_closeDate").focus();
		alert("종료 날짜를 입력해주세요.");
		return;
	}
	
	$("#btn_clipboard").prop("disabled", true);
	var t = $("#jdtListNativeAdsCtr").dataTable();
	t.fnClearTable();
	
	var inputData = {"startDate":startDate.replaceAll("-", ""), "closeDate": closeDate.replaceAll("-", "")};

	fun_ajaxPostSend("/management/select/nativeAdsCtr.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					if(tempResult.length!=0){
						fun_jdtListdraw(tempResult, function(tempResult){
							setTimeout(function(){
								var tempText = ""; 
								for(var i=0; i<tempResult.length; i++){
									tempText += $("#jdtListNativeAdsCtr tbody tr")[i].innerText + "\n";
								}
								$("#txt_tempTextArea").val(tempText);
								$("#btn_clipboard").prop("disabled", false);
							},600);
						});
						//fun_dataTableAddData("#jdtListNativeAdsCtr", tempResult);
					}
					break;
				case "0001":
					break;
				case "0002":
			}
			// var t = $("#jdtListNativeAdsCtr").dataTable();
			// t.fnClearTable();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
	return false;
};

function fun_jdtListdraw(tempResult, callback){
	var table = $("#jdtListNativeAdsCtr").DataTable();
	for(var i=0; i<tempResult.length; i++){
		table.row.add({
			//이번달 최신 휴대폰 할인
			"regDay" : tempResult[i].reg_day
			, "E1_1" : tempResult[i].e1_1		
			, "C1_1" : tempResult[i].c1_1		
			, "CTR1" : parseFloat(tempResult[i].ctr1).toFixed(2)
			, "R1_1" : tempResult[i].r1_1
			, "CL1" : parseFloat(tempResult[i].cl1).toFixed(2)

			//나의 휴대폰 중고시세
			, "E1_2" : tempResult[i].e1_2
			, "C1_2" : tempResult[i].c1_2
			, "CTR2" : parseFloat(tempResult[i].ctr2).toFixed(2)
			, "R1_2" : tempResult[i].r1_2
			, "CL2" : parseFloat(tempResult[i].cl2).toFixed(2)

			//요금제 추천
			, "E1_3" : tempResult[i].e1_3
			, "C1_3" : tempResult[i].c1_3
			, "CTR3" : parseFloat(tempResult[i].ctr3).toFixed(2)
			, "R1_3" : tempResult[i].r1_3
			, "CL3" : parseFloat(tempResult[i].cl3).toFixed(2)

			//실시간 인기 매물
			, "E2_1" : tempResult[i].e2_1
			, "C2_1" : tempResult[i].c2_1
			, "CTR4" : parseFloat(tempResult[i].ctr4).toFixed(2)
			, "R2_1" : tempResult[i].r2_1
			, "CL4" : parseFloat(tempResult[i].cl4).toFixed(2)

			//나의 예산 맞춤 매물
			, "E2_2" : tempResult[i].e2_2
			, "C2_2" : tempResult[i].c2_2
			, "CTR5" : parseFloat(tempResult[i].ctr5).toFixed(2)
			, "R2_2" : tempResult[i].r2_2
			, "CL5" : parseFloat(tempResult[i].cl5).toFixed(2)

			//신규청약진행
			, "E2_3" : tempResult[i].e2_3
			, "C2_3" : tempResult[i].c2_3
			, "CTR6" : parseFloat(tempResult[i].ctr6).toFixed(2)
			, "R2_3" : tempResult[i].r2_3
			, "CL6" : parseFloat(tempResult[i].cl6).toFixed(2)

			//주식레터 TOP PICK
			, "E3_1" : tempResult[i].e3_1
			, "C3_1" : tempResult[i].c3_1
			, "CTR7" : parseFloat(tempResult[i].ctr7).toFixed(2)
			, "R3_1" : tempResult[i].r3_1
			, "CL7" : parseFloat(tempResult[i].cl7).toFixed(2)

			//급등주 TOP10
			, "E3_2" : tempResult[i].e3_2
			, "C3_2" : tempResult[i].c3_2
			, "CTR8" : parseFloat(tempResult[i].ctr8).toFixed(2)
			, "R3_2" : tempResult[i].r3_2
			, "CL8" : parseFloat(tempResult[i].cl8).toFixed(2)

			//무료운세
			, "E3_3" : tempResult[i].e3_3
			, "C3_3" : tempResult[i].c3_3
			, "CTR9" : parseFloat(tempResult[i].ctr9).toFixed(2)
			, "R3_3" : tempResult[i].r3_3
			, "CL9" : parseFloat(tempResult[i].cl9).toFixed(2)

			//부동산 텍스트 배너(연말정산) 20220106 추가
			, "E4_1" : tempResult[i].e4_1
			, "C4_1" : tempResult[i].c4_1
			, "CTR10" : parseFloat(tempResult[i].ctr10).toFixed(2)
			, "R4_1" : tempResult[i].r4_1
			, "CL10" : parseFloat(tempResult[i].cl10).toFixed(2)

			//주식 텍스트 배너(연말정산)
			, "E4_2" : tempResult[i].e4_2
			, "C4_2" : tempResult[i].c4_2
			, "CTR11" : parseFloat(tempResult[i].ctr11).toFixed(2)
			, "R4_2" : tempResult[i].r4_2
			, "CL11" : parseFloat(tempResult[i].cl11).toFixed(2)

			//통신비안심 텍스트 배너(연말정산)		2022-01-19 추가
			, "E4_3" : tempResult[i].e4_3
			, "C4_3" : tempResult[i].c4_3
			, "CTR12" : parseFloat(tempResult[i].ctr12).toFixed(2)
			, "R4_3" : tempResult[i].r4_3
			, "CL12" : parseFloat(tempResult[i].cl12).toFixed(2)

			//오토레터 텍스트 배너(연말정산)		2022-01-19 추가
			, "E4_4" : tempResult[i].e4_4
			, "C4_4" : tempResult[i].c4_4
			, "CTR13" : parseFloat(tempResult[i].ctr13).toFixed(2)

			//오토레터 이미지 배너(연말정산)
			, "E4_5" : tempResult[i].e4_5
			, "C4_5" : tempResult[i].c4_5
			, "CTR14" : parseFloat(tempResult[i].ctr14).toFixed(2)
			
			//주식 이미지 배너(연말정산)
			, "E4_6" : tempResult[i].e4_6
			, "C4_6" : tempResult[i].c4_6
			, "CTR15" : parseFloat(tempResult[i].ctr15).toFixed(2)
			, "R4_6" : tempResult[i].r4_6
			, "CL15" : parseFloat(tempResult[i].cl15).toFixed(2)

			//부동산 이미지 배너(연말정산)
			, "E4_7" : tempResult[i].e4_7
			, "C4_7" : tempResult[i].c4_7
			, "CTR16" : parseFloat(tempResult[i].ctr16).toFixed(2)
			, "R4_7" : tempResult[i].r4_7
			, "CL16" : parseFloat(tempResult[i].cl16).toFixed(2)

			//통신비 이미지 배너(연말정산)
			, "E4_8" : tempResult[i].e4_8
			, "C4_8" : tempResult[i].c4_8
			, "CTR17" : parseFloat(tempResult[i].ctr17).toFixed(2)
			, "R4_8" : tempResult[i].r4_8
			, "CL17" : parseFloat(tempResult[i].cl17).toFixed(2)

			//실시간요금
			//이번달 최신 휴대폰 할인
			, "E5_1" : tempResult[i].e5_1		
			, "C5_1" : tempResult[i].c5_1		
			, "CTR18" : parseFloat(tempResult[i].ctr18).toFixed(2)
			, "R5_1" : tempResult[i].r5_1
			, "CL18" : parseFloat(tempResult[i].cl18).toFixed(2)

			//나의 휴대폰 중고시세
			, "E5_2" : tempResult[i].e5_2
			, "C5_2" : tempResult[i].c5_2
			, "CTR19" : parseFloat(tempResult[i].ctr19).toFixed(2)
			, "R5_2" : tempResult[i].r5_2
			, "CL19" : parseFloat(tempResult[i].cl19).toFixed(2)

			//요금제 추천
			, "E5_3" : tempResult[i].e5_3
			, "C5_3" : tempResult[i].c5_3
			, "CTR20" : parseFloat(tempResult[i].ctr20).toFixed(2)
			, "R5_3" : tempResult[i].r5_3
			, "CL20" : parseFloat(tempResult[i].cl20).toFixed(2)

			//통신비안심 버튼
			, "E5_4" : tempResult[i].e5_4
			, "C5_4" : tempResult[i].c5_4
			, "CTR21" : parseFloat(tempResult[i].ctr21).toFixed(2)
			, "R5_4" : tempResult[i].r5_4
			, "CL21" : parseFloat(tempResult[i].cl21).toFixed(2)
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
			<div class="col-lg-1" style="padding-top:10px;">
				시작일자 : 
			</div>
			<div class="col-lg-1">
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
			<div class="col-lg-1">
				<div class="input-group">
					<input type="text" id="dtp_closeDate" class="form-control" autocomplete="no">
					<span class="input-group-addon">
				        <i class="fa fa-calendar"></i>
			        </span>
				</div>
			</div>
			<div class="col-lg-1">
				<input type="button" id="btn_excel" onclick="fun_selectNativeAdsCtr();" class="btn btn-info btn-xs" value="조회">
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
                                <table id="jdtListNativeAdsCtr" class="table table-striped table-bordered table-hover">
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
