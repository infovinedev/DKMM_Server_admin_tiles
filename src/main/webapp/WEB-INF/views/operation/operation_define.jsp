<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 -->
<script>
var defineListInfo;

$(document).ready(function () {
	var ua = navigator.userAgent;
	var checker = {
		iphone: ua.match(/(iPhone|iPod|iPad)/),
		blackberry: ua.match(/BlackBerry/),
		android: ua.match(/Android/)
	};
	
	$(window).bind('resize', function () {
		if (checker.android == null || checker.android == "" || checker.android == "null") {
		}
	});
	
	
	fun_setDefineListInfo();
	fun_selectCommonCode();
	
	$("#userListLength").change(function(){
		var length = $("#userListLength").val();
		$("#defineListInfo").DataTable().page.len(length).draw();
	});
	
   
    $("#txt_searchText").on('keyup click', function () {
		searchDataTable();	   
	});
	
	$("#chk_searchTable").on('keyup click', function () {
		searchDataTable();
	});
	
	$("#sel_workCond").on('change', function () {
		fun_search();
	});
	
   $("#endDt_check").on("click", function(){
     	var today = c21.date_today("yyyy-MM-dd");
     	if($(this).is(":checked")){
     		$("#sel_add_limitYn").val("N").prop("selected", true);
     		$("#txt_add_limitYn").val("미사용");
     		
     		/** 기간 무제한 체크 시 시작일 오늘날짜로 설정 */
     		$("#txt_add_startDt").val(today);
     		$("#txt_add_startDt").attr("readonly",true);
     		$("#txt_add_startDt").datepicker("disable");
     		/** 기간 무제한 체크 시 종료일 29991231 설정 */
     		$("#txt_add_endDt").val('2999-12-31');
     		$("#txt_add_endDt").attr("readonly",true);
     		$("#txt_add_endDt").datepicker("disable");
     	}else{
     		$("#sel_add_limitYn").val("Y").prop("selected", true);
     		$("#txt_add_limitYn").val("사용");
     		
     		$("#txt_add_startDt").val('');
     		$("#txt_add_startDt").removeAttr("readonly");
     		$("#txt_add_startDt").datepicker("enable");
     		$("#txt_add_endDt").val('');
     		$("#txt_add_endDt").removeAttr("readonly");
     		$("#txt_add_endDt").datepicker("enable");
     	}
   });
   
});

function searchDataTable(){
	 if($('#chk_searchTable').is(':checked')){
	      $("#defineListInfo").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	   }
	else{
		$("#defineListInfo").DataTable().search("").draw();
	}
}

//콤보값 셋팅
function fun_selectCommonCode(){
	var codeGroup = "user_action";
	
	var inputData = {"codeGroup": codeGroup};
	
	fun_ajaxPostSend("/common/select/serviceCodeList.do", inputData, true, function(msg){
		if(msg!=null){
			var tempResult = JSON.parse(msg.result);
			$('#sel_workCond').append($('<option></option>').val("").html("선택")); //main화면 달성조건
			$('#sel_add_workCondition').append($('<option></option>').val("").html("선택")); //등록화면 달성조건
			$.each(tempResult, function (key, value) {
				$('#sel_workCond').append($('<option></option>').val(value.codeValue).html(value.codeName));
				$('#sel_add_workCondition').append($('<option></option>').val(value.codeValue).html(value.codeName));
			});
		}
	});
}


function fun_search(){
	var workCondition = $("#sel_workCond").val();
	var searchText = "";//$("#txt_searchText").val();
	var searchStartDt = $("#search_startDt").val();
	var searchEndDt = $("#search_endDt").val();
	var inputData = {"workCondition": workCondition, "searchText": searchText, "searchStartDt": searchStartDt,"searchEndDt": searchEndDt};
	
	$('#chk_searchTable').prop('checked', false);
	searchDataTable();
	
	fun_ajaxPostSend("/define/select/defineWorkList.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			for (let i = 0; i < tempResult.length; i++) {
				tempResult[i].listIndex = i + 1
			}
			
			fun_dataTableAddData("#defineListInfo", tempResult);
		}
	});
}

//text값 공백처리
function fun_reset(type){
	$("#txt_workSeq").val("");             //업적번호
	$("#txt_workNm").val("");              //업적명
	$("#txt_workCondition").val(""); 	  //달성조건
	$("#txt_workCnt").val("");             //달성 상세 요건
	$("#txt_point").val("");               //포인트
	$("#txt_workType").val("");            //업적구분
	$("#txt_nickNm").val("");             //칭호
	$("#txt_nickComment").val("");         //칭호코멘트
	$("#txt_startDt").val("");             //기간 설정
	$("#txt_endDt").val("");               //기간 설정
	$("#txt_workConditionDesc").val("");   //업적설명
	$("#txt_exceptCondition").val("");     //업적제외조건
	$("#txt_zombieYn").val("");            //달성이후누적
	$("#txt_limitYn").val("");             //기간한정여부
	$("#txt_unitTxt").val("");             //단위텍스트
	$("#txt_dispOrder").val("");           //소팅순서
}

//업적관리 등록버튼
function fun_btnInsert() {
	$("#sel_add_limitYn").val("Y").prop("selected", true);
	$("#txt_add_limitYn").val("사용");
	//업적관리에 칭호가 등록되지 않은 칭호들을 selectBox에 보여주기 위함
	var inputData = {};
	fun_ajaxPostSend("/define/select/defineWorkGetNicknm.do", inputData, true, function(msg){
		if(msg!=null){
			var tempResult = JSON.parse(msg.result);
			var seqString = tempResult[0].seqString;
			$("select#sel_add_nickSeq option").remove();
			$('#sel_add_nickSeq').append($('<option></option>').val("").html("선택"));
			for(var i=0; i<tempResult.length; i++){
				var nickSeq = tempResult[i].nickSeq;
				if(nickSeq != null || nickSeq != " "){
						var nickNm = tempResult[i].nickNm;
						$('#sel_add_nickSeq').append($('<option></option>').val(nickSeq).html(nickNm));
				}
			}
		}
	});
	$("#section1_detail_view").css("display", "none");
	$("#section1_inser_view").removeAttr("style");
}

//상세보기
function fun_viewDetail(workSeq) {
	fun_reset();
	$("#section1_inser_view").css("display", "none");
	$("#section1_detail_view").removeAttr("style");
	var inputData = {"workSeq": workSeq};
	fun_ajaxPostSend("/define/select/defineWorkDetail.do", inputData, true, function(msg){
		if(msg!=null){
			var tempResult         = JSON.parse(msg.result);
			var workSeq            = tempResult.workSeq == null ? "" : tempResult.workSeq;                       //업적번호
			var workNm             = tempResult.workNm == null ? "" : tempResult.workNm;                         //업적명
			var workCondition      = tempResult.workCondition == null ? "" : tempResult.workCondition;           //달성조건
			var workCnt            = tempResult.workCnt == null ? "" : tempResult.workCnt;                       //달성 상세 요건
			var point              = tempResult.point == null ? "" : tempResult.point;                           //포인트
			var workType           = tempResult.workType == null ? "" : tempResult.workType;                     //업적구분
			var nickNm            = tempResult.nickNm == null ? "" : tempResult.nickNm;                       //칭호
			var nickComment        = tempResult.nickComment == null ? "" : tempResult.nickComment;               //칭호코멘트
			var startDt            = tempResult.startDt == null ? "" : tempResult.startDt;                       //기간 설정
			var endDt              = tempResult.endDt == null ? "" : tempResult.endDt;                           //기간 설정
			var workConditionDesc  = tempResult.workConditionDesc == null ? "" : tempResult.workConditionDesc;   //업적설명
			var exceptCondition    = tempResult.exceptCondition == null ? "" : tempResult.exceptCondition;       //업적제외조건
			var zombieYn           = tempResult.zombieYn == null ? "" : tempResult.zombieYn;                     //달성이후누적
			var limitYn            = tempResult.limitYn == null ? "" : tempResult.limitYn;                       //기간한정여부
			var unitTxt            = tempResult.unitTxt == null ? "" : tempResult.unitTxt;                       //단위텍스트 
			var dispOrder			= tempResult.dispOrder == null ? "" : tempResult.dispOrder;
			
			if(workCondition == "SELF"){
				workCnt = "-";
			}else if(workCondition == "PMONEY"){
				workCnt = workCnt + "P";
			}else if(workCondition == "PMONEY"){
				workCnt = workCnt
			}else{
				workCnt = workCnt + "회";
			}
			
			$("#txt_workSeq").val(workSeq);
			$("#txt_workNm").val(workNm);
			$("#txt_workCondition").val(workCondition);
			$("#txt_workCnt").val(workCnt);
			$("#txt_point").val(point);
			$("#txt_workType").val(workType);
			$("#txt_nickNm").val(nickNm);
			$("#txt_nickComment").val(nickComment);
			$("#txt_startDt").val(startDt);
			$("#txt_endDt").val(endDt);
			$("#txt_workConditionDesc").val(workConditionDesc);
			$("#txt_exceptCondition").val(exceptCondition);
			$("#txt_zombieYn").val(zombieYn);
			$("#txt_limitYn").val(limitYn);
			$("#txt_unitTxt").val(unitTxt);
			$("#txt_dispOrder").val(dispOrder);
			
		}
	});
}

function fun_setDefineListInfo() {
	defineListInfo = $("#defineListInfo").DataTable({
		"columns": [
			  {"data":  "listIndex"}
			, {"data":  "workNm"}   //업적명
			, {"data": "workConditionNm"}    //달성조건    workCondition
			, {"data": "workCnt"}    //달성상세요건 workCnt
			, {"data": "nickNm"}    //칭호       nickNm
// 			, {"data": "point"}    //포인트     point
			, {"data": "startDt"}    //시작일자
			, {"data": "endDt" }    //정료일자
			, {"data": "zombieYn" }    //달성이후누적 zombieYn
			, {"data": "limitYn" }    //기간한정여부 limitYn
			, {"data": "joinCnt" }    //참여인원    joinCnt
			, {"data": "completeCnt" }    //완료인원    completeCnt
			, {"data": "add" }    //관리
		]
		, "paging": true            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "autoWidth": true
 		, "scrollXInner": "100%"
		, "order": [[ 0, "asc" ]]
		, "deferRender": true                // defer
		, "lengthMenu": [10,20,50]           // Row Setting [-1], ["All"]
		, "lengthChange": true
		, "dom": 't<"bottom"p><"clear">'
		, "language": {
			"search": "검색",
			"lengthMenu": " _MENU_ ",
			"zeroRecords": "데이터가 없습니다.",
			"info": "page _PAGE_ of _PAGES_",
			"infoEmpty": "",
			"infoFiltered": "(filtered from _MAX_ total records)",
			"paginate": {
				"next": ">",
				"previous": "<"
		}
		}
		, "columnDefs": [
			{
				"targets": [0]
				, "class": "text-center"
			}
			 ,
			{
				"targets": [1]
				, "class": "text-center"
			}
			 , {
				"targets": [2]
				, "class": "text-left"
				, "render": function (data, type, row) {
					var insertTr = "";
					if ( row.workCondition == "CUSTOM001" && row.limitYn == 'Y' ){
						insertTr = '<a href="javascript:void(0)" onclick="fun_start_Excel(\'promotion1\', \'' + row.workSeq + '\', \'' + row.workNm + '\' )"><font color="blue"><b>'+row.workConditionNm+'</b></font></a>';
					}
					else{
						insertTr = row.workConditionNm;	
					}
					return insertTr;
                }
			}
			, {
				"targets": [3]
				, "class": "text-center"
				, "render": function (data, type, row) {
					var insertTr = row.workCnt + "회";
					return insertTr;
                }
			}
			, {
				"targets": [4]
				, "class": "text-center"
			}
			, {
				"targets": [5]
				, "class": "text-center"
				, "render": function (data, type, row) {
					return getDateFormat2(row.startDt);
                }
			}
			, {
				"targets": [6]
				, "class": "text-center"
				, "render": function (data, type, row) {
					return getDateFormat2(row.endDt);
                }
			}
			, {
				"targets": [7]
				, "class": "text-center"
			}
			, {
				"targets": [8]
				, "class": "text-center"
			}
			, {
				"targets": [9]
				, "class": "text-center"
				, "render": function (data, type, row) {
					var joinCnt = row.joinCnt;
					var insertTr = "";
					if ( joinCnt == "" || joinCnt == "0" ){
						insertTr = joinCnt;
					}else{
						insertTr = '<a href="javascript:void(0)" onclick="fun_start_Excel(\'join\', \'' + row.workSeq + '\', \'' + row.workNm + '\' )"><font color="blue"><b>'+joinCnt+'</b></font></a>';
					}
					return insertTr;
                }
			}
			, {
				"targets": [10]
				, "class": "text-center"
				, "render": function (data, type, row) {
					var completeCnt = row.completeCnt;
					var insertTr = "";
					if ( completeCnt == "" || completeCnt == "0" ){
						insertTr = completeCnt;
					}else{
						insertTr = '<a href="javascript:void(0)" onclick="fun_start_Excel(\'complete\', \'' + row.workSeq + '\', \'' + row.workNm + '\' )"><font color="blue"><b>'+completeCnt+'</b></font></a>';
					}
					return insertTr;
                }
			}
			, {
				"targets": [11]
				, "class": "text-center"
				, "render": function (data, type, row) {
					var msg = row.workSeq;
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_viewDetail(' + msg + ')">상세</button>'; 
					return insertTr;
                }
			}
		]
	});
	
	fun_search();
};

//업적 숨김여부 update처리
function fun_defineHiding(){
	var upWorkSeq       = $("#txt_workSeq").val();
	var upWorkNm        = $("#txt_workNm").val();
	var upWorkCondition = $("#txt_workCondition").val();
	var result = confirm('숨김처리 하시겠습니까?');
	
	var inputData = {"upWorkSeq": upWorkSeq, "upWorkNm": upWorkNm, "upWorkCondition": upWorkCondition};
	if(result){	
		fun_ajaxPostSend("/define/save/defineWorkUpdate.do", inputData, true, function(msg){
			if(msg.errorMessage !=null){
				var message = msg.errorMessage;
				if(message == "success"){
					alert("정상적으로 처리되었습니다.");
					$("#exampleModalScrollable").modal('hide');
					fun_search();
				}else if(message == "error"){
					alert("정상적으로 처리되지 않았습니다.");
				}
			}
		});
	}
}

//업적관리 등록
function fun_btnDefineinsert() {
	var workSeq = $("#txt_add_workSeq").val();
	var workNm = $("#txt_add_workNm").val();
	var workCondition = $("#sel_add_workCondition").val();
	var workCnt = $("#txt_add_workCnt").val();
	var point = $("#txt_add_point").val();
	var workType = $("#sel_add_workType").val();
	var nickSeq = $("#sel_add_nickSeq").val();
	var startDt = $("#txt_add_startDt").val();
	var endDt = $("#txt_add_endDt").val();
	var startDt = $("#txt_add_startDt").val() == null ? "" : $("#txt_add_startDt").val().replaceAll("-", "");
	var endDt   = $("#txt_add_startDt").val() == null ? "" : $("#txt_add_endDt").val().replaceAll("-", "");
	var workConditionDesc = $("#txt_add_workConditionDesc").val();
	var exceptCondition = $("#txt_add_exceptCondition").val();
	var zombieYn = $("#sel_add_zombieYn").val();
	var limitYn = $("#sel_add_limitYn").val();
	var unitTxt = $("#txt_add_unitTxt").val();
	var dispOrder = $("#txt_add_dispOrder").val();
	
	var result = confirm('업적 등록하시겠습니까?');
	
	var inputData = {"workSeq": workSeq, "workNm": workNm, "workCondition": workCondition,"workCnt": workCnt, "point": point, "workType": workType
					 ,"nickSeq": nickSeq, "startDt": startDt, "endDt": endDt,"workConditionDesc": workConditionDesc, "exceptCondition": exceptCondition
					 ,"zombieYn": zombieYn, "limitYn": limitYn, "unitTxt": unitTxt, "dispOrder" : dispOrder
					}; 
	if(result){
		if($("#sel_add_workCondition").val() == ''){
			alert("달성조건을 선택해주세요. ");
			$("#sel_add_workCondition").focus();
			return ;
		}else if($("#txt_add_workCnt").val() == ''){
			alert("달성 상세요건을 입력해주세요. ");
			$("#txt_add_workCnt").focus();
			return ;
		}else if($("#sel_add_workType").val() == ''){
			alert("업적구분을 선택해주세요. ");
			$("#sel_add_workType").focus();
			return ;
		}
		
		if($("#txt_add_dispOrder").val() == ''){
			alert("정렬 순서를 입력해주세요. ");
			$("#txt_add_dispOrder").focus();
			return ;
		}
		
		fun_ajaxPostSend("/define/save/defineWorkinsert.do", inputData, true, function(msg){
			if(msg.errorMessage !=null){
				var message = msg.errorMessage;
				if(message == "success"){
					alert("정상적으로 처리되었습니다.");
					$("#exampleModalScrollable").modal('hide');
					fun_search();
				}else if(message == "error"){
					alert("정상적으로 처리되지 않았습니다.");
				}
			}
		});
	}
}


function fun_start_Excel(argFlag, workSeq, workNm){
	fun_startBlockUI();
	setTimeout(() => fun_search_excel(argFlag, workSeq, workNm), 500);
}

function fun_search_excel(argFlag, workSeq, workNm){
	
	console.log("search EXCEL START");
	
	var excelArray = new Array(1); 
	var fileName = "";
	var url = "";
	var inputData = {"workSeq": workSeq};
	var columnCodeArray = [];
	var wscols = [];
	
// 	      { width: 20 }, 
// 	      { width: 20 }, 
// 	      { width: 20 }, 
// 	      { width: 20 },
// 	      { width: 20 }, 
// 	      { width: 20 }, 
// 	      { width: 20 }, 
// 	      { width: 20 },
// 	      { width: 20 }
// 	    ];
	
	if ( argFlag == "join" ){
		fileName = workNm + "_참여인원";
		url = "/define/select/selectDefineWorkStatExcel.do";
		inputData.completeYn = "N";
		
		columnCodeArray.push("사용자Seq");
		columnCodeArray.push("닉네임");
		columnCodeArray.push("휴대폰");
		columnCodeArray.push("접속기기타입");
		columnCodeArray.push("달성횟수");
		columnCodeArray.push("달성여부");
		columnCodeArray.push("업적달성일자");
		columnCodeArray.push("첫업적등록일자");
		columnCodeArray.push("마지막업적등록일자");
		
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
	}
	else if ( argFlag == "complete" ){
		fileName = workNm + "_완료인원";
		url = "/define/select/selectDefineWorkStatExcel.do";
		inputData.completeYn = "Y";
		
		columnCodeArray.push("사용자Seq");
		columnCodeArray.push("닉네임");
		columnCodeArray.push("휴대폰");
		columnCodeArray.push("접속기기타입");
		columnCodeArray.push("달성횟수");
		columnCodeArray.push("달성여부");
		columnCodeArray.push("업적달성일자");
		columnCodeArray.push("첫업적등록일자");
		columnCodeArray.push("마지막업적등록일자");
		
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
		wscols.push({ width: 20 });  
	}
	else if ( argFlag == "promotion1" ){
		fileName = workNm + "_프로모션달성인원(가중치포함)";
	
		url = "/define/select/selectDefineWorkPromoStatExcel.do";
		inputData.completeYn = "Y";
		
		columnCodeArray.push("번호");
		columnCodeArray.push("사용자업적완료순서");
		columnCodeArray.push("사용자Seq");
		columnCodeArray.push("닉네임");
		columnCodeArray.push("휴대폰");
		columnCodeArray.push("접속기기타입");
		columnCodeArray.push("달성횟수");
		columnCodeArray.push("달성여부");
		columnCodeArray.push("업적달성일자");
		columnCodeArray.push("첫업적등록일자");
		columnCodeArray.push("마지막업적등록일자");
		
		wscols.push({ width: 10 });  
		wscols.push({ width: 15 });  
		wscols.push({ width: 15 });  
		wscols.push({ width: 15 });  
		wscols.push({ width: 15 });  
		wscols.push({ width: 15 });  
		wscols.push({ width: 15 });  
		wscols.push({ width: 15 });  
		wscols.push({ width: 15 });  
		wscols.push({ width: 18 });  
		wscols.push({ width: 18 });  
		wscols.push({ width: 18 }); 
	}
	
	
	fun_ajaxPostSendNoBlock(url, inputData, false, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					var tempResult = JSON.parse(msg.result);
					
					console.log(tempResult);
					
					excelArray[0] = tempResult;
					jsonToExcel(excelArray, fileName, columnCodeArray, wscols);
					break;
				case "0001":
					alert("ERROR");
					break;
			}
			
		}
	});
	
	
}

</script>
<head>
	<title>관리자 운영 - 업적관리</title>
</head>
<body class="hold-transition sidebar-mini">
    <div class="wrapper">
          <div class="content-wrapper">
            <!-- 상단 title -->
            <div class="content-header">
               <div class="container-fluid">
                  <div class="row">
                     <div class="col">
                        <h1 class="title">업적관리</h1>
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
                                        <th>등록일</th>
                                        <td colspan="3">
                                           <div class="row">
                                              <div class="col-auto">
                                                  <div class="row row-10 align-items-center">
                                                        <div class="col-auto">
                                                            <input type="text" readonly="" class="form-control form-datepicker" placeholder="0000-00-00" id="search_startDt">
                                                        </div>
                                                        <div class="col-auto">~</div>
                                                        <div class="col-auto">
                                                            <input type="text" readonly="" class="form-control form-datepicker endDt" placeholder="0000-00-00" id="search_endDt">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col">
                                                    <div class="btn-group" role="group">
                                                    	<button type="button" class="btn btn-outline-secondary active" day="all">전체</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="0">오늘</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="1">어제</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="3">3일</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="7">7일</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="15">15일</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="31">1개월</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="33">3개월</button>
                                                        <button type="button" class="btn btn-outline-secondary" day="36">6개월</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>달성조건</th>
                                        <td>
                                            <select class="form-control" id="sel_workCond" name="search_workCond" style="width:80%;">
                                            </select>
                                        </td>
                                        <th>검색어</th>
                                        <td>
                                           <div class="row row-10 align-items-center">
                                                  <input type="text" style="width:90%;" class="form-control" placeholder="업적명" id="txt_searchText" name="searchText" onKeypress="" />
                                                  <input type="checkbox" style="width:34px; margin-left: 1%;" class="form-control" id="chk_searchTable"  />
                                           </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="btns">
                                <button type="button" class="btn btn-dark min-width-90px" onclick="fun_search();">검색</button>
                            </div>
                        </div>
                    </section>

                    <section id="section1">
                        <div class="row justify-content-between align-items-end mb-3">
                                <div class="col-auto"></div>
                                <div class="col-auto">
                                    <button type="button" class="btn btn-primary mr-1" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_btnInsert()">업적등록</button>
                                    <select id="userListLength" class="custom-select w-auto">
                                    	<option value="10">10</option>
                                    	<option value="20">20</option>
                                    	<option value="50">50</option>
                                    </select>
                                </div>
                         </div>
                         <div class="main_search_result_list">
                                <table id="defineListInfo" class="table table-bordered">
                                    <thead>
                                    	<tr>
	                                        <th class="text-center" width="3%">번호</th>
	                                        <th class="text-center">업적명</th>
	                                       	<th class="text-center">달성<br/>조건</th>
	                                        <th class="text-center" width="5%">달성<br/>횟수</th>
	                                        <th class="text-center" width="10%">칭호</th>
	                                        <th class="text-center" width="8%">시작일자</th>
	                                        <th class="text-center" width="8%">종료일자</th>
	                                        <th class="text-center">달성이후<br/>누적</th>
	                                        <th class="text-center">기간한정<br/>여부</th>
	                                        <th class="text-center" width="8%">참여<br/>인원</th>
	                                        <th class="text-center" width="8%">완료<br/>인원</th>
	                                        <th class="text-center" width="6%">관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                        </div>
                	</section>
                </div>
                <!-- 상세보기 모달창 start -->
                <div class="modal fade" id="exampleModalScrollable" tabindex="-1" role="dialog" aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
                  <div class="modal-dialog modal-dialog-scrollable" role="document">
                    
                    <!-- 상세보기 start-->
                    <section id="section1_detail_view" style="display:none;">
                        <div class="modal-content" id="detailmodal" style="width: 1200px;">
                         <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalScrollableTitle">업적상세</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                              <span aria-hidden="true">&times;</span>
                            </button>
                          </div>
                          <div class="modal-body">
                            <table class="table table-bordered" >
                               <colgroup>
                                  <col style="width:15%">
                                  <col style="width:35%">
                                  <col style="width:15%">
                                  <col style="width:35%">
                               </colgroup>
                               <tbody>
                                  <tr>
                                     <th>업적번호</th>
                                     <td><input class="form-control" type="text" id="txt_workSeq" readOnly/></td>
                                     <th>업적명</th>
                                     <td><input class="form-control" type="text" id="txt_workNm" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>달성조건</th>
                                     <td><input class="form-control" type="text" id="txt_workCondition" readOnly/></td>
                                     <th>달성횟수</th>
                                     <td><input class="form-control" type="text" id="txt_workCnt" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>포인트</th>
                                     <td><input class="form-control" type="text" id="txt_point" readOnly/></td>
                                     <th>업적구분</th>
                                     <td><input class="form-control" type="text" id="txt_workType" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>칭호</th>
                                     <td><input class="form-control" type="text" id="txt_nickNm" readOnly/></td>
                                     <th>달성유저 수 (명)</th>
                                     <td>추후 작업</td>
                                  </tr>
                                  <tr>
                                     <th>칭호코멘트</th>
                                     <td><input class="form-control" type="text" id="txt_nickComment" readOnly/></td>
                                     <th>기간 설정</th>
                                     <td>
                                        <div class="row row-10 align-items-center">
	                                       <div class="col-auto col-sm-5"> 
	                                          <input class="form-control" type="text" id="txt_startDt" readOnly/>
	                                       </div> ~
	                                       <div class="col-auto col-sm-5">
	                                          <input class="form-control" type="text" id="txt_endDt"readOnly />
	                                       </div>
                                        </div>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>업적 간략설명</th>
                                     <td><input class="form-control" type="text" id="txt_workConditionDesc" readOnly/></td>
                                     <th>업적제외조건<br>(앱내 상세설명)</th>
                                     <td><input class="form-control" type="text" id="txt_exceptCondition" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>달성이후누적</th>
                                     <td><input class="form-control" type="text" id="txt_zombieYn" readOnly/></td>
                                     <th>기간한정여부</th>
                                     <td><input class="form-control" type="text" id="txt_limitYn" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>단위텍스트</th>
                                     <td><input class="form-control" type="text" id="txt_unitTxt" readOnly/></td>
                                     <th>정렬순서</th> 
                                     <td><input class="form-control" type="text" id="txt_dispOrder" readOnly/></td>
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-danger" onclick="fun_defineHiding()">숨김</button>
                            <button type="button" class="btn btn-secondary" id="close" data-dismiss="modal">닫기</button>
                          </div>
                        </div>
                    </section>
                    <!-- 상세보기 모달창 end  -->
                    <!-- 등록 모달창 -->
                    <section id="section1_inser_view" style="display:none;">
                        <div class="modal-content" id="insertModal" style="width: 1320px;">
                         <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalScrollableTitle">업적등록</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                              <span aria-hidden="true">&times;</span>
                            </button>
                          </div>
                          <div class="modal-body">
                            <table class="table table-bordered" >
                               <colgroup>
                                  <col style="width:15%">
                                  <col style="width:35%">
                                  <col style="width:15%">
                                  <col style="width:35%">
                               </colgroup>
                               <tbody>
                                  <tr>
                                     <th>업적번호</th>
                                     <td>-</td>
                                     <th>업적명</th>
                                     <td><input class="form-control" type="text" id="txt_add_workNm"/></td>
                                  </tr>
                                  <tr>
                                     <th>달성조건 <span class="text-red">*</span></th>
                                     <td>
                                        <select class="form-control" id="sel_add_workCondition" name="operation_workCondition">
                                         </select>
                                    </td>
                                    <th>달성횟수 <span class="text-red">*</span></th>
                                     <td><input class="form-control" placeholder="달성 횟수을 입력해주세요.(숫자)" type="text" id="txt_add_workCnt" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/></td>
                                  </tr>
                                  <tr>
                                     <th>포인트</th>
                                     <td><input class="form-control" placeholder="포인트 금액을 입력해 주세요." type="text" id="txt_add_point" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/></td>
                                     <th>업적구분 <span class="text-red">*</span></th>
                                     <td>
                                        <select class="form-control" id="sel_add_workType" name="operation_workType">
	                                        <option value="">선택</option>
	                                        <option value="NORMAL" th:selected="${bean.workType eq 'NORMAL'}">일반</option>
	                                        <option value="PROMOTION" th:selected="${bean.workType eq 'PROMOTION'}">프로모션</option>
	                                   	</select>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>칭호</th>
                                     <td>
                                     <!-- <input class="form-control" type="text" id="txt_add_nickSeq"/> -->
                                     <select class="form-control" id="sel_add_nickSeq"></select>
                                     </td>
                                     <th>기간 설정</th>
                                     <td>
                                        <div class="row row-10 align-items-center">
                                             <div class="col-auto">
                                                 <input type="text" class="form-control form-datepicker" placeholder="0000-00-00" id="txt_add_startDt">
                                             </div>
                                             <div class="col-auto">~</div>
                                             <div class="col-auto">
                                                 <input type="text" class="form-control form-datepicker endDt" placeholder="0000-00-00" id="txt_add_endDt">
                                             </div>
                                             <!-- 기간 무제한 설정 checkbox -->
	                                        <div class="col-auto" style="top:6px;">
	                                            <label for="endDt_check">
	                                            <input type="checkbox" id="endDt_check" name="endDt_check"/> 기간무제한
	                                            </label>
	                                        </div>
                                        </div>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>업적 간략설명</th>
                                     <td>
                                     <textarea class="form-control" rows="3" id="txt_add_workConditionDesc"></textarea>
                                     <th>업적제외조건<br>(앱내 상세설명)</th>
                                     <td>
                                     <textarea class="form-control" rows="3" id="txt_add_exceptCondition"></textarea>
                                  </tr>
                                  <tr>
                                     <th>달성이후누적</th>
                                     <td>
                                        <select class="form-control" id="sel_add_zombieYn">
	                                        <option value="N">미사용</option>
	                                        <option value="Y">사용</option>
	                                   	</select>
                                     </td>
                                     <th>기간한정여부</th>
                                     <td>
                                         <select class="form-control" id="sel_add_limitYn" hidden="hidden">
	                                        <option value="N">미사용</option>
	                                        <option value="Y">사용</option>
	                                    </select> 
	                                    <input class="form-control" type="text" id="txt_add_limitYn" readOnly/>
                                  </tr>
                                  <tr>
                                     <th>단위텍스트</th>
                                     <td><input class="form-control" placeholder="단위텍스트를 입력해주세요." type="text" id="txt_add_unitTxt" maxlength="2"/></td>
                                  	 <th>정렬순서</th>
                                     <td><input class="form-control" placeholder="정렬순서를 입력해주세요.(숫자)" type="text" id="txt_add_dispOrder" maxlength="9" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" /></td>
                                  
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                          	<button type="button" class="btn btn-primary" onclick="fun_btnDefineinsert()">저장</button>
                            <button type="button" class="btn btn-secondary" id="close" data-dismiss="modal">닫기</button>
                          </div>
                        </div>
                    </section>
                    <!-- 등록 모달창 end -->
                  </div>
                </div>
            </div>
        </div>
    </div>
    </body>