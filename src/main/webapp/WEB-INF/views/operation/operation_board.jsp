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
	   if($('#chk_searchTable').is(':checked')){
	      $("#boardListInfo").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	   }
   });
});

function fun_search(){
	var boardDiv = $("select[name=search_boardDiv]").val();
	var searchText = $("input[name=searchText]").val();
	var searchStartDt = $("#search_startDt").val();
	var searchEndDt = $("#search_endDt").val();
	
	var inputData = {"boardDiv": boardDiv, "searchText": searchText,"searchStartDt": searchStartDt,"searchEndDt": searchEndDt};
	fun_ajaxPostSend("/board/select/boardAllList.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			fun_dataTableAddData("#boardListInfo", tempResult);
		}
	});
}

//text값 공백처리
function fun_reset(type){
	$("#txt_boardSeq").val("");
	$("#txt_ctgryNm").val("");
	$("#txt_boardNm").val("");
	$("#txt_boardTel").val("");
	$("#txt_likeCnt").val("");
	$("#txt_areaTot").val("");
	$("#txt_maxCnt").val("");
	$("#txt_boardEndTime").val("");
	$("#txt_boardOpenTime").val("");
	
}

//상세보기
function fun_viewDetail(boardSeq) {
	fun_reset();
	$("#section1_detail_edit").css("display", "none");
	$("#section1_detail_view").removeAttr("style");
	var inputData = {"boardSeq": boardSeq};
	fun_ajaxPostSend("/board/select/boardInfoDetail.do", inputData, true, function(msg){
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
		/*	document.getElementById('upboardSeq').innerText=boardSeq;
			$("#txt_upboardSeq").val(boardSeq);
			$("#txt_upCtgryNm").val(ctgryNm);
			$("#txt_upboardNm").val(boardNm);
			$("#txt_upboardTel").val(boardTel);
			$("#txt_upLikeCnt").val(likeCnt);
			$("#txt_upAreaTot").val(areaTot);
			$("#txt_upMaxCnt").val(maxCnt);
			$("#txt_upboardOpenTime").val(boardOpenTime);
			$("#txt_upboardEndTime").val(boardEndTime);
			$("#txt_upboardHolidayType").val(boardHolidayType);
			$("#txt_upCompanyNo").val(companyNo);
			$("#txt_upLatitude").val(latitude);
			$("#txt_upLongitude").val(longitude);*/
			
		}
	});
}
function fun_update(type) {
	if(type == "insert"){
		fun_reset(type);
	}
	$("#section1_detail_view").css("display", "none");
	$("#section1_detail_edit").removeAttr("style");
}

function fun_setboardListInfo() {
	boardListInfo = $("#boardListInfo").DataTable({
		"columns": [
			  {"data": "rowNum"}
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
};

function fun_save(type){
	var boardSeq         = $("#txt_upboardSeq").val();
	var ctgryNm          = $("#select_upCtgryNm").val()
	var boardNm          = $("#txt_upboardNm").val();
	var boardTel         = $("#txt_upboardTel").val();
	var likeCnt          = $("#txt_upLikeCnt").val();
	var areaTot          = $("#txt_upAreaTot").val();
	var maxCnt           = $("#txt_upMaxCnt").val();
	var boardOpenTime    = $("#txt_upboardOpenTime").val();
	var boardEndTime     = $("#txt_upboardEndTime").val();
	var boardHolidayType = $("#txt_upboardHolidayType").val();
	var companyNo        = $("#txt_upCompanyNo").val();
	var latitude         = $("#txt_upLatitude").val();
	var longitude        = $("#txt_upLongitude").val();

	var inputData = {"ctgryNm": ctgryNm , "boardNm": boardNm , "boardTel": boardTel , "likeCnt": likeCnt
					,"areaTot": areaTot , "maxCnt": maxCnt , "boardOpenTime": boardOpenTime, "boardEndTime": boardEndTime
					, "boardHolidayType": boardHolidayType , "companyNo": companyNo , "latitude": latitude
					, "longitude": longitude
					};
	fun_ajaxPostSend("/board/save/boardInfo.do", inputData, true, function(msg){
	});
}
</script>
<body class="hold-transition sidebar-mini">
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
                                            <select class="form-control" name="search_boardDiv">
                                                <option value="">선택</option>
                                                <option value="감성주점">공지사항</option>
                                                <option value="경양식">업데이트</option>
                                                <option value="기타">이벤트</option>
                                                <option></option>
                                            </select>
                                        </td>
                                        <th>검색어</th>
                                        <td>
                                           <div class="row row-10 align-items-center">
                                                  <input type="text" style="width:94%;" class="form-control" placeholder="매장명" name="searchText" onKeypress="" id="txt_searchText"/>
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
                            	<!-- <a href="javascript:;" class="btn btn-primary mr-1"  onclick="fun_viewDetail()">매장등록</a> -->
                            	<button type="button" class="btn btn-primary mr-1" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_update('insert')">매장등록</button>
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
                
                <!-- 상세보기 모달창 start -->
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
                                         <input class="form-control" type="hidden" id="hidden_boardSeq" readOnly/><
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
                                     <td><input class="form-control" type="text" id="txt_content" readOnly/></td>
                                     <th>이미지첨부</th>
                                     <td>추후작업</td>
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                            <!-- 추후사용 <button type="button" class="btn btn-primary" onclick="fun_update('edit');">수정</button> -->
                          </div>
                        </div>
                    </section>
                    <!-- 상세보기 end-->
                    <!-- 상세보기 등록,수정 start-->
                    <section id="section1_detail_edit" style="display:none;">
                        <div class="modal-content" style="width: 1200px;">
                          <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalScrollableTitle">매장수정</h5>
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
                                     <th>등록매장번호</th>
                                     <td id="upboardSeq"><input class="form-control" type="hidden" id="hidden_upboardSeq" readOnly/></td>
                                     <th>매장 카테고리 <span class="text-red">*</span></th>
                                     <td>
                                     <input class="form-control" type="hidden" id="txt_upCtgryNm"/>
                                     <select class="form-control" id="select_upCtgryNm" name="select_upCtgryNm">
                                                <option value="">선택</option>
                                                <option value="감성주점">감성주점</option>
                                                <option value="경양식">경양식</option>
                                                <option></option>
                                            </select>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>매장명 <span class="text-red">*</span></th>
                                     <td ><input class="form-control" id="txt_upboardNm"/></td>
                                     <th>매장 전화번호</th>
                                     <td><input class="form-control" type="text" id="txt_upboardTel"/></td>
                                  </tr>
                                  <tr>
                                     <th >매장 찜 받은 수</th>
                                     <td id="upLikeCnt"><input class="form-control" type="hidden" id="hidden_upLikeCnt"/></td>
                                     <th>매장면적</th>
                                     <td><input class="form-control" type="text" id="txt_upAreaTot"/></td>
                                  </tr>
                                  <tr>
                                     <th>최대수용인원</th>
                                     <td><input class="form-control" type="text" id="txt_upMaxCnt"/></td>
                                     <th>매장영업시간</th>
                                     <td>
                                        <div class="row row-10 align-items-center">
	                                       <div class="col-auto col-sm-5"> 
	                                          <input class="form-control" type="text" id="txt_upboardEndTime"/>
	                                       </div> ~
	                                       <div class="col-auto col-sm-5">
	                                          <input class="form-control" type="text" id="txt_upboardOpenTime" />
	                                       </div>
                                        </div>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>매장휴무일</th>
                                     <td><input class="form-control" type="text" id="txt_upboardHolidayType"/></td>
                                     <th>매장주소 <span class="text-red">*</span></th>
                                     <td>
			                            <div class="row row-10 align-items-center">
			                              <div class="col-auto col-sm-2">
			                                   <input type="text" class="form-control addressZip" name="zip" placeholder="우편번호"/>
			                               </div>
			                               <div class="col-auto col-sm-8">
			                                   <input type="text" class="form-control address" name="addr" placeholder="주소" disabled/>
			                               </div>
			                               <div class="col-auto">
			                                  <button type="button" class="btn btn-dark" onclick="c21.api_zipAddress(fun_post_callback);">주소검색</button>
			                               </div>
			                            </div>
			                            <div class="row row-10 align-items-center">
			                               <div class="col-auto col-sm-10">
			                                  <input type="text" class="form-control addrDetail mt-1" name="addrDetail" placeholder="상세 주소"/>
			                               </div>
			                            </div>
			                         </td>
                                  </tr>
                                  <tr>
                                     <th>사업자등록번호</th>
                                     <td><input class="form-control" type="text" id="txt_upCompanyNo"/></td>
                                     <th>매장좌표</th>
                                     <td>
                                       <div class="row row-10 align-items-center">
	                                         <div class="col-auto col-sm-5"> 
	                                            <input type="text" class="form-control" id="txt_upLatitude" placeholder="위도" disabled/>
	                                         </div>
	                                         <div class="col-auto col-sm-5">
	                                            <input type="text" class="form-control" id="txt_upLongitude" placeholder="경도" disabled/>
	                                         </div>
                                       </div>
                                     </td>
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                            <button type="button" class="btn btn-primary" onclick="fun_save();">저장</button>
                            <button type="button" class="btn btn-danger">삭제</button>
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
    
