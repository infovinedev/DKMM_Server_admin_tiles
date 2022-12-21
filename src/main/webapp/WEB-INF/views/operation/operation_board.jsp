<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 -->
<script>
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
	
	
	fun_setboardListInfo();
	
	$("#boardListLength").change(function(){
		var length = $("#boardListLength").val();
		$("#boardListInfo").DataTable().page.len(length).draw();
	});
	
	$("#txt_searchText").on('keyup click', function () {
		searchDataTable();	   
	});
	
	$("#chk_searchTable").on('keyup click', function () {
		searchDataTable();
	});
	
	$("#search_boardDiv").on('change', function () {
		fun_search();
	});
	
   
});

function searchDataTable(){
	 if($('#chk_searchTable').is(':checked')){
	      $("#boardListInfo").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	   }
	else{
		$("#boardListInfo").DataTable().search("").draw();
	}
}

function fun_search(){
	var boardDiv = $("#search_boardDiv").val();
	var searchText = "";//$("#txt_searchText").val();
	var searchStartDt = $("#search_startDt").val();
	var searchEndDt = $("#search_endDt").val();
	
	$('#chk_searchTable').prop('checked', false);
	searchDataTable();
	
	var inputData = {"boardDiv": boardDiv, "searchText": searchText,"searchStartDt": searchStartDt,"searchEndDt": searchEndDt};
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

//text값 공백처리
function fun_reset(type){
	$("#hidden_boardSeq").val("");
	$("#txt_boardDiv").val("");
	$("#txt_insDt").val("");
	$("#txt_title").val("");
	$("#txt_viewCnt").val("");
	$("#txt_content").val("");
}

//상세보기
function fun_viewDetail(boardSeq) {
	fun_reset();
	$("#section1_detail_edit").css("display", "none");
	$("#section1_detail_view").removeAttr("style");
	var inputData = {"boardSeq": boardSeq};
	fun_ajaxPostSend("/board/select/boardListDetail.do", inputData, true, function(msg){
		if(msg!=null){
			var tempResult = JSON.parse(msg.result);
			var boardSeq = tempResult.boardSeq == null ? "N/A" : tempResult.boardSeq;                    //공지사항번호
			var boardDiv  = tempResult.boardDiv == null ? "N/A" : tempResult.boardDiv;                   //구분
			var insDt  = tempResult.insDt == null ? "N/A" : tempResult.insDt;                            //등록일
			var title = tempResult.title == null ? "N/A" : tempResult.title;                             //제목
			var viewCnt  = tempResult.viewCnt == null ? "N/A" : tempResult.viewCnt;                      //조회수
			var content  = tempResult.content == null ? "N/A" : tempResult.content;                      //내용
			//상세보기 데이터	
			$("#hidden_boardSeq").val(boardSeq);
			$("#txt_boardDiv").val(boardDiv);
			$("#txt_insDt").val(insDt);
			$("#txt_title").val(title);
			$("#txt_viewCnt").val(viewCnt);
			$("#txt_content").val(content);
			
			//상세보기 수정 데이터
			$("#hidden_up_boardSeq").val(boardSeq);
			$("#search_up_boardDiv").val(boardDiv);
			$("#txt_up_insDt").val(insDt);
			$("#txt_up_title").val(title);
			$("#txt_up_viewCnt").val(viewCnt);
			$("#txt_up_content").val(content);
		}
	});
}

function fun_update(type) {
	$("#btn_insert").show();
	$("#btn_update").show();
	$("#btn_delete").show();
	
	if(type == "insert"){
		$("#btn_update").hide();
		$("#btn_delete").hide();
		var sDate = c21.date_today("yyyy-MM-dd hh:mm:ss");
		
		$("#hidden_up_boardSeq").val("");
		$("#search_up_boardDiv").val("");
		$("#txt_up_insDt").val(sDate);
		$("#txt_up_title").val("");
		$("#txt_up_viewCnt").val("");
		$("#txt_up_content").val("");
	}else{
		$("#btn_insert").hide();
	}
	$("#section1_detail_view").css("display", "none");
	$("#section1_detail_edit").removeAttr("style");
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
	var boardSeq         = $("#hidden_up_boardSeq").val();
	var boardDiv         = $("#search_up_boardDiv").val();
	var insDt            = $("#txt_up_insDt").val();
	var title            = $("#txt_up_title").val();
	var viewCnt          = $("#txt_up_viewCnt").val();
	var content          = $("#txt_up_content").val();
	
	var inputData = {"boardSeq": boardSeq , "boardDiv": boardDiv , "insDt": insDt , "title": title, "viewCnt": viewCnt, "content": content,"type": type};
	if(type == "I"){
		var result = confirm('추가 하시겠습니까?');
	}else if(type == "U"){
		var result = confirm('수정 하시겠습니까?');
	}else{
		var result = confirm('삭제하시겠습니까?');
	}
	
	if(result){
		fun_ajaxPostSend("/board/save/boardSave.do", inputData, true, function(msg){
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
    <div class="wrapper">
          <div class="content-wrapper">
            <!-- 상단 title -->
            <div class="content-header">
               <div class="container-fluid">
                  <div class="row">
                     <div class="col">
                        <h1 class="title">공지사항</h1>
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
                                        <th>구분</th>
                                        <td>
                                            <select class="form-control" id="search_boardDiv" style="width:80%;">
                                                <option value="">선택</option>
                                                <option value="INFO">공지사항</option>
                                                <option value="UPDATE">업데이트</option>
                                                <option value="EVENT">이벤트</option>
                                            </select>
                                        </td>
                                        <th>검색어</th>
                                        <td>
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
                            	<button type="button" class="btn btn-primary mr-1" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_update('insert')">공지사항 등록</button>
                                <button type="button" class="btn btn-outline-primary mr-1" onclick="fn_go_list_excel()">엑셀다운로드</button>
                                <select id="boardListLength" class="custom-select w-auto">
                                	<option value="10">10</option>
                                	<option value="20">20</option>
                                	<option value="50">50</option>
                                </select>
                            </div>
                        </div>
                         <div class="main_search_result_list">
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
                	</section>
                </div>
                
                <!-- 모달창 start -->
                <div class="modal fade" id="exampleModalScrollable" tabindex="-1" role="dialog" aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
                  <div class="modal-dialog modal-dialog-scrollable" role="document">
                    <!-- 상세보기 start-->
                    <section id="section1_detail_view" style="display:none;">
                        <div class="modal-content" style="width: 1200px;">
                          <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalScrollableTitle">상세보기</h5>
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
                                     <th>구분</th>
                                     <td><input class="form-control" type="text" id="txt_boardDiv" readOnly/>
                                         <input class="form-control" type="hidden" id="hidden_boardSeq" readOnly/>
                                     </td>
                                     <th>등록일</th>
                                     <td><input class="form-control" type="text" id="txt_insDt" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>제목</th>
                                     <td><input class="form-control" type="text" id="txt_title" readOnly/></td>
                                     <th>조회수</th>
                                     <td><input class="form-control" type="text" id="txt_viewCnt" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>내용</th>
                                     <td colspan="3">
                                        <textarea class="form-control" type="text" id="txt_content" style="height:300px;" readOnly></textarea>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>이미지첨부</th>
                                     <td colspan="3">추후작업</td>
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
                            <h5 class="modal-title" id="exampleModalScrollableTitle">공지사항 수정</h5>
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
                                <tbody>
                                  <tr>
                                     <th>구분</th>
                                     <td>
                                       <select class="form-control" id="search_up_boardDiv">
                                                <option value="">선택</option>
                                                <option value="INFO">공지사항</option>
                                                <option value="UPDATE">업데이트</option>
                                                <option value="EVENT">이벤트</option>
                                       </select>
                                         <input class="form-control" type="hidden" id="hidden_up_boardSeq" readOnly/>
                                     </td>
                                     
                                     
                                     <th>등록일</th>
                                     <td><input class="form-control" type="text" id="txt_up_insDt" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>제목</th>
                                     <td colspan="3"><input class="form-control" type="text" id="txt_up_title"/></td>
                                  </tr>
                                  <tr>
                                     <th>내용</th>
                                     <td colspan="3">
                                        <textarea class="form-control" type="text" id="txt_up_content" style="height:300px;"></textarea>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>이미지첨부</th>
                                     <td colspan="3">추후작업</td>
                                  </tr>
                               </tbody>
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
                  </div>
                </div>
                <!-- 상세보기 모달창 end -->
                
            </div>
        </div>
    </div>