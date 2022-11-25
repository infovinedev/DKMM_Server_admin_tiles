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
	
	$("#userListLength").change(function(){
		var length = $("#userListLength").val();
		$("#defineListInfo").DataTable().page.len(length).draw();
	});
	
   $("#txt_searchText").on('keyup click', function () {
	   if($('#chk_searchTable').is(':checked')){
	      $("#defineListInfo").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	   }
   });
});
function fun_search(){
	var workCondition = $("#sel_workCond").val();
	var searchText = $("#txt_searchText").val();
	var searchStartDt = $("#search_startDt").val();
	var searchEndDt = $("#search_endDt").val();
	var inputData = {"workCondition": workCondition, "searchText": searchText, "searchStartDt": searchStartDt,"searchEndDt": searchEndDt};
	
	fun_ajaxPostSend("/define/select/defineWorkList.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
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
	$("#txt_nickSeq").val("");             //칭호
	$("#txt_nickComment").val("");         //칭호코멘트
	$("#txt_startDt").val("");             //기간 설정
	$("#txt_endDt").val("");               //기간 설정
	$("#txt_workConditionDesc").val("");   //업적설명
	$("#txt_exceptCondition").val("");     //업적제외조건
	$("#txt_zombieYn").val("");            //달성이후누적
	$("#txt_limitYn").val("");             //기간한정여부
	$("#txt_unitTxt").val("");             //단위텍스트
}

//업적관리 등록버튼
function fun_btnInsert() {
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
			var nickSeq            = tempResult.nickSeq == null ? "" : tempResult.nickSeq;                       //칭호
			var nickComment        = tempResult.nickComment == null ? "" : tempResult.nickComment;               //칭호코멘트
			var startDt            = tempResult.startDt == null ? "" : tempResult.startDt;                       //기간 설정
			var endDt              = tempResult.endDt == null ? "" : tempResult.endDt;                           //기간 설정
			var workConditionDesc  = tempResult.workConditionDesc == null ? "" : tempResult.workConditionDesc;   //업적설명
			var exceptCondition    = tempResult.exceptCondition == null ? "" : tempResult.exceptCondition;       //업적제외조건
			var zombieYn           = tempResult.zombieYn == null ? "" : tempResult.zombieYn;                     //달성이후누적
			var limitYn            = tempResult.limitYn == null ? "" : tempResult.limitYn;                       //기간한정여부
			var unitTxt            = tempResult.unitTxt == null ? "" : tempResult.unitTxt;                       //단위텍스트 
			
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
			$("#txt_nickSeq").val(nickSeq);
			$("#txt_nickComment").val(nickComment);
			$("#txt_startDt").val(startDt);
			$("#txt_endDt").val(endDt);
			$("#txt_workConditionDesc").val(workConditionDesc);
			$("#txt_exceptCondition").val(exceptCondition);
			$("#txt_zombieYn").val(zombieYn);
			$("#txt_limitYn").val(limitYn);
			$("#txt_unitTxt").val(unitTxt);
		}
	});
}

function fun_setDefineListInfo() {
	defineListInfo = $("#defineListInfo").DataTable({
		"columns": [
			  {"data":  "rowNum"}
			, {"data":  "workNm"}   //업적명
			, {"data": "workCondition"}    //달성조건    workCondition
			, {"data": "workCnt"}    //달성상세요건 workCnt
			, {"data": "nickSeq"}    //칭호       nickSeq
			, {"data": "point"}    //포인트     point
			, {"data": "zombieYn" }    //달성이후누적 zombieYn
			, {"data": "limitYn" }    //기간한정여부 limitYn
			, {"data": "unitTxt" }    //단위텍스트    unitTxt
			, {"data": "add" }    //관리
		]
		, "paging": true            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "autoWidth": true
 		, "scrollXInner": "100%"
		, "order": [[ 1, "desc" ]]
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
				, "class": "text-center"
			}
			, {
				"targets": [3]
				, "class": "text-center"
			}
			, {
				"targets": [4]
				, "class": "text-center"
			}
			, {
				"targets": [5]
				, "class": "text-center"
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
				, "render": function (data, type, row) {
					var msg = row.workSeq;
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_viewDetail(' + msg + ')">상세보기</button>'; 
					return insertTr;
                }
			}
		]
	});
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
					$("#section1_detail_view").css("display", "none");
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
	var nickSeq = $("#txt_add_nickSeq").val();
	var startDt = $("#txt_add_startDt").val();
	var endDt = $("#txt_add_endDt").val();
	var startDt = $("#txt_add_startDt").val() == null ? "" : $("#txt_add_startDt").val().replaceAll("-", "");
	var endDt   = $("#txt_add_startDt").val() == null ? "" : $("#txt_add_endDt").val().replaceAll("-", "");
	var workConditionDesc = $("#txt_add_workConditionDesc").val();
	var exceptCondition = $("#txt_add_exceptCondition").val();
	var zombieYn = $("#sel_add_zombieYn").val();
	var limitYn = $("#txt_add_limitYn").val();
	var unitTxt = $("#txt_add_unitTxt").val();
	
	var result = confirm('업적 등록하시겠습니까?');
	
	var inputData = {"workSeq": workSeq, "workNm": workNm, "workCondition": workCondition,"workCnt": workCnt, "point": point, "workType": workType
					 ,"nickSeq": nickSeq, "startDt": startDt, "endDt": endDt,"workConditionDesc": workConditionDesc, "exceptCondition": exceptCondition
					 ,"zombieYn": zombieYn, "limitYn": limitYn, "unitTxt": unitTxt
					};
	if(result){	
		fun_ajaxPostSend("/define/save/defineWorkinsert.do", inputData, true, function(msg){
			if(msg.errorMessage !=null){
				var message = msg.errorMessage;
				if(message == "success"){
					alert("정상적으로 처리되었습니다.");
					$("#section1_detail_view").css("display", "none");
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
                                            <select class="form-control" id="sel_workCond" name="search_workCond">
                                              <option value="">선택</option>
                                              <option value="REGISTER">대기 등록</option>
                                              <option value="LIKE">매장 찜하기</option>
                                              <option value="SEARCH">매장 검색</option>
                                              <option value="PHONE">휴대폰 본인인증</option>
                                              <option value="ACT">업적 달성</option>
                                              <option value="CHANGE">칭호 변경</option>
                                              <option value="GET">칭호 획득</option>
                                              <option value="SPGET">특정 칭호 획득</option>
                                              <option value="PMONEY">포인트 금액</option>
                                              <option value="SELF">직접입력</option>
                                              <option value="CUSTOM001">커스텀</option>
                                              <option></option>
                                            </select>
                                        </td>
                                        <th>검색어</th>
                                        <td>
                                           <div class="row row-10 align-items-center">
                                                  <input type="text" style="width:94%;" class="form-control" placeholder="업적명" id="txt_searchText" name="searchText" onKeypress="" />
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
	                                        <th class="text-center">번호</th>
	                                        <th class="text-center">업적명</th>
	                                       	<th class="text-center">달성조건</th>
	                                        <th class="text-center">달성 상세요건</th>
	                                        <th class="text-center">칭호</th>
	                                        <th class="text-center">포인트</th>
	                                        <th class="text-center">달성이후누적</th>
	                                        <th class="text-center">기간한정여부</th>
	                                        <th class="text-center">단위텍스트</th>
	                                        <th class="text-center">관리</th>
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
                        <div class="modal-content" id="modaltest" style="width: 1200px;">
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
                                     <th>달성 상세 요건</th>
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
                                     <td><input class="form-control" type="text" id="txt_nickSeq" readOnly/></td>
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
                                     <th>업적설명</th>
                                     <td><input class="form-control" type="text" id="txt_workConditionDesc" readOnly/></td>
                                     <th>업적제외조건</th>
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
                                     <td colspan="3"><input class="form-control" type="text" id="txt_unitTxt" readOnly/></td>
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" id="close" data-dismiss="modal">닫기</button>
                            <button type="button" class="btn btn-danger" onclick="fun_defineHiding()">숨김</button>
                          </div>
                        </div>
                    </section>
                    <!-- 상세보기 모달창 end  -->
                    <!-- 등록 모달창 -->
                    <section id="section1_inser_view" style="display:none;">
                        <div class="modal-content" id="modaltest" style="width: 1200px;">
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
                                           <option value="">선택</option>
                                           <option value="REGISTER">대기 등록</option>
                                           <option value="LIKE">매장 찜하기</option>
                                           <option value="SEARCH">매장 검색</option>
                                           <option value="PHONE">휴대폰 본인인증</option>
                                           <option value="ACT">업적 달성</option>
                                           <option value="CHANGE">칭호 변경</option>
                                           <option value="GET">칭호 획득</option>
                                           <option value="SPGET">특정 칭호 획득</option>
                                           <option value="PMONEY">포인트 금액</option>
                                           <option value="SELF">직접입력</option>
                                           <option value="CUSTOM001">커스텀</option>
                                         </select>
                                    </td>
                                    <th>달성 상세요건 <span class="text-red">*</span></th>
                                     <td><input class="form-control" placeholder="달성 상세요건을 입력해주세요." type="text" id="txt_add_workCnt" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/></td>
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
                                     <td><input class="form-control" type="text" id="txt_add_nickSeq"/></td>
                                     
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
                                        </div>
                                     </td>
                                     
                                     
                                  </tr>
                                  <tr>
                                     <th>업적설명</th>
                                     <td>
                                     <textarea class="form-control" rows="3" id="txt_add_workConditionDesc"></textarea>
                                     <th>업적제외조건</th>
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
                                        <select class="form-control" id="txt_add_limitYn">
	                                        <option value="N">미사용</option>
	                                        <option value="Y">사용</option>
	                                    </select>
                                  </tr>
                                  <tr>
                                     <th>단위텍스트</th>
                                     <td colspan="3"><input class="form-control" placeholder="단위텍스트를 입력해주세요." type="text" id="txt_add_unitTxt" maxlength="2"/></td>
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" id="close" data-dismiss="modal">취소</button>
                            <button type="button" class="btn btn-danger" onclick="fun_btnDefineinsert()">저장</button>
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