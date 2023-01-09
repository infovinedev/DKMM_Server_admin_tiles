<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 -->
<script>
var userLeaveListInfo;
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
	
	fun_setStoreListInfo();
	
	$("#userLeaveListLength").change(function(){
		var length = $("#userLeaveListLength").val();
		$("#userLeaveListInfo").DataTable().page.len(length).draw();
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
	
	if ( auth == "ROLE_ADMIN"){
		$("#btnCancel").show();
		
		$("#btnCancel").on('click', function () {
			fun_leaveRollBack();
		});
	}
	
	
});

//FAQ 등록,수정,삭제 저장 버튼
function fun_leaveRollBack(){
	
	if ( auth != "ROLE_ADMIN"){
		return;
	}
	
	var leaveSeq         = $("#txt_leaveSeq").val();
	var userSeq          = $("#txt_userSeq").val();

	var inputData = {"leaveSeq": leaveSeq , "userSeq": userSeq };
	
	var result = confirm('탈퇴를 되돌리시겠습니까? 탈퇴정보는 삭제 되고 기존 회원은 로그인이 가능합니다.');
	
	if(result){
		fun_ajaxPostSend("/userLeave/save/leaveRollBack.do", inputData, true, function(msg){
			if(msg.code != null){
				var code = msg.code;
				if(code == "0000"){
					alert("정상적으로 처리되었습니다.");
					$("#exampleModalScrollable").modal('hide');
					fun_search();
				}
				else{
					alert("정상적으로 처리되지 않았습니다. [ " + msg.errorMessage + " ]");
				}
			}
		});
	}
}

function searchDataTable(){
	 if($('#chk_searchTable').is(':checked')){
	      $("#userLeaveListInfo").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	   }
	else{
		$("#userLeaveListInfo").DataTable().search("").draw();
	}
}

function fun_search(){
	var delYn = $("#sel_delYn").val();
	var searchText = "";//$("#txt_searchText").val();
	var searchStartDt = $("#search_startDt").val();
	var searchEndDt = $("#search_endDt").val();
	
	$('#chk_searchTable').prop('checked', false);
	searchDataTable();
	
	var inputData = {"delYn": delYn, "searchText": searchText, "searchStartDt": searchStartDt,"searchEndDt": searchEndDt};
	fun_ajaxPostSend("/userLeave/select/userLeaveList.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					
					var tempResult = JSON.parse(msg.result);
					for (let i = 0; i < tempResult.length; i++) {
						tempResult[i].listIndex = i + 1
					}
					fun_dataTableAddData("#userLeaveListInfo", tempResult);
					
					break;
				case "0001":
					
					alert(msg.errorMessage);
					break;
			}
		}
	});
}

//text값 공백처리
function fun_reset(type){
	$("#txt_leaveSeq").val("");
	$("#txt_nickName").val("");
	$("#txt_reason").val("");
	$("#txt_delYn").val("");
	$("#txt_insDt").val("");
}

function replaceAll(strTemp, strValue1, strValue2){ 
    while(1){
        if( strTemp.indexOf(strValue1) != -1 )
            strTemp = strTemp.replace(strValue1, strValue2);
        else
            break;
    }
    return strTemp;
}

//상세보기
function fun_viewDetail(leaveSeq) {
	fun_reset();
	$("#section1_detail_view").removeAttr("style");
	var inputData = {"leaveSeq": leaveSeq};
	fun_ajaxPostSend("/userLeave/select/userInfoDetail.do", inputData, true, function(msg){
		if(msg!=null){
			var tempResult = JSON.parse(msg.result);
			var userId   = tempResult.userId == null ? "" : tempResult.userId;                   //ID
			var leaveSeq   = tempResult.leaveSeq == null ? "" : tempResult.leaveSeq;             //탈퇴번호
			var nickName   = tempResult.nickName == null ? "" : tempResult.nickName;             //닉네임
			var reason     = tempResult.reason == null ? "" : tempResult.reason;                 //내용 
			var delYn      = tempResult.delYn == null ? "" : tempResult.delYn;                   //탈퇴완료여부
			var insDt      = tempResult.insDt == null ? "" : tempResult.insDt;                   //탈퇴일
			var userSeq    = tempResult.userSeq == null ? "" : tempResult.userSeq;                   //탈퇴일
			
			$("#txt_leaveSeq").val(leaveSeq);
			$("#txt_nickName").val(nickName);
			$("#span_nickName").text("#"+userId);
			$("#txt_reason").val(reason);
			$("#txt_delYn").val(delYn);
			$("#txt_insDt").val(insDt);
			$("#txt_userSeq").val(userSeq);
			
		}
	});
}

function fun_setStoreListInfo() {
	userLeaveListInfo = $("#userLeaveListInfo").DataTable({
		"columns": [
			  {"data":  "listIndex"}
			, {"data":  "leaveSeq"}
			, {"data": "userId"}
			, {"data": "nickName"}
			, {"data": "reason"}
			, {"data": "delYn"}
			, {"data": "insDt" }
			, {"data": "add" }
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
				, "class": "text-left"
			}
			, {
				"targets": [4]
				, "class": "text-left"
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
				, "render": function (data, type, row) {
					var msg = row.leaveSeq;
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_viewDetail(' + msg + ')">상세보기</button>'; 
					return insertTr;
                }
			}
		]
	});
	fun_search();
};
</script>
<head>
	<title>관리자 운영 - 회원정보조회</title>
</head>
<body class="hold-transition sidebar-mini">
    <div class="wrapper">
          <div class="content-wrapper">
            <!-- 상단 title -->
            <div class="content-header">
               <div class="container-fluid">
                  <div class="row">
                     <div class="col">
                        <h1 class="title">탈퇴사유</h1>
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
                                        <th>탈퇴여부</th>
                                        <td>
                                            <select class="form-control" id="sel_delYn" name="search_delYn" style="width:80%;">
                                                <option value="">선택</option>
                                                <option value="N">N</option>
                                                <option value="Y">Y</option>
                                            </select>
                                        </td>
                                        <th>검색어</th>
                                        <td>
                                           <div class="row row-10 align-items-center">
                                                  <input type="text" style="width:90%;" class="form-control" placeholder="닉네임,내용" id="txt_searchText" name="searchText" onKeypress="" />
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
                                <div class="col-auto">
                                    <select id="userLeaveListLength" class="custom-select w-auto">
                                    	<option value="10">10</option>
                                    	<option value="20">20</option>
                                    	<option value="50">50</option>
                                    </select>
                                </div>
                         </div>
                         <div class="main_search_result_list">
                                <table id="userLeaveListInfo" class="table table-bordered">
                                    <thead>
                                    	<tr>
	                                        <th class="text-center">번호</th>
	                                        <th class="text-center">탈퇴번호</th>
	                                        <th class="text-center">사용자ID</th>
	                                       	<th class="text-center">닉네임</th>
	                                        <th class="text-center">내용</th>
	                                        <th class="text-center">탈퇴완료여부</th>
	                                        <th class="text-center">탈퇴일</th>
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
                        <div class="modal-content" style="width: 1200px;">
                         <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalScrollableTitle">탈퇴사유 승인</h5>
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
                                     <th>탈퇴번호</th>
                                     <td><input class="form-control" type="text" id="txt_leaveSeq" readOnly/>
                                     	 <input type="hidden" id="txt_userSeq" readOnly/>
                                     </td>
                                     <th>닉네임</th>
                                     <td><input class="form-control-finance" type="text" id="txt_nickName" readOnly/>
                                         <span id="span_nickName" style="color:blue"></span>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>내용</th>
                                     <td colspan="3">
                                     	<textarea class="form-control" rows="7" id="txt_reason" readOnly> </textarea>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>탈퇴완료여부</th>
                                     <td><input class="form-control" type="text" id="txt_delYn" readOnly/></td>
                                     <th>탈퇴일</th>
                                     <td><input class="form-control" type="text" id="txt_insDt" readOnly/></td>
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                          	<button type="button" id="btnCancel" style="display:none;" class="btn btn-danger">탈퇴철회</button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                          </div>
                        </div>
                    </section>
                  </div>
                </div>
                <!-- 상세보기 모달창 end -->
            </div>
        </div>
    </div>
    </body>