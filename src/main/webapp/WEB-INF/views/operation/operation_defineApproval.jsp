<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>


<script>
var defineApprovalListInfo;

var auth = "${auth}";

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
	
	
	fun_setdefineApprovalListInfo();
	fun_selectCommonCode();
	
	$('#sel_approvalYn').focus( function(){
		approvalPrevious = $(this).val();
	});
	//여기봐라
	$('#sel_useYn').focus( function(){
		useYnPrevious = $(this).val();
	});
	
	$("#userListLength").change(function(){
		var length = $("#userListLength").val();
		$("#defineApprovalListInfo").DataTable().page.len(length).draw();
	});
	
   $("#endDt_check").on("click", function(){
     	var today = c21.date_today("yyyy-MM-dd");
     	if($(this).is(":checked")){
     		$("#sel_up_limitYn").val("N").prop("selected", true);
     		$("#txt_up_limitYn").val("미사용");
     		
     		/** 기간 무제한 체크 시 시작일 오늘날짜로 설정 */
     		$("#txt_up_startDt").val(today);
     		$("#txt_up_startDt").attr("readonly",true);
     		$("#txt_up_startDt").datepicker("disable");
     		/** 기간 무제한 체크 시 종료일 29991231 설정 */
     		$("#txt_up_endDt").val('2999-12-31');
     		$("#txt_up_endDt").attr("readonly",true);
     		$("#txt_up_endDt").datepicker("disable");
     	}else{
     		$("#sel_up_limitYn").val("Y").prop("selected", true);
     		$("#txt_up_limitYn").val("사용");
     		
     		$("#txt_up_startDt").val('');
     		$("#txt_up_startDt").removeAttr("readonly");
     		$("#txt_up_startDt").datepicker("enable");
     		$("#txt_up_endDt").val('');
     		$("#txt_up_endDt").removeAttr("readonly");
     		$("#txt_up_endDt").datepicker("enable");
     	}
   });
   
   $("#endDt_check_add").on("click", function(){
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
   
   	$("#txt_searchText").on('keyup click', function () {
		searchDataTable();	   
	});
	
	$("#chk_searchTable").on('keyup click', function () {
		searchDataTable();
	});
	
	$("#sel_workCond").on('change', function () {
		fun_search();
	});
	
	if ( auth == "ROLE_ADMIN" || auth == "ROLE_OPERMNG" ){
		$("#trAuthFn").show();
	}else{
		$("#trAuthFn").show();
	}
	
});

function searchDataTable(){
	 if($('#chk_searchTable').is(':checked')){
	      $("#defineApprovalListInfo").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	   }
	else{
		$("#defineApprovalListInfo").DataTable().search("").draw();
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
			$('#sel_up_workCond').append($('<option></option>').val("").html("선택")); //수정화면 달성조건
			$('#sel_add_workCondition').append($('<option></option>').val("").html("선택")); //등록화면 달성조건
			$.each(tempResult, function (key, value) {
				$('#sel_workCond').append($('<option></option>').val(value.codeValue).html(value.codeName));
				$('#sel_up_workCond').append($('<option></option>').val(value.codeValue).html(value.codeName));
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
	
	fun_ajaxPostSend("/approval/select/defineWorkApprovalList.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			for (var i = 0; i < tempResult.length; i++) {
				if(tempResult[i].useYn == "숨김"){
					
				}
			}
			for (let i = 0; i < tempResult.length; i++) {
				tempResult[i].listIndex = i + 1
			}
			fun_dataTableAddData("#defineApprovalListInfo", tempResult);
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
	$("#sel_approvalYn").val("");          //승인여부
	$("#sel_useYn").val("");               //사용여부
	$("#txt_dispOrder").val("");           //소팅순서
	$("#txt_workGrp").val("");           //소팅순서
	
	$("#hidden_workCondition").val(); //달성조건 value
	$("#hidden_nickSeq").val(); //칭호 value
	$("#txt_hiddenWorkCnt").val()
	$("#txt_hiddenPoint").val()


}
//상세보기
function fun_viewDetail(workSeq) {
	fun_reset();
	$("#section1_inser_view").hide();
	$("#section1_update_view").css("display", "none");
	$("#section1_detail_view").removeAttr("style");
	var inputData = {"workSeq": workSeq};
	fun_ajaxPostSend("/approval/select/defineWorkApprovalDetail.do", inputData, true, function(msg){
		if(msg!=null){
			var tempResult         = JSON.parse(msg.result);
			var workSeq            = tempResult.workSeq == null ? "" : tempResult.workSeq;                       //업적번호
			var workNm             = tempResult.workNm == null ? "" : tempResult.workNm;                         //업적명
			var workCondition      = tempResult.workCondition == null ? "" : tempResult.workCondition;           //달성조건
			var workConditionCode  = tempResult.workConditionCode == null ? "" : tempResult.workConditionCode;   //달성조건 codeValue
			var codeValue          = tempResult.codeValue == null ? "" : tempResult.codeValue;                   //달성조건 value
			
			var workCnt            = tempResult.workCnt == null ? "" : tempResult.workCnt;                       //달성 상세 요건
			var hiddenWorkCnt      = tempResult.workCnt == null ? "" : tempResult.workCnt;                       //실세데이터 달성 상세 요건
			var point              = tempResult.point == null ? "" : tempResult.point + "P";                           //포인트
			var hiddenPoint        = tempResult.point == null ? "" : tempResult.point;                           //실세데이터 포인트
			
			var workType           = tempResult.workType == null ? "" : tempResult.workType;                     //업적구분
			var nickNm             = tempResult.nickNm == null ? "" : tempResult.nickNm;                         //칭호
			var nickSeq            = tempResult.nickSeq == null ? "" : tempResult.nickSeq;                       //칭호 value
			var nickComment        = tempResult.nickComment == null ? "" : tempResult.nickComment;               //칭호코멘트
			var startDt            = tempResult.startDt == null ? "" : tempResult.startDt;                       //기간 설정
			var endDt              = tempResult.endDt == null ? "" : tempResult.endDt;                           //기간 설정
			var workConditionDesc  = tempResult.workConditionDesc == null ? "" : tempResult.workConditionDesc;   //업적설명
			var exceptCondition    = tempResult.exceptCondition == null ? "" : tempResult.exceptCondition;       //업적제외조건
			var zombieYn           = tempResult.zombieYn == null ? "" : tempResult.zombieYn;                     //달성이후누적
			var limitYn            = tempResult.limitYn == null ? "" : tempResult.limitYn;                       //기간한정여부
			var unitTxt            = tempResult.unitTxt == null ? "" : tempResult.unitTxt;                       //단위텍스트
			var approvalYn         = tempResult.approvalYn == null ? "" : tempResult.approvalYn;                 //승인여부
			var useYn              = tempResult.useYn == null ? "" : tempResult.useYn;                           //사용여부
			var dispOrder			= tempResult.dispOrder == null ? "" : tempResult.dispOrder;
			var workGrp				= tempResult.workGrp == null ? "" : tempResult.workGrp;
			
 			if(codeValue == "SELF"){
				workCnt = "-";
			}else if(codeValue == "PMONEY"){
				workCnt = workCnt + "P";
			}else if(codeValue == "PMONEY"){
				workCnt = workCnt
			}else{
				workCnt = workCnt + "회";
			}
			
 			if ( approvalYn == "Y" && useYn == "Y" ){
 				$("#btnDtlUpd").hide();
 			}else{
 				$("#btnDtlUpd").show();
 			}
 			
			$("#txt_workSeq").val(workSeq);
			$("#txt_workNm").val(workNm);
			$("#txt_workCondition").val(workCondition);
			$("#hidden_workCondition").val(codeValue);
			$("#txt_workCnt").val(workCnt);
			$("#txt_hiddenWorkCnt").val(hiddenWorkCnt); //실세 적용 달성상세요건
			$("#txt_point").val(point);
			$("#txt_hiddenPoint").val(hiddenPoint); //실세 적용 포인트
			$("#txt_workType").val(workType);
			$("#txt_nickNm").val(nickNm);
			$("#hidden_nickSeq").val(nickSeq);
			$("#txt_nickComment").val(nickComment);
			$("#txt_startDt").val(startDt);
			$("#txt_endDt").val(endDt);
			$("#txt_workConditionDesc").val(workConditionDesc);
			$("#txt_exceptCondition").val(exceptCondition);
			$("#txt_zombieYn").val(zombieYn);
			$("#txt_limitYn").val(limitYn);
			$("#txt_unitTxt").val(unitTxt);
			$("#txt_dispOrder").val(dispOrder);
			$("#txt_workGrp").val(workGrp);
			
			$("#sel_approvalYn").val(approvalYn);
			$("#sel_useYn").val(useYn);
		}
	});
}

function fun_setdefineApprovalListInfo() {
	defineApprovalListInfo = $("#defineApprovalListInfo").DataTable({
		"columns": [
			  {"data":  "listIndex"}
			, {"data":  "workNm"}   
			, {"data": "workCondition"}
			, {"data": "workCnt"}
			, {"data": "nickNm"}
			, {"data": "point"}
			, {"data": "approvalYn"}
			, {"data": "useYn"}
			, {"data": "zombieYn" }
			, {"data": "limitYn" }
			, {"data": "unitTxt" }
			, {"data": "dispOrder" }    //정렬순서    dispOrder
			, {"data": "workGrp" }    //정렬순서    dispOrder
			, {"data": "add" }
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
					var point = "";
					if ( row.point != "" ){
						point = row.point+"P";
					}
					return point;
	            }
				
			}
			, {
				"targets": [6]
				, "class": "text-center"
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
			}
			, {
				"targets": [10]
				, "class": "text-center"
			}
			, {
				"targets": [11]
				, "class": "text-center"
			}
			, {
				"targets": [12]
				, "class": "text-center"
			}
			, {
				"targets": [13]
				, "class": "text-center"
				, "render": function (data, type, row) {
					var msg = row.workSeq;
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_viewDetail(' + msg + ')">상세보기</button>'; 
					return insertTr;
                }
			}
		]
	});
	
	fun_search();
};
//업적승인 및 숨김 처리 UPDATAE
function fun_defineHiding(type,value){
	var upWorkSeq       = $("#txt_workSeq").val();
	var mes = ""
	//승인,대기,취소 처리
	if(type == "approvalYn"){
		var approval = value;
		if(value == "N"){
			mes = "승인대기 하시겠습니까?";
		}else if(value == "Y"){
			mes = "승인처리 하시겠습니까?";
		}else{
			mes = "승인취소 하시겠습니까?";
		}
		var result = confirm(mes);
		var inputData = {"upWorkSeq": upWorkSeq, "approvalYn": approval};
		if(result){
			fun_ajaxPostSend("/approval/save/defineWorkapproval.do", inputData, true, function(msg){
				if(msg.code !=null){
					var code = msg.code;
					var message = msg.errorMessage;
					if(code == "0000"){
						alert("정상적으로 처리되었습니다.");
						$("#exampleModalScrollable").modal('hide'); //모달 종료
						fun_search();
					}else{
						alert(message);
					}
				}
			});
		}else{
			$("#sel_approvalYn").val(approvalPrevious);
		}
	}
	//숨김처리
	else{
		var useYn = value;
		if(value == "N"){
			mes = "숨김처리 하시겠습니까?";
		}else if(value == "Y"){
			mes = "숨김처리를 해제 하시겠습니까?";
		}
		
		var result = confirm(mes);
		var inputData = {"upWorkSeq": upWorkSeq,"useYn": useYn};
		if(result){
			fun_ajaxPostSend("/approval/save/defineWorkUseYn.do", inputData, true, function(msg){
				if(msg.code !=null){
					var code = msg.code;
					var message = msg.errorMessage;
					if(code == "0000"){
						alert("정상적으로 처리되었습니다.");
						$("#exampleModalScrollable").modal('hide'); //모달 종료
						fun_search();
					}else{
						alert(message);
					}
				}
			});
		}else{
			$("#sel_useYn").val(useYnPrevious);
		}
	}
}

//상세보기에서 -> 수정버튼 클릭 시
function fun_updateDisplay() {
	$("#section1_detail_view").css("display", "none");
	$("#section1_update_view").removeAttr("style");
	
	$("#sel_up_limitYn").val("Y").prop("selected", true);
	$("#txt_up_limitYn").val("사용");
	
	
	var inputData = {};
	fun_ajaxPostSend("/define/select/defineWorkGetNicknm.do", inputData, true, function(msg){
		if(msg!=null){
			
			var tempResult = JSON.parse(msg.result);
			if(tempResult.length > 0){
				var seqString = tempResult[0].seqString;
				var usuallySeq = $("#hidden_nickSeq").val();
				var usuallyNm = $("#txt_nickNm").val();
				
				$("select#sel_up_nickSeq option").remove();
				$('#sel_up_nickSeq').append($('<option></option>').val("").html("선택"));
				$('#sel_up_nickSeq').append($('<option></option>').val(usuallySeq).html(usuallyNm));
				for(var i=0; i<tempResult.length; i++){
					var nickSeq = tempResult[i].nickSeq;
					if(!seqString.includes(nickSeq)){
							var nickNm = tempResult[i].nickNm;
							$('#sel_up_nickSeq').append($('<option></option>').val(nickSeq).html(nickNm));
					}
				}
			}
		}
		$("#sel_up_nickSeq").val(setNickSeq);
	});
	var workSeq = $("#txt_workSeq").val();
	var workNm = $("#txt_workNm").val();
	var workCondition = $("#hidden_workCondition").val();
	
	var workCnt = $("#txt_hiddenWorkCnt").val();
	var point = $("#txt_hiddenPoint").val();
	
	var workType = $("#txt_workType").val();
	var nickNm = $("#txt_nickNm").val();
	var setNickSeq = $("#hidden_nickSeq").val();
	var nickComment = $("#txt_nickComment").val();
	var startDt = $("#txt_startDt").val();
	var endDt = $("#txt_endDt").val();
	var workConditionDesc = $("#txt_workConditionDesc").val();
	var exceptCondition = $("#txt_exceptCondition").val();
	var zombieYn = $("#txt_zombieYn").val();
	var limitYn = $("#txt_limitYn").val();
	var unitTxt = $("#txt_unitTxt").val();
	var dispOrder = $("#txt_dispOrder").val();
	var workGrp = $("#txt_workGrp").val();
	
	$("#txt_up_workSeq").val(workSeq);
	$("#txt_up_workNm").val(workNm);
	$("#sel_up_workCond").val(workCondition);
	$("#txt_up_nickComment").val(nickComment);  //수정 데이터 아님
	$("#txt_up_workCnt").val(workCnt);
	//hidden 값 넣어야함
	
	
	$("#txt_up_point").val(point);
	$("#txt_up_workType").val(workType);
	$("#txt_up_startDt").val(startDt);  
	$("#txt_up_endDt").val(endDt);    
	$("#txt_up_workConditionDesc").val(workConditionDesc);
	$("#txt_up_exceptCondition").val(exceptCondition);
	$("#sel_up_zombieYn").val(zombieYn);
	$("#sel_up_limitYn").val(limitYn);
	$("#txt_up_unitTxt").val(unitTxt);
	$("#txt_up_dispOrder").val(dispOrder);
	$("#txt_up_workGrp").val(workGrp);
	
	
}

//수정모달창에서 -> 저장버튼 클릭 시
function fun_svae(type) {
	var workSeq           = $("#txt_up_workSeq").val();
	var workNm            = $("#txt_up_workNm").val();
	var workCondition     = $("#sel_up_workCond").val();
	var workCnt           = $("#txt_up_workCnt").val();
	//hidden 값 으로 만 넣어야함
	
	var point             = $("#txt_up_point").val();
	var workType          = $("#sel_up_workType").val();
	var startDt           = $("#txt_up_startDt").val() == null ? "" : $("#txt_up_startDt").val().replaceAll("-", "");
	var endDt             = $("#txt_up_endDt").val() == null ? "" : $("#txt_up_endDt").val().replaceAll("-", "");
	var workConditionDesc = $("#txt_up_workConditionDesc").val();
	var exceptCondition   = $("#txt_up_exceptCondition").val();
	var zombieYn          =	$("#sel_up_zombieYn").val();
	var nickSeq           =	$("#sel_up_nickSeq").val();
	var limitYn           =	$("#sel_up_limitYn").val();
	var unitTxt           =	$("#txt_up_unitTxt").val();
	var dispOrder         =	$("#txt_up_dispOrder").val();
	var workGrp           =	$("#txt_up_workGrp").val();
	
	var inputData = {"workSeq": workSeq,"workNm": workNm,"workCondition": workCondition, "workCnt": workCnt, "point": point,"workType": workType,"startDt": startDt,"endDt": endDt
					,"workConditionDesc": workConditionDesc,"exceptCondition": exceptCondition,"zombieYn": zombieYn,"nickSeq": nickSeq,"limitYn": limitYn,"unitTxt": unitTxt
					,"dispOrder" : dispOrder, "workGrp" : workGrp
					};
	if(type == "U"){
		var result = confirm('업적 수정하시겠습니까?');
		if(result){
			fun_ajaxPostSend("/approval/save/defineWorkUpdate.do", inputData, true, function(msg){
				if(msg.errorMessage !=null){
					var message = msg.errorMessage;
					if(message == "success"){
						alert("정상적으로 처리되었습니다.");
						//$("#section1_update_view").css("display", "none");
						$("#exampleModalScrollable").modal('hide'); //모달 종료
						fun_search();
					}else if(message == "error"){
						alert("정상적으로 처리되지 않았습니다.");
					}
				}
			});
		}
	}else{
		var result = confirm('업적을 삭제하시겠습니까?');
		if(result){
			fun_ajaxPostSend("/approval/save/defineWorkDelete.do", inputData, true, function(msg){
				if(msg.errorMessage !=null){
					var message = msg.errorMessage;
					if(message == "success"){
						alert("정상적으로 처리되었습니다.");
						//$("#section1_update_view").css("display", "none");
						$("#exampleModalScrollable").modal('hide'); //모달 종료
						fun_search();
					}else if(message == "error"){
						alert("정상적으로 처리되지 않았습니다.");
					}
				}
			});
		}
		
	}
}


//칭호변경 시 칭호코멘트 조회 후 셋팅
function changeNickNm(value) {
	if(value == ""){
		$("#txt_up_nickComment").val("");
	}else{
		var nickSeq = value;
		var inputData = {"nickSeq": nickSeq}
		fun_ajaxPostSend("/approval/select/selectNickComment.do", inputData, true, function(msg){
			if(msg!=null){
				var tempResult = JSON.parse(msg.result);
				var nickComment = tempResult.nickComment;
				$("#txt_up_nickComment").val(nickComment);
			}
		});
	}
}

//업적관리 등록버튼
function fun_btnInsert() {
	
	$("#section1_update_view").hide();
	$("#section1_detail_view").hide();
	
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
	var workGrp = $("#txt_add_workGrp").val();
	
	var result = confirm('업적 등록하시겠습니까?');
	
	var inputData = {"workSeq": workSeq, "workNm": workNm, "workCondition": workCondition,"workCnt": workCnt, "point": point, "workType": workType
					 ,"nickSeq": nickSeq, "startDt": startDt, "endDt": endDt,"workConditionDesc": workConditionDesc, "exceptCondition": exceptCondition
					 ,"zombieYn": zombieYn, "limitYn": limitYn, "unitTxt": unitTxt, "dispOrder" : dispOrder, "workGrp" : workGrp
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
		
		if($("#txt_add_workGrp").val() == ''){
			alert("업적 그룹을 입력해주세요. ");
			$("#txt_add_workGrp").focus();
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
                                <table id="defineApprovalListInfo" class="table table-bordered">
                                    <thead>
                                    	<tr>
	                                        <th class="text-center" width="5%">번호</th>
	                                        <th class="text-center">업적명</th>
	                                       	<th class="text-center">달성<br/>조건</th>
	                                        <th class="text-center" width="5%">달성<br/>횟수</th>
	                                        <th class="text-center" width="10%">칭호</th>
	                                        <th class="text-center" width="5%">포인트</th>
	                                        
	                                        <th class="text-center" width="5%">승인<br/>여부</th>
	                                        <th class="text-center" width="5%">사용<br/>여부</th>
	                                        
	                                        <th class="text-center">달성이후<br/>누적</th>
	                                        <th class="text-center">기간한정<br/>여부</th>
	                                        <th class="text-center">단위<br/>텍스트</th>
	                                        <th class="text-center" width="5%">정렬<br/>순서</th>
	                                        <th class="text-center">업적<br/>그룹</th>
	                                        <th class="text-center" width="7%">관리</th>
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
                                     <td><input class="form-control" type="text" id="txt_workCondition" readOnly/>
                                         <input class="form-control" type="hidden" id="hidden_workCondition"/>
                                     </td>
                                     <th>달성횟수
                                       <!-- <button type="button" class="ml-1" data-placement="right" data-toggle="tooltip" data-html="true" title="dd">
                                            <i class="icon-exclamation"></i>
                                        </button> -->
                                     </th>
                                     <td><input class="form-control" type="text" id="txt_workCnt" readOnly/>
                                         <input class="form-control" type="hidden" id="txt_hiddenWorkCnt"/>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>포인트</th>
                                     <td><input class="form-control" type="text" id="txt_point" readOnly/>
                                         <input class="form-control" type="hidden" id="txt_hiddenPoint" readOnly/>
                                     </td>
                                     <th>업적구분</th>
                                     <td><input class="form-control" type="text" id="txt_workType" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>칭호</th>
                                     <td><input class="form-control" type="text" id="txt_nickNm" readOnly/>
                                         <input class="form-control" type="hidden" id="hidden_nickSeq" readOnly/>
                                     </td>
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
                                  <tr>
                                     <th>업적그룹</th>
                                     <td colspan="3"><input class="form-control" placeholder="업적 그룹을 입력해주세요." type="text" id="txt_workGrp" maxlength="20" readOnly /></td>
                                  </tr>
                                  <tr id="trAuthFn" style="display:none;">
                                     <th>승인처리</th>
                                     <!-- <td><input class="form-control" type="text" id="txt_unitTxt" readOnly/></td> -->
                                      <td>
	                                     <p class="text-red">승인 관리는 아래 selecbox 를 변경해 주세요.</p>
	                                     <select class="form-control mt-1" id="sel_approvalYn" name="" onchange="fun_defineHiding('approvalYn', this.value);">
		                                     <option value="N">승인대기</option>
		                                     <option value="Y">승인완료</option>
		                                     <option value="C">승인취소</option>
		                                  </select>
	                                  </td>
	                                  
                                     <th>숨김여부</th>
                                     <td>
                                     <p class="text-red">숨김여부 관리는 아래 selecbox 를 변경해 주세요.</p>
	                                    <select class="form-control mt-1" id="sel_useYn" onchange="fun_defineHiding('useYn', this.value);">
		                                    <option value="Y">사용</option>
		                                    <option value="N">숨김</option>
		                                </select>
                                     </td>
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                            <button type="button" id="btnDtlUpd" class="btn btn-primary min-width-90px" onclick="fun_updateDisplay();">수정</button>
                            <button type="button" class="btn btn-secondary min-width-90px" id="close" data-dismiss="modal">닫기</button>
                          </div>
                        </div>
                    </section>
                    <!-- 상세보기 모달창 end  -->
                    <!-- 수정화면 모달창 start  -->
                    <section id="section1_update_view" style="display:none;">
                        <div class="modal-content" id="detailmodal" style="width: 1320px;">
                         <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalScrollableTitle">업적수정</h5>
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
                                     <td><input class="form-control" type="text" id="txt_up_workSeq" readOnly/></td>
                                     <th>업적명</th>
                                     <td><input class="form-control" type="text" id="txt_up_workNm"/></td>
                                  </tr>
                                  <tr>
                                     <th>달성조건</th>
                                     <td>
                                        <select class="form-control" id="sel_up_workCond" name="search_workCond">
                                       </select>
                                     </td>
                                     <th>달성횟수</th>
                                     <td><input class="form-control" type="text" id="txt_up_workCnt" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/></td>
                                  </tr>
                                  <tr>
                                     <th>포인트</th>
                                     <td><input class="form-control" type="text" id="txt_up_point" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/></td>
                                     <th>업적구분</th>
                                     <td>
                                       <select class="form-control" id="sel_up_workType" >
                                          <option value="">선택</option>
                                          <option value="NORMAL">일반</option>
                                          <option value="PROMOTION">프로모션</option>
                                       </select>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>칭호</th>
                                     <td><select class="form-control" id="sel_up_nickSeq" onchange="changeNickNm(this.value);"></select></td>
                                     <th>기간 설정</th>
                                     <td>
                                        <div class="row row-10 align-items-center">
                                          <div class="col-auto">
                                              <input type="text" class="form-control form-datepicker" placeholder="0000-00-00" id="txt_up_startDt">
                                          </div>
                                          <div class="col-auto">~</div>
                                          <div class="col-auto">
                                              <input type="text" class="form-control form-datepicker endDt" placeholder="0000-00-00" id="txt_up_endDt">
                                          </div>
	                                     <div class="col-auto" style="top:6px;">
	                                         <label for="endDt_check">
	                                         <input type="checkbox" id="endDt_check" name="endDt_check"/> 기간무제한
	                                         </label>
	                                     </div>
                                        </div>
                                     </td>
                                  </tr>
                                  <tr>
                                    <th>칭호코멘트</th>
                                    <td><input type="text" class="form-control" id="txt_up_nickComment" readOnly></input></td>
                                  </tr>
                                  <tr>
                                     <th>업적 간략설명</th>
                                     <td><textarea class="form-control" type="text" id="txt_up_workConditionDesc"/></textarea>
                                     <th>업적제외조건<br>(앱내 상세설명)</th>
                                     <td><textarea class="form-control" type="text" id="txt_up_exceptCondition"/></textarea>
                                  </tr>
                                  <tr>
                                     <th>달성이후누적</th>
                                     <td>
                                        <select class="form-control" id="sel_up_zombieYn">
	                                        <option value="N">미사용</option>
	                                        <option value="Y">사용</option>
	                                   </select>
                                   </td>
                                     <th>기간한정여부</th>
                                     <td>
                                        <select class="form-control" id="sel_up_limitYn" hidden="hidden">
	                                        <option value="N">미사용</option>
	                                        <option value="Y">사용</option>
	                                    </select> 
	                                    <input class="form-control" type="text" id="txt_up_limitYn" readOnly/>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>단위텍스트</th>
                                     <td><input class="form-control" type="text" id="txt_up_unitTxt"/></td>
                                     <th>정렬순서</th>
                                     <td><input class="form-control" type="text" id="txt_up_dispOrder" maxlength="9" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" /></td>
                                  </tr>
                                  <tr>
                                     <th>업적그룹</th>
                                     <td colspan="3"><input class="form-control" placeholder="업적 그룹을 입력해주세요." type="text" id="txt_up_workGrp" maxlength="20"/></td>
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-primary min-width-90px" onclick="fun_svae('U');">저장</button>
                            <button type="button" class="btn btn-danger min-width-90px" onclick="fun_svae('D');">삭제</button>
                            <button type="button" class="btn btn-secondary min-width-90px" id="close" data-dismiss="modal">닫기</button>
                          </div>
                        </div>
                    </section>
                    <!-- 수정화면 모달창 end  -->
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
	                                            <label for="endDt_check_add">
	                                            <input type="checkbox" id="endDt_check_add" name="endDt_check_add"/> 기간무제한
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
                                  <tr>
                                     <th>업적그룹</th>
                                     <td colspan="3"><input class="form-control" placeholder="업적 그룹을 입력해주세요." type="text" id="txt_add_workGrp" maxlength="20"/></td>
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