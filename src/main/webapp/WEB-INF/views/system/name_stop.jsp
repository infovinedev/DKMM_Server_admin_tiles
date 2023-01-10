<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
var nameStopListInfo;

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
	
	
	fun_setNameStopListInfo();
	
	$("#nameStopLength").change(function(){
		var length = $("#nameStopLength").val();
		$("#nameStopInfo").DataTable().page.len(length).draw();
	});
	
	$("#txt_searchText").on('keyup click', function () {
		searchDataTable();	   
	});
	
	$("#chk_searchTable").on('keyup click', function () {
		searchDataTable();
	});
});

function searchDataTable(){
	 if($('#chk_searchTable').is(':checked')){
	      $("#nameStopInfo").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	   }
	else{
		$("#nameStopInfo").DataTable().search("").draw();
	}
}


function fun_search(){
	var searchText = $("#txt_searchText").val();
	var searchStartDt = $("#search_startDt").val();
	var searchEndDt = $("#search_endDt").val();
	
	$('#chk_searchTable').prop('checked', false);
	searchDataTable();
	
	var inputData = {"searchText": searchText, "searchStartDt": searchStartDt,"searchEndDt": searchEndDt};
	fun_ajaxPostSend("/system/select/nameStop.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			fun_dataTableAddData("#nameStopInfo", tempResult);
		}
	});
}

//text값 공백처리
function fun_reset(type){
	
	$("#txt_stopSeq").val("");
	$("#txt_rowNum").val("");
	$("#txt_useYn").val("");
	$("#txt_nickName").val("");
	$("#txt_insDt").val("");
}

var gfFlag = "I";
//상세보기
function fun_viewDetail(rowNum, stopSeq, nickName, useYn, insDt) {
	fun_reset();
	$("#btnCancel").show();
	$("#txt_rowNum").show();
	$("#txt_rowNum").attr("disabled",true); 
	$("#section1_detail_view").removeAttr("style");
	
	$("#txt_stopSeq").val(stopSeq);
	$("#txt_rowNum").val(rowNum);
	$("#txt_useYn").val(useYn);
	$("#txt_nickName").val(nickName);
	$("#txt_insDt").val(insDt);
	gfFlag = "U";
}

//상세보기
function fun_update(argFlag) {
	fun_reset();
	$("#btnCancel").hide();
	$("#txt_rowNum").hide();
	$("#txt_useYn").val("Y");
	$("#section1_detail_view").removeAttr("style");
	
	gfFlag = "I";
}

function fun_save(){
	
	if (!confirm("등록 하시겠습니까?")) return;
	
	var stopSeq = $("#txt_stopSeq").val();
	var nickName = $("#txt_nickName").val();
	var useYn = $("#txt_useYn").val();
	
	if ( nickName.trim() == "" ){
		alert("금지어를 입력해 주세요.");
		return;
	}
	
	var url = "";
	
	if ( gfFlag == "I" ){
		url = "/system/save/insertNameStop.do";
	}
	else{
		url = "/system/save/updateNameStop.do";
	}
		
	var inputData = {"stopSeq": stopSeq, "nickName": nickName,"useYn": useYn};
	fun_ajaxPostSend(url, inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					alert("등록되었습니다.");
					fun_search();
					$('#exampleModalScrollable').modal('hide');
					break;
				case "0001":
					alert("등록을 실패 하였습니다." + msg.errorMessage);
					break;
			}
		}
	});
	
}

function fun_delete(){
	
	if (!confirm("삭제 하시겠습니까?")) return;
	
	var stopSeq = $("#txt_stopSeq").val();
	var url = "/system/save/deleteNameStop.do";
		
	var inputData = {"stopSeq": stopSeq};
	fun_ajaxPostSend(url, inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					alert("삭제되었습니다.");
					fun_search();
					$('#exampleModalScrollable').modal('hide'); 
					break;
				case "0001":
					alert("삭제를 실패 하였습니다." + msg.errorMessage);
			}
		}
	});
	
}


function fun_setNameStopListInfo() {
	nameStopListInfo = $("#nameStopInfo").DataTable({
		"columns": [
			  {"data":  "rowNum"}
			, {"data": "nickName"}
			, {"data": "useYn"}
			, {"data": "insDt"}
			, {"data": "add" }
		]
		, "paging": true            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "autoWidth": true
 		, "scrollXInner": "100%"
		, "order": [[ 0, "desc" ]]
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
				, "class": "text-left"
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
				, "render": function (data, type, row, meta) {
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_viewDetail(\'' + row.rowNum + '\',\'' + row.stopSeq + '\',\'' + row.nickName + '\',\'' + row.useYn + '\',\'' + row.insDt + '\')">상세보기</button>'; 
					return insertTr;
                }
			}
		]
	});
	
	fun_search();
};
</script>

    <div class="wrapper">
          <div class="content-wrapper">
            <!-- 상단 title -->
            <div class="content-header">
               <div class="container-fluid">
                  <div class="row">
                     <div class="col">
                        <h1 class="title">금지어 관리</h1>
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
                                        <th>가입 기간</th>
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
                                                  <input type="text" style="width:94%;" class="form-control" placeholder="금지어명" id="txt_searchText" name="searchText" onKeypress="" />
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
                        	<input  type="hidden" id="totalCnt" name="totalCnt" />
                            <div class="col-auto">
                            </div>
                            <div class="col-auto">
                            	<button type="button" class="btn btn-primary mr-1" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_update('insert')">금지어등록</button>
                                <button type="button" class="btn btn-outline-success mr-1" onclick="fn_go_list_excel()">엑셀업로드</button>
                                <a href="/filedownloadWebLink.do?fName=nick_sample.xlsx" class="btn btn-outline-primary mr-1" download="금지어샘플.xlsx">엑셀샘플</a>
                                <button type="button" class="btn btn-outline-primary mr-1" onclick="fn_go_list_excel()">엑셀다운로드</button>
                                <select id="nameStopLength" class="custom-select w-auto">
                                	<option value="10">10</option> 
                                	<option value="20">20</option>
                                	<option value="50">50</option>
                                </select>
                            </div>
                        </div>
                         <div class="main_search_result_list">
                                <table id="nameStopInfo" class="table table-bordered">
                                    <thead>
                                    	<tr>
	                                        <th class="text-center" width="15%">번호</th>
	                                        <th class="text-center">금지어명</th>
	                                       	<th class="text-center" width="15%">사용여부</th>
	                                        <th class="text-center" width="15%">등록일</th>
	                                        <th class="text-center" width="15%">관리</th>
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
                            <h5 class="modal-title" id="exampleModalScrollableTitle">금지어 등록</h5>
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
                                     <th>번호</th>
                                     <td><input type="hidden" id="txt_stopSeq" readOnly/>
                                     	<input class="form-control" type="text" id="txt_rowNum" readOnly/></td>
                                     <th>사용여부</th>
                                     <td>
                                     		<select id="txt_useYn" class="custom-select w-auto">
			                                	<option value="Y">사용</option> 
			                                	<option value="N">미사용</option>
			                                </select>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>금지닉네임</th>
                                     <td><input class="form-control" type="text" id="txt_nickName" maxlength="18" /></td>
                                     <th>등록일</th>
                                     <td><input class="form-control" type="text" id="txt_insDt" readOnly/></td>
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-primary" onclick="fun_save();">저장</button>
                            <button type="button" id="btnCancel" class="btn btn-danger" onclick="fun_delete();" >삭제</button>
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
