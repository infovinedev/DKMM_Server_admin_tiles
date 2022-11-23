<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="../assets/js/cryptoJs/aes.js"></script>
<script>

var jdtListParcelInfo;
var jdtListWinner;

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
		$('#jdtListParcelInfo').dataTable().fnAdjustColumnSizing();              //페이지 Resize시 dataTable 재설정
		$('#jdtListWinner').dataTable().fnAdjustColumnSizing();
	});

	$('.panel').on('shown.bs.collapse', function (e) {
		$('#jdtListParcelInfo').dataTable().fnAdjustColumnSizing();
		$('#jdtListWinner').dataTable().fnAdjustColumnSizing();
	});

	fun_initializeClickEvent();

	fun_setJdtListWinner();

	
	fun_selectPromotionStartDate(function(){});
	fun_selectPromotionCloseDate(function(){});
	// $("#sel_mdn").val("서울");
	// $("#txt_businessName").val("사업명테스트");
	// $("#txt_builder").val("건설사테스트");
	// $("#txt_notidate").val("2021.11.30");
	// $("#sel_state").val("청약중");
	//$("#txt_mdn").val("010-5555-4444");

	$("#txt_mdn").on("paste", function(e){
		var pasteObj = (event.clipboardData || window.clipboardData);
//		console.log("전화번호들을 붙여넣기 했습니다", pasteObj.getData('text/html'));
		//console.log("전화번호들을 붙여넣기 했습니다", pasteObj.getData('text'));
		
		var texts = pasteObj.getData('text').split('\r\n');
		var table = $("#jdtListWinner").DataTable();
		table.rows('.selected').nodes().to$().removeClass('selected');
		check_hasSel = true;
		var temp_alert = ""; 
		for(var i=0; i<texts.length; i++){
			if(texts[i]!=undefined){
				var mdn = texts[i].replaceAll("-", "");
				if(mdn!=""){
					mdn = mid(mdn, 0, 3) + "-" + mid(mdn, 3, 4) + "-" + mid(mdn, 7, 4);
					var patternTel = /^\d{2,3}-\d{3,4}-\d{4}$/;
					if(!patternTel.test(mdn)){
						$("#txt_mdn").focus();
						alert("전화번호 형식은 xxx-xxxx-xxxx입니다");
						return false;
					}
					var insertDatatable = true;
					for(var j=0; j<table.rows()[0].length; j++){
						var tableMdn = table.rows(j).data()[0].mdn;
						if(tableMdn == mdn){
							temp_alert += mdn + "\n";
							insertDatatable = false;
						}
					}
					if(insertDatatable){
						table.row.add({
							"<input type='checkbox' id='cbx_selectAll' onclick='fun_selectAllJdtListWinner();'></input>": ""
							, "pro_yyyy":$("#sel_years option:selected").val()
							, "pro_mm":$("#sel_months option:selected").val()
							, "mdn": mdn
							, "tempEmpty":""
						}).draw();
					}
				}
			}
		}
		if(temp_alert!=""){
			alert(temp_alert + "동일한 전화번호가 있습니다\n테이블에 삽입되지 않았습니다");
		}
		setTimeout(function(){
			$("#txt_mdn").val("");
		}, 300);
	});
});


function fun_selectPromotionStartDate(callback){
	var inputData = { "codeGroup" : "promotion_date", "codeValue" : "start_date" };
	
	fun_ajaxPostSend("/admin/select/realestate/codes.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			var tempDate = tempResult.codeDescription;
			var tempMonth = parseInt(mid(tempDate, 4, 2)) - 2;
			var tempDate = new Date(mid(tempDate, 0, 4), tempMonth, mid(tempDate, 6, 2), 0, 0, 0, 0);
			$("#dtp_startDate").datepicker( "setDate", tempDate );
			callback();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}


function fun_selectPromotionCloseDate(callback){
	var inputData = { "codeGroup" : "promotion_date", "codeValue" : "close_date" };
	
	fun_ajaxPostSend("/admin/select/realestate/codes.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			var tempDate = tempResult.codeDescription;
			var tempMonth = parseInt(mid(tempDate, 4, 2)) - 2;
			var tempDate = new Date(mid(tempDate, 0, 4), tempMonth, mid(tempDate, 6, 2), 0, 0, 0, 0);
			$("#dtp_closeDate").datepicker( "setDate", tempDate );
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

	var tempToday = new Date();
	var tempYears = tempToday.toISOString().substring(0, 4);
	var tempMonths = tempToday.getMonth();
	//이전 달을 불러와야 함
	switch(tempMonths){
	case 0:
		tempYears = parseInt(tempYears) - 1;
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

	$("#txt_mdn").mask("999-9999-9999", {'translation': {0: {pattern: /[0-9*]/}}});

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
				$("#dtp_visitDate").val(date);
				
				$("#txt_postCode").val('');
				$("#txt_address").val('');
				$("#txt_addressDetail").val('');
				$("#txt_headerRemarks").val('');
				$("#rdi_sex1").prop('checked', true);
				$("#cbx_age").val('5');
				
				var t = $("#jdtListWinner").dataTable();
				t.fnClearTable();
				setTimeout(function () {
					t.fnAdjustColumnSizing();
				}, 200);
				
				fun_changeAfterinit();
			} else {
				$("#jdtListParcelInfo tbody tr").removeClass('selected');
				$("#cbx_selectAll").attr('checked', false);         // 전체선택 체크 해제
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
	$('#jdtListWinner').delegate('tr', 'click', function () {
		// 빈테이블이 아닐때
		if (this.innerText != "데이터가 없습니다.") {
			var chk = $(this).hasClass('selected');
			if (chk) {
				$(this).removeClass('selected');
				this.children[0].lastChild.checked = false;
				//$(this)[0].children(0).lastChild.checked = false;
				fun_changeAfterinit();
			} else {
				$("#jdtListWinner tbody tr").removeClass('selected');
				$("#cbx_selectAll").attr('checked', false);         // 전체선택 체크 해제
				$("input[name='chk-row']").prop('checked', false);  // 선택 줄 외 체크 해제
				$(this).addClass('selected');
				
				this.children[0].lastChild.checked = true;
				//$(this)[0].children(0).lastChild.checked = true;
				fun_setJdtListWinnerToTextbox();   // 선택한 줄 값 라인에 입력
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
		var oTable = $("#jdtListWinner").DataTable();
		var t = $("#jdtListWinner").dataTable();
		
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
function fun_setJdtListWinner() {
	jdtListWinner = $("#jdtListWinner").DataTable({
		"columns": [
			{ 
				//"title": "<input type='checkbox' id='cbx_selectAll' onclick='fun_SelectAll_jdt_ListMain();' class='ace' />"
				"title": "<input type='checkbox' id='cbx_selectAll' onclick='fun_selectAllJdtListWinner();'></input>"
				,"data": null
				, "width": "20px"
				, "defaultContent": "<input type='checkbox' name='chk-row'></input>"
				, "sortable": false
			}   
			, { "title": "프로모션 연도", "data": "pro_yyyy"}
			, { "title": "프로모션 월", "data": "pro_mm"}
			, { "title": "전화번호", "data": "mdn"}
			, { "title": "", "data": "tempEmpty"}
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
				, "class": "dt-head-center dt-body-center dtPercent15"
			}
			, {
				"targets": [2]
				, "class": "dt-head-center dt-body-left dtPercent15"
			}
			, {
				"targets": [3]
				, "class": "dt-head-center dt-body-left dtPercent20"
			}
			, {
				"targets": [4]
				, "class": "dt-head-center dt-body-left dtPercent50"
			}
		]
	});

};
//==================================JQuery DataTable Setting 끝==================================


//=== 수정 버튼 이벤트
function fun_clickButtonModifyLine() {
	if (fun_checkValidation()) {
		var table = $("#jdtListWinner").DataTable();
		var row = table.rows('.selected');          // 선택된 로우
		var idx = table.row('.selected').index();   // 선택된 로우의 인덱스값
		var t = $("#jdtListWinner").dataTable();

		if (row == undefined) {
			alert('라인 수정 상태가 아닙니다.');
		} else {
			t.fnUpdate({
				"<input type='checkbox' id='cbx_selectAll' onclick='fun_selectAllJdtListWinner();'></input>": ""
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

function fun_setJdtListWinnerToTextbox() {
	var table = $("#jdtListWinner").DataTable();
	var selRow = table.rows('.selected').data()[0];

	if (selRow != undefined) {
		$("#sel_years").val(selRow.pro_yyyy)
		$("#sel_months").val(selRow.pro_mm)
		$("#txt_mdn").val(selRow.mdn)
	} else {
		//table.rows('.selected').removeClass('selected');
		table.rows('.selected').nodes().to$().removeClass('selected');
	}
	
};


//=== 추가 버튼 이벤트
function fun_clickButtonAddLine() {
	if (fun_checkValidation()) {
		var table = $("#jdtListWinner").DataTable();
		
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
				"<input type='checkbox' id='cbx_selectAll' onclick='fun_selectAllJdtListWinner();'></input>": ""
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
	
	
	var table = $("#jdtListWinner").DataTable();
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
	$("#txt_mdn").val('');
};	


//=== 전체선택 체크시 이벤트
function fun_selectAllJdtListWinner() {
	var cbx_selectAll = $("#cbx_selectAll").is(':checked');             // 전체선택 체크시 true
	var tr = $("#jdtListWinner tbody tr");

	if (tr[0].innerText != "데이터가 없습니다.") {                              // Row에 추가된 값이 있을시
		if (cbx_selectAll) {
			//$("#Content_jdt_ListMain tbody tr").addClass('selected');           // 클래스 추가
			$("input[name='chk-row']").prop('checked', true);
			$("#jdtListWinner tbody tr").removeClass('selected');            // .selected 클래스 제거
		} else {
			//$("#Content_jdt_ListMain tbody tr").removeClass('selected');        // 클래스 삭제
			$("input[name='chk-row']").prop('checked', false);
			$("#jdtListWinner tbody tr").removeClass('selected');            // .selected 클래스 제거
		}
		fun_changeAfterinit();

	} else {                                                                    // Row에 추가된 값이 없을시
		$("#cbx_selectAll").attr('checked', false);                     // 전체선택 체크 해제
	}
};




function fun_validationSaveChk(){
	var chk = 0;
	var alert_temp = "";
	
	var table = $("#jdtListWinner").DataTable();
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

var key = CryptoJS.enc.Utf8.parse("${crypto}");
function fun_clickButtonOfInsertParcelInfo() {
	var password = $("#txt_adminPassword").val();
	var shaPassword = "";
	if(password != ""){
		shaPassword = hex_sha512(password);
	}
	if(password==''||password==null){
		$("#txt_adminPassword").focus();
		alert('로그인 비밀번호를 입력해주세요');
		return false;
	}
	
	if(fun_validationSaveChk()){
	}
	else{
		return false;
	}
	//=== Save Line Data
	var inputData = $('#jdtListWinner').tableToJSON({"headings":["idx", "pro_yyyy", "pro_mm", "mdn", "iv"], "ignoreEmptyRows":true});
	
	for(var i=0; i<inputData.length; i++){
		var bytes = [];
		var windowIv = window.crypto.getRandomValues(new Uint8Array(16));
		for (var j=0; j<windowIv.length; ++j) {
			var code = windowIv[j];
			 bytes = bytes.concat([code]);
		}
		var wordIv = byteArrayToWordArray(windowIv);
		
		var encryptMdn = CryptoJS.AES.encrypt(inputData[i].mdn, key, { iv: wordIv, mode: CryptoJS.mode.CBC, padding: CryptoJS.pad.Pkcs7 });
		//console.log('encrypted : ' + encryptMdn.toString() + ", iv : " + wordIv);
		var wordByte = wordArrayToByteArray(wordIv, wordIv.length);
		inputData[i].iv = wordByte;

		var data = CryptoJS.AES.decrypt(encryptMdn, key, { iv: wordIv });
		//console.log('decrypted : ', hex2a(data.toString()) + ", iv : " + wordIv);

		inputData[i].mdn = encryptMdn.ciphertext.toString(CryptoJS.enc.Base64)
	}

	var inputData = {"password":shaPassword, "promotionWinner": inputData};

	fun_ajaxPostSend("/realestate/insert/promotionWinner.do", inputData, true, function(msg){
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
							var mdn = msgResult[i].mdn;
							var iv = msgResult[i].iv;
							var bytes = [];
							var arrayBuffer = new ArrayBuffer(16);
							for (var j=0; j< iv.length; ++j) {
								var code = iv[j];
								bytes = bytes.concat([code]);
							}
							var arrayBuffer = new Uint8Array(bytes);
							var wordIv = byteArrayToWordArray(arrayBuffer);
							var data = CryptoJS.AES.decrypt(mdn, key, { iv: wordIv });
							cantSaveParcel += "전화번호 : " + hex2a(data.toString()) + "\n";
							
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
					$("#txt_adminPassword").val('');
					$("#txt_adminPassword").focus();
					alert("비밀번호가 다릅니다.");
					break;
				case "0002":
					$("#txt_adminPassword").val('');
					$("#txt_adminPassword").focus();
					alert("저장 할 데이터가 없습니다.");
			}
			// var t = $("#jdtListWinner").dataTable();
			// t.fnClearTable();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
	return false;
};

function fun_test(){
	var key = CryptoJS.enc.Utf8.parse("D9B986E97535792DFA3AE0585B81BB6C");
	var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	var randomIv="";
	for (var i = 0; i < 16; i++){
		randomIv += possible.charAt(Math.floor(Math.random() * possible.length));
	}
	
	var bytes = []; // char codes
	var windowIv = window.crypto.getRandomValues(new Uint8Array(16));
	for (var i = 0; i < windowIv.length; ++i) {
		var code = windowIv[i];
			bytes = bytes.concat([code]);
	}
	var wordIv = byteArrayToWordArray(windowIv);

	var id = CryptoJS.AES.encrypt("kdh@infovine.co.kr", key, { iv: wordIv, mode: CryptoJS.mode.CBC, padding: CryptoJS.pad.Pkcs7 });
	console.log('encrypted : ',id.toString());
	var name = CryptoJS.AES.encrypt("매니저", key, { iv: wordIv, mode: CryptoJS.mode.CBC, padding: CryptoJS.pad.Pkcs7 });
	var wordByte = wordArrayToByteArray(wordIv, wordIv.length);

	var data = CryptoJS.AES.decrypt(id, key, { iv: wordIv });
	
	console.log('decrypted : ',hex2a(data.toString()));
	console.log(id.ciphertext.toString());
	console.log(id.toString());
	console.log(id.ciphertext.toString(CryptoJS.enc.Base64));


	var inputData = {"id": id.ciphertext.toString(CryptoJS.enc.Base64), "name":name.ciphertext.toString(CryptoJS.enc.Base64), "iv":wordByte, "encrypt":true};
	console.log(inputData);



}

function fun_outputExcel(){
	location.href = "/realestate/event/promotion.do?startDate=" + $("#dtp_startDate").val() + "&closeDate=" + $("#dtp_closeDate").val();
}
</script>



<form id="membership" method="post" enctype="multipart/form-data" action="">
   	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header" style="font-size:24px">이벤트 당첨자관리</h1>
	    </div>
	    <!-- /.col-lg-12 -->
    </div>
	
	<div class="space-6"></div>
	
	<!--자동완성 제거목적-->
	<div class="row" id="div_row1">
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
				<input type="button" id="btn_excel" onclick="fun_outputExcel();" class="btn btn-info btn-xs" value="엑셀출력">
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
				    &nbsp;당첨자 등록
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                            
                        </span>
                    </div>
                    <div id="collapse3" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="dataTable_wrapper">
                                <table id="jdtListWinner" class="table table-striped table-bordered table-hover">
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
				    &nbsp;당첨자
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                            
                        </span>
                    </div>
                    <div id="collapse4" class="panel-collapse collapse in">
                        <div class="panel panel-body">
                            <div class="row form-group form-group-sm">
                                <div class="col-lg-1 col-md-2" style="padding-top:4px;">
									프로모션 연도
                                </div>
                                <div class="col-lg-2 col-md-4">
									<select id="sel_years" class="form-control">
									</select>
                                </div>
                                <div class="hidden-lg hidden-xs col-md-12">
                                    <p></p>
                                </div>
                                <div class="col-lg-1 col-md-2" style="padding-top:4px;">
                                    프로모션 월
                                </div>
                                <div class="col-lg-2 col-md-4">
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
                                <div class="col-lg-1 col-md-2" style="padding-top:4px;">
                                    전화번호
                                </div>
                                <div class="col-lg-2 col-md-4">
                                	<input type="text" ID="txt_mdn" class="form-control" placeholder="010-5555-4444" onkeyup="">
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
			<div class="col-lg-1 col-sm-2">로그인<br>비밀번호</div>
			<div class="col-lg-2 col-sm-4">
				<input type="password" id="txt_adminPassword" class="form-control">
			</div>
			<div class="col-lg-4 col-md-4">
				<button type="button" id="btn_Save" class="btn btn-white btn-default btn-bold" onclick="return fun_clickButtonOfInsertParcelInfo();">
					<i class="ace-icon fa fa-clipboard green"></i>
					저장
				</button>
				<!-- <button type="button" id="btn_Delete" class="btn btn-white btn-warning btn-bold" onclick="return ();" >
					<i class="ace-icon fa fa-trash-o bigger-120 red"></i>
					
				</button> -->
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</div>
			<div class="col-lg-4 col-md-4" style="text-align: right">
				 
			</div>
		</div>
	</div>

</form>
