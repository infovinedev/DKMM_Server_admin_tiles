<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
var noticeListInfo;
var boardListInfo;

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
	
	$("input:text[numberOnly]").on("keyup", function() {
	      $(this).val($(this).val().replace(/[^0-9]/g,""));
	   });
	
	fun_setnoticeListInfo();
	
	$("#noticeListLength").change(function(){
		var length = $("#noticeListLength").val();
		$("#noticeListInfo").DataTable().page.len(length).draw();
	});
	
	$("#txt_searchText").on('keyup click', function () {
		searchDataTable();	   
	});
	
	$("#chk_searchTable").on('keyup click', function () {
		searchDataTable();
	});
	
	$("#search_noticeDiv").on('change', function () {
		fun_search();
	});
	
	fun_setboardListInfo();
});

function searchDataTable(){
	 if($('#chk_searchTable').is(':checked')){
	      $("#noticeListInfo").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	   }
	else{
		$("#noticeListInfo").DataTable().search("").draw();
	}
}

function fun_search(){
	var searchText = $("#txt_searchText").val();
	var searchStartDt = $("#search_startDt").val();
	var searchEndDt = $("#search_endDt").val();
	
	$('#chk_searchTable').prop('checked', false);
	searchDataTable();
	
	var inputData = {"searchText": searchText,"searchStartDt": searchStartDt,"searchEndDt": searchEndDt};
	fun_ajaxPostSend("/notice/select/noticeAllList.do", inputData, true, function(msg){
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
			fun_dataTableAddData("#noticeListInfo", tempResult);
		}
	});
}

//text값 공백처리
function fun_reset(){
	$("#hidden_noticeSeq").val("");
	$("#txt_noticeDesc").val("");
	$("#txt_noticeFilePath").val("");
	$("#sel_dispYn").val("N");
	$("#txt_boardSeq").val("");
	$("#txt_insDt").val("");
	
	$("#txt_up_noticeDesc").val("");
	$("#txt_up_noticeFilePath").val("");
	$("#sel_up_dispYn").val("N");
	$("#txt_up_boardSeq").val("");
	$("#txt_up_insDt").val("");
}

//상세보기
function fun_viewDetail(noticeSeq) {
	fun_reset();
	$("#section1_detail_edit").css("display", "none");
	$("#section1_detail_view").removeAttr("style");
	var inputData = {"noticeSeq": noticeSeq};
	
	fun_ajaxPostSend("/notice/select/noticeListDetail.do", inputData, true, function(msg){
		if(msg!=null){
			var tempResult 		= JSON.parse(msg.result);
			var noticeSeq 		= tempResult.noticeSeq == null ? "N/A" 	: tempResult.noticeSeq;                    
			var noticeDesc  	= tempResult.noticeDesc == null ? "N/A" : tempResult.noticeDesc;                   
			var noticeFilePath  = tempResult.noticeFilePath == null ? "N/A" : tempResult.noticeFilePath;                           
			var dispYn 			= tempResult.dispYn == null ? "N/A" : tempResult.dispYn;                            
			var boardSeq  		= tempResult.boardSeq == null ? "N/A" : tempResult.boardSeq;                      
			var insDt  			= tempResult.insDt == null ? "N/A" : tempResult.insDt;    
			
			//상세보기 데이터	
			$("#hidden_noticeSeq").val(noticeSeq);
			$("#txt_noticeDesc").val(noticeDesc);
			$("#txt_noticeFilePath").val(noticeFilePath);
			$("#sel_dispYn").val(dispYn);
			$("#txt_boardSeq").val(boardSeq);
			$("#txt_insDt").val(insDt);
			
			//상세보기 수정 데이터
			$("#hidden_up_noticeSeq").val(noticeSeq);
			$("#txt_up_noticeDesc").val(noticeDesc);
			$("#txt_up_noticeFilePath").val(noticeFilePath);
			$("#sel_up_dispYn").val(dispYn);
			$("#txt_up_boardSeq").val(boardSeq);
			$("#txt_up_insDt").val(insDt);
		}
	});
}

function fun_update(type) {
	
	$("#btn_insert").show();
	$("#btn_update").show();
	$("#btn_delete").show();
	
	if(type == "insert"){
		
		fun_reset();
		
		$("#section1_detail_edit_board").hide();
		$("#section1_detail_detail").hide();
		$("#section1_detail_edit").show();
		
		$("#btn_update").hide();
		$("#btn_delete").hide();
		var sDate = c21.date_today("yyyy-MM-dd hh:mm:ss");
		
		
		
	}else{
		
		$("#btn_insert").hide();
	
	}
	
	$("#section1_detail_view").css("display", "none");
	$("#section1_detail_edit").removeAttr("style");
}

function fun_setnoticeListInfo() {
	noticeListInfo = $("#noticeListInfo").DataTable({
		"columns": [
			  {"data": "listIndex"}
			, {"data": "noticeSeq"}
			, {"data": "noticeDesc"}
			, {"data": "noticeFilePath"}
			, {"data": "dispYn"}
			, {"data": "boardSeq"}
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
			 , {
				"targets": [1]
				, "class": "text-center"
			}
			 , {
				"targets": [2]
				, "class": "text-left"
				, "render": function (data, type, row) {
					var msg = row.noticeDesc;
					var insertTr = "";
					if ( msg.length > 50 ){
						insertTr = msg.substring(0, 50) + "..";					
					}
					else{
						insertTr = msg;
					}
					return insertTr;
                }
			}
			, {
				"targets": [3]
				, "class": "text-left"
				, "render": function (data, type, row) {
					var msg = row.noticeFilePath;
					var insertTr = "";
					if ( msg.length > 50 ){
						insertTr = msg.substring(0, 50) + "..";					
					}
					else{
						insertTr = msg;
					}
					insertTr = "<a href='" + row.noticeFilePath + "' target='_blank'>" + insertTr + "</a>";
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
			}
			, {
				"targets": [6]
				, "class": "text-center"
			}
			, {
				"targets": [7]
				, "class": "text-center"
				, "render": function (data, type, row) {
					var msg = row.noticeSeq;
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_viewDetail(' + msg + ')">상세보기</button>'; 
					return insertTr;
                }
			}
		]
	});
	
	fun_search();
};

//공지사항 등록,수정,삭제 저장 버튼
function fun_save(type){
	
	var noticeSeq        	= $("#hidden_noticeSeq").val();
	var noticeDesc       	= $("#txt_up_noticeDesc").val();
	var noticeFilePath      = $("#txt_up_noticeFilePath").val();
	var dispYn            	= $("#sel_up_dispYn").val();
	var boardSeq          	= $("#txt_up_boardSeq").val();
	
	var inputData = {"noticeSeq": noticeSeq , "noticeDesc": noticeDesc , "noticeFilePath": noticeFilePath , "dispYn": dispYn, "boardSeq": boardSeq, "type": type};
	
	if(type == "I"){
		var result = confirm('추가 하시겠습니까?');
	}else if(type == "U"){
		var result = confirm('수정 하시겠습니까?');
	}else{
		var result = confirm('삭제하시겠습니까?');
	}
	
	if(result){
		fun_ajaxPostSend("/notice/save/noticeSave.do", inputData, true, function(msg){
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

function fun_setboardListInfo() {
	boardListInfo = $("#boardListInfo").DataTable({
		"columns": [
			  {"data": "listIndex"}
			, {"data": "boardSeq"}
			, {"data": "boardDiv"}
			, {"data": "title"}
			, {"data": "viewCnt"}
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
			 , {
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
				, "class": "text-center"
			}
			, {
				"targets": [5]
				, "class": "text-center"
			}
			, {
				"targets": [6]
				, "class": "text-center"
				, "render": function (data, type, row) {
					var msg = row.boardSeq;
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" onclick="fun_selectBoard(' + msg + ')">선택</button>'; 
					return insertTr;
                }
			}
		]
	});
	
	fun_board_search();
};

function fun_board_search(){
	
	var inputData = {"boardDiv": "", "searchText": "","searchStartDt": "","searchEndDt": ""};
	fun_ajaxPostSend("/board/select/boardAllList.do", inputData, true, function(msg){
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
			fun_dataTableAddData("#boardListInfo", tempResult);
		}
	});
}

function fun_board_select(){
	$("#section1_detail_edit").hide();
	fun_board_search();
	$("#section1_detail_edit_board").show();
}

function fun_selectBoard(boardSeq){
	
	$("#txt_up_boardSeq").val(boardSeq);
	
	$("#section1_detail_edit_board").hide();
	$("#section1_detail_edit").show();
	
}
</script>
    <div class="wrapper">
          <div class="content-wrapper">
            <!-- 상단 title -->
            <div class="content-header">
               <div class="container-fluid">
                  <div class="row">
                     <div class="col">
                        <h1 class="title">앱 공지</h1>
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
                                        <th>검색어</th>
                                        <td colspan="3">
                                           <div class="row row-10 align-items-center">
                                                  <input type="text" style="width:90%;" class="form-control" placeholder="제목,내용" name="searchText" onKeypress="" id="txt_searchText"/>
                                                  <input type="checkbox" style="width:34px; margin-left: 1%;" class="form-control" id="chk_searchTable"  />
                                           </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="btns">
                                <button type="button" class="btn btn-dark min-width-90px" onclick="fun_search()">검색</button>
                            </div>
                        </div>
                    </section>

                    <section id="section1">
                        <div class="row justify-content-between align-items-end mb-3">
                        	<input  type="hidden" id="totalCnt" name="totalCnt" />
                            <div class="col-auto">
                            </div>
                            <div class="col-auto">
                            	<button type="button" class="btn btn-primary mr-1" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_update('insert')">앱공지 등록</button>
                                <button type="button" class="btn btn-outline-primary mr-1" onclick="fn_go_list_excel()">엑셀다운로드</button>
                                <select id="noticeListLength" class="custom-select w-auto">
                                	<option value="10">10</option>
                                	<option value="20">20</option>
                                	<option value="50">50</option>
                                </select>
                            </div>
                        </div>
                         <div class="main_search_result_list">
                                <table id="noticeListInfo" class="table table-bordered">
                                    <thead>
                                    	<tr>
	                                        <th class="text-center" width="5%">번호</th>
	                                       	<th class="text-center" width="8%">공지팝업SEQ</th>
	                                        <th class="text-center" width="25%">공지팝업 설명</th>
	                                        <th class="text-center">공지팝업 이미지 PATH</th>
	                                        <th class="text-center" width="7%">노출여부</th>
	                                        <th class="text-center" width="10%">연결 게시글SEQ</th>
	                                        <th class="text-center" width="12%">등록일시</th>
	                                        <th class="text-center" width="7%">관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                        </div>
                	</section>
                </div>
                
                <!-- 모달창 start -->
                <div class="modal fade" id="exampleModalScrollable" tabindex="-1" role="dialog" aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
                  <div class="modal-dialog modal-dialog-scrollable" role="document">
                    <!-- 상세보기 start-->
                    <section id="section1_detail_view" style="display:none;">
                        <div class="modal-content" style="width: 1200px;">
                          <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalScrollableTitle">앱공지 상세보기</h5>
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
                                     <th>공지팝업 설명</th>
                                     <td colspan="3">
                                     	<input class="form-control" type="hidden" id="hidden_noticeSeq"/>
                                     	<textarea class="form-control" id="txt_noticeDesc" style="height:100px;" readOnly></textarea>
                                     </td>	
                                  </tr>
                                  <tr>
                                     <th>공지팝업 이미지 PATH</th>
                                     <td colspan="3"><input class="form-control" type="text" id="txt_noticeFilePath" readOnly/></td>
                                  </tr>
                                  <tr>
                                  	<th>노출여부</th>
                                     <td>
                                     	<select class="form-control" id="sel_dispYn" disabled>
                                                <option value="Y">노출</option>
                                                <option value="N">비노출</option>
                                       </select>
                                     </td>
                                     <th>연결 게시글SEQ</th>
                                     <td>
                                     	<input class="form-control" type="text" id="txt_boardSeq" readOnly/>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>등록일</th>
                                     <td colspan="3"><input class="form-control" type="text" id="txt_insDt" readOnly/></td>
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                          <button type="button" class="btn btn-primary" onclick="fun_update('edit');">수정</button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                          </div>
                        </div>
                    </section>
                    <!-- 상세보기 end-->
                    
                    <!-- 상세보기 등록,수정 start-->
                    <section id="section1_detail_edit" style="display:none;">
                        <div class="modal-content" style="width: 1200px;">
                          <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalScrollableTitle">앱공지 수정</h5>
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
                                  <col style="width:25%">
                                  <col style="width:10%">
                               </colgroup>
                               <tbody>
                                <tbody>
                                  <tr>
                                     <th>공지팝업 설명</th>
                                     <td colspan="4">
                                     	<textarea class="form-control" type="text" id="txt_up_noticeDesc" style="height:100px;"></textarea>
                                     </td>	
                                  </tr>
                                  <tr>
                                     <th>공지팝업 이미지 PATH</th>
                                     <td colspan="4"><input class="form-control" type="text" id="txt_up_noticeFilePath" /></td>
                                  </tr>
                                  <tr>
                                  	 <th>노출여부</th>
                                     <td>
                                     	<select class="form-control" id="sel_up_dispYn">
                                                <option value="Y">노출</option>
                                                <option value="N">비노출</option>
                                       </select>
                                     </td>
                                     <th>연결 게시글SEQ</th>
                                     <td>
                                     	<input class="form-control" type="text" id="txt_up_boardSeq" numberOnly />
                                     </td>
                                     <td> 
										<button type="button" class="btn btn-primary" id="btnUpper"  onclick="return fun_board_select();">선택</button>
									</td>
                                  </tr>
                                  <tr>
                                     <th>등록일</th>
                                     <td colspan="4"><input class="form-control" type="text" id="txt_up_insDt" readOnly /></td>
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                            <button type="button" id="btn_insert" class="btn btn-primary" onclick="fun_save('I');">저장</button>
                            <button type="button" id="btn_update" class="btn btn-primary" onclick="fun_save('U');">저장</button>
                            <button type="button" id="btn_delete" class="btn btn-danger" onclick="fun_save('D');">삭제</button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                          </div>
                        </div>
                    </section>
                    
                    <!-- 상세보기 수정 - 공지사항 start-->
                    <section id="section1_detail_edit_board" style="display:none;">
                        <div class="modal-content" style="width: 1200px;">
                          <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalScrollableTitle">앱공지 - 공지사항 선택</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                              <span aria-hidden="true">&times;</span>
                            </button>
                          </div>
                          <div class="modal-body">
                            <table id="boardListInfo" class="table table-bordered">
                                    <thead>
                                    	<tr>
	                                        <th class="text-center">번호</th>
	                                       	<th class="text-center">공지사항번호</th>
	                                        <th class="text-center">구분</th>
	                                        <th class="text-center">제목</th>
	                                        <th class="text-center">조회수</th>
	                                        <th class="text-center">등록날짜</th>
	                                        <th class="text-center">관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                          </div>
                          <div class="modal-footer">
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