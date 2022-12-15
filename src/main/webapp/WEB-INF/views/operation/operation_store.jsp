<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 -->
<script>
var storeListInfo;
var beforeCtgry;

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
	
	$("#storeListLength").change(function(){
		var length = $("#storeListLength").val();
		$("#storeListInfo").DataTable().page.len(length).draw();
	});
	
   $("#txt_searchText").on('keyup click', function () {
		searchDataTable();	   
	});
	
	$("#chk_searchTable").on('keyup click', function () {
		searchDataTable();
	});
	
	$("#search_ctgryNm").on('focus', function () {
		beforeCtgry = $("#search_ctgryNm").val();
	});
	
	$("#search_ctgryNm").on('change', function () {
		fun_search();
	});
	
});

function searchDataTable(){
	 if($('#chk_searchTable').is(':checked')){
	      $("#storeListInfo").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	   }
	else{
		$("#storeListInfo").DataTable().search("").draw();
	}
}

function fun_search(){
	
	var ctgryNm = $("select[name=search_ctgryNm]").val();
	var searchText = ""; //$("input[name=searchText]").val();
	var searchStartDt = $("#search_startDt").val();
	var searchEndDt = $("#search_endDt").val();
	
	if ( ctgryNm == "" ){
		alert("카테고리를 선택해 주세요.");
		$("select[name=search_ctgryNm]").val(beforeCtgry);
		return;
	}
	
	$('#chk_searchTable').prop('checked', false);
	searchDataTable();
	
	var inputData = {"ctgryNm": ctgryNm, "searchText": searchText, "searchStartDt" : searchStartDt, "searchEndDt" : searchEndDt};
	fun_ajaxPostSend("/store/select/storeInfo.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			fun_dataTableAddData("#storeListInfo", tempResult);
		}
	});
}

//text값 공백처리
function fun_reset(type){
	$("#txt_storeSeq").val("");
	$("#txt_ctgryNm").val("");
	$("#txt_storeNm").val("");
	$("#txt_storeTel").val("");
	$("#txt_likeCnt").val("");
	$("#txt_areaTot").val("");
	$("#txt_maxCnt").val("");
	//$("#txt_opening").val(opening);
	$("#txt_storeEndTime").val("");
	$("#txt_storeOpenTime").val("");
	
	$("#txt_storeHolidayType").val("");
	$("#txt_insDt").val("");
	$("#txt_roadAddr").val("");
	$("#txt_zip").val("");
	$("#txt_companyNo").val("");
	$("#txt_lastWaitPersonCnt").val("");
	$("#txt_lastWaitInsDt").val("");
	
	//상세보기 수정 데이터
	
	
	if(type == "insert"){
		document.getElementById('upStoreSeq').innerText=0;
		document.getElementById('upLikeCnt').innerText=0;
		$("#hidden_upStoreSeq").val("0");
		$("#hidden_upLikeCnt").val("0");
	}else{
		document.getElementById('upStoreSeq').innerText="";
		document.getElementById('upLikeCnt').innerText="";
		$("#hidden_upStoreSeq").val("");
		$("#hidden_upLikeCnt").val("");
	}
	$("#txt_upStoreSeq").val("");
	$("#txt_upStoreSeq").val("");
	$("#select_upCtgryNm").val("")
	$("#txt_upStoreNm").val("");
	$("#txt_upStoreTel").val("");
	$("#txt_upAreaTot").val("");
	$("#txt_upMaxCnt").val("");
	$("#txt_upStoreOpenTime").val("");
	$("#txt_upStoreEndTime").val("");
	$("#txt_upStoreHolidayType").val("");
	$("#txt_upLatitude").val("");
	$("#txt_upLongitude").val("");
	
}

//상세보기
function fun_viewDetail(storeSeq) {
	fun_reset();
	$("#section1_detail_edit").css("display", "none");
	$("#section1_detail_view").removeAttr("style");
	var inputData = {"storeSeq": storeSeq};
	fun_ajaxPostSend("/store/select/storeInfoDetail.do", inputData, true, function(msg){
		if(msg!=null){
			var tempResult = JSON.parse(msg.result);
			var storeSeq = tempResult.storeSeq == null ? "N/A" : tempResult.storeSeq;                             //등록매장번호
			var ctgryNm  = tempResult.ctgryNm == null ? "N/A" : tempResult.ctgryNm;                               //매장카테고리
			var storeNm  = tempResult.storeNm == null ? "N/A" : tempResult.storeNm;                               //매장명
			var storeTel = tempResult.storeTel == null ? "N/A" : tempResult.storeTel;                             //매장 전화번호
			var likeCnt  = tempResult.likeCnt == null ? "N/A" : tempResult.likeCnt;                               //매장 찜 받은 수
			var areaTot  = tempResult.areaTot == null ? "N/A" : tempResult.areaTot;                               //매장면적
			var maxCnt   = tempResult.maxCnt == null ? "N/A" : tempResult.maxCnt;                                 //최대수용인원
			var storeOpenTime = tempResult.storeOpenTime == null ? "-" : tempResult.storeOpenTime;                //매장영업시간
			var storeEndTime = tempResult.storeEndTime == null ? "-" : tempResult.storeEndTime;                   //매장종료시간
			var opening = storeOpenTime + "~" + storeEndTime;                                                     //영업시간 
			var storeHolidayType = tempResult.storeHolidayType == null ? "N/A" : tempResult.storeHolidayType;     //매장휴무일
			//var                                                                                                 //매장 대기등록 된 횟수 컬럼없음
			var insDt = tempResult.insDt == null ? "N/A" : tempResult.insDt;                                      //매장등록일
			var roadAddr = tempResult.roadAddr == null ? "N/A" : tempResult.roadAddr;                             //도로명주소
			//var                                                                                                 //지번주소 컬럼없음                                                                                
			var zip = tempResult.roadZip == null ? "N/A" : tempResult.roadZip;                                    //우편번호
			var latitude = tempResult.latitude == null ? "N/A" : tempResult.latitude;                             //위도
			var longitude = tempResult.longitude == null ? "N/A" : tempResult.longitude;                          //경도
			var companyNo = tempResult.companyNo == null ? "N/A" : tempResult.companyNo;                          //사업자등록번호
			var lastWaitPersonCnt = tempResult.lastWaitPersonCnt == null ? "N/A" : tempResult.lastWaitPersonCnt;  //마지막대기등록수	
			var lastWaitInsDt = tempResult.lastWaitInsDt == null ? "N/A" : tempResult.lastWaitInsDt;              //마지막대기등록일자
			//상세보기 데이터			
			$("#txt_storeSeq").val(storeSeq);
			$("#txt_ctgryNm").val(ctgryNm);
			$("#txt_storeNm").val(storeNm);
			$("#txt_storeTel").val(storeTel);
			$("#txt_likeCnt").val(likeCnt);
			$("#txt_areaTot").val(areaTot);
			$("#txt_maxCnt").val(maxCnt);
			//$("#txt_opening").val(opening);
			$("#txt_storeEndTime").val(storeEndTime);
			$("#txt_storeOpenTime").val(storeOpenTime);
			
			$("#txt_storeHolidayType").val(storeHolidayType);
			$("#txt_insDt").val(insDt);
			$("#txt_roadAddr").val(roadAddr);
			$("#txt_zip").val(roadZip);
			$("#txt_companyNo").val(companyNo);
			$("#txt_lastWaitPersonCnt").val(lastWaitPersonCnt);
			$("#txt_lastWaitInsDt").val(lastWaitInsDt);
			
			//상세보기 수정 데이터
			document.getElementById('upStoreSeq').innerText=storeSeq;
			$("#txt_upStoreSeq").val(storeSeq);
			$("#txt_upCtgryNm").val(ctgryNm);
			$("#txt_upStoreNm").val(storeNm);
			$("#txt_upStoreTel").val(storeTel);
			$("#txt_upLikeCnt").val(likeCnt);
			$("#txt_upAreaTot").val(areaTot);
			$("#txt_upMaxCnt").val(maxCnt);
			$("#txt_upStoreOpenTime").val(storeOpenTime);
			$("#txt_upStoreEndTime").val(storeEndTime);
			$("#txt_upStoreHolidayType").val(storeHolidayType);
			$("#txt_upCompanyNo").val(companyNo);
			$("#txt_upLatitude").val(latitude);
			$("#txt_upLongitude").val(longitude);
			
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

function fun_setStoreListInfo() {
	storeListInfo = $("#storeListInfo").DataTable({
		"columns": [
			 {"data": "storeSeq"}
			, {"data": "ctgryNm"}
			, {"data": "storeNm"}
			, {"data": "roadAddr"}
			, {"data": "likeCnt" }
			, {"data": "lastWaitPersonCnt" }
			, {"data": "lastWaitInsDt" }
			, {"data": "add" }
		]
		, "paging": true            // Table Paging
		, "info": false             // 'thisPage of allPage'
		, "autoWidth": true
/* 		, "scrollY": "350px"
		, "scrollCollapse": true
		, "scrollX": true   */
 		, "scrollXInner": "100%"
		, "order": [[ 1, "desc" ]]
		, "deferRender": true           // defer
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
			,{
				"targets": [1]
				, "class": "text-center"
			}
			 , {
				"targets": [2]
				, "class": "text-left"
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
			}
			, {
				"targets": [7]
				, "class": "text-center"
				, "render": function (data, type, row) {
					var msg = row.storeSeq;
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_viewDetail(' + msg + ')">상세보기</button>'; 
					return insertTr;
                }
			}
		]
	});
	
	fun_search();
};

function fun_save(type){
	var storeSeq         = $("#txt_upStoreSeq").val();
	var ctgryNm          = $("#select_upCtgryNm").val()
//	var ctgryNm          = $("#txt_upCtgryNm").val();
	var storeNm          = $("#txt_upStoreNm").val();
	var storeTel         = $("#txt_upStoreTel").val();
	var likeCnt          = $("#txt_upLikeCnt").val();
	var areaTot          = $("#txt_upAreaTot").val();
	var maxCnt           = $("#txt_upMaxCnt").val();
	var storeOpenTime    = $("#txt_upStoreOpenTime").val();
	var storeEndTime     = $("#txt_upStoreEndTime").val();
	var storeHolidayType = $("#txt_upStoreHolidayType").val();
	var companyNo        = $("#txt_upCompanyNo").val();
	var latitude         = $("#txt_upLatitude").val();
	var longitude        = $("#txt_upLongitude").val();

	var inputData = {"ctgryNm": ctgryNm , "storeNm": storeNm , "storeTel": storeTel , "likeCnt": likeCnt
					,"areaTot": areaTot , "maxCnt": maxCnt , "storeOpenTime": storeOpenTime, "storeEndTime": storeEndTime
					, "storeHolidayType": storeHolidayType , "companyNo": companyNo , "latitude": latitude
					, "longitude": longitude
					};
	fun_ajaxPostSend("/store/save/storeInfo.do", inputData, true, function(msg){
	});
}
function fun_post_callback(data){
	var address = data.address;
	var post = data.zonecode;
	$(".addressZip").val(post);
	$(".address").val(address);
	$(".addrDetail").val("");
	fun_get_mapXY (address);
}

function fun_get_mapXY (address) {
	var inputData = {"addr": address};
	fun_ajaxPostSend("/store/map/placeApi", inputData, true, function(msg){
		$("#txt_upLatitude").val(msg.latitude);
		$("#txt_upLongitude").val(msg.longitude);
	});
	
}

</script>
<head>
	<title>관리자 운영 - 매장관리</title>
</head>
<body class="hold-transition sidebar-mini">
    <div class="wrapper">
          <div class="content-wrapper">
            <!-- 상단 title -->
            <div class="content-header">
               <div class="container-fluid">
                  <div class="row">
                     <div class="col">
                        <h1 class="title">매장 관리</h1>
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
                                        <th>카테고리</th>
                                        <td>
                                            <select class="form-control" id="search_ctgryNm" name="search_ctgryNm" style="width:80%;">
                                                <option value="">선택</option>
                                                <option value="감성주점" selected>감성주점</option>
                                                <option value="경양식">경양식</option>
                                                <option value="기타">기타</option>
                                                <option value="기타 휴게음식점">기타 휴게음식점</option>
                                                <option value="김밥(도시락)">김밥(도시락)</option>
                                                <option value="까페">까페</option>
                                                <option value="냉면집">냉면집</option>
                                                <option value="라이브카페">라이브카페</option>
                                                <option value="복어취급">복어취급</option>
                                                <option value="분식">분식</option>
                                                <option value="뷔페식">뷔페식</option>
                                                <option value="식육(숯불구이)">식육(숯불구이)</option>
                                                <option value="외국음식전문점(인도,태국등)">외국음식전문점(인도,태국등)</option>
                                                <option value="이동조리">이동조리</option>
                                                <option value="일식">일식</option>
                                                <option value="전통찻집">전통찻집</option>
                                                <option value="정종/대포집/소주방">정종/대포집/소주방</option>
                                                <option value="중국식">중국식</option>
                                                <option value="출장조리">출장조리</option>
                                                <option value="커피숍">커피숍</option>
                                                <option value="키즈카페">키즈카페</option>
                                                <option value="탕류(보신용)">탕류(보신용)</option>
                                                <option value="통닭(치킨)">통닭(치킨)</option>
                                                <option value="패밀리레스트랑">패밀리레스트랑</option>
                                                <option value="패스트푸드">패스트푸드</option>
                                                <option value="한식">한식</option>
                                                <option value="호프/통닭">호프/통닭</option>
                                                <option value="횟집">횟집</option>
                                            </select>
                                        </td>
                                        <th>검색어</th>
                                        <td>
                                           <div class="row row-10 align-items-center">
                                                  <input type="text" style="width:90%;" class="form-control" placeholder="카테고리, 매장명, 매장 주소..." name="searchText" onKeypress="" id="txt_searchText"/>
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
                                <select id="storeListLength" class="custom-select w-auto">
                                	<option value="10">10</option>
                                	<option value="20">20</option>
                                	<option value="50">50</option>
                                </select>
                            </div>
                        </div>
                         <div class="main_search_result_list">
                                <table id="storeListInfo" class="table table-bordered">
                                    <thead>
                                    	<tr>
	                                        <th class="text-center" width="5%">번호</th>
	                                       	<th class="text-center" width="10%">카테고리</th>
	                                        <th class="text-center">매장명</th>
	                                        <th class="text-center" width="30%">매장주소</th>
	                                        <th class="text-center" width="5%">매장찜</th>
	                                        <th class="text-center" width="8%">마지막<br>대기등록수</th>
	                                        <th class="text-center" width="12%">마지막<br>대기등록일자</th>
	                                        <th class="text-center" width="8%">관리</th>
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
                                     <td><input class="form-control" type="text" id="txt_storeSeq" readOnly/></td>
                                     <th>매장 카테고리</th>
                                     <td><input class="form-control" type="text" id="txt_ctgryNm" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>매장명</th>
                                     <td><input class="form-control" type="text" id="txt_storeNm" readOnly/></td>
                                     <th>매장 전화번호</th>
                                     <td><input class="form-control" type="text" id="txt_storeTel" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>매장 찜 받은 수</th>
                                     <td><input class="form-control" type="text" id="txt_likeCnt" readOnly/></td>
                                     <th>매장면적</th>
                                     <td><input class="form-control" type="text" id="txt_areaTot" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>최대수용인원</th>
                                     <td><input class="form-control" type="text" id="txt_maxCnt" readOnly/></td>
                                     <th>매장영업시간</th>
                                     <td>
                                        <div class="row row-10 align-items-center">
	                                       <div class="col-auto col-sm-5"> 
	                                          <input class="form-control" type="text" id="txt_storeEndTime" readOnly/>
	                                       </div> ~
	                                       <div class="col-auto col-sm-5">
	                                          <input class="form-control" type="text" id="txt_storeOpenTime"readOnly />
	                                       </div>
                                        </div>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>매장휴무일</th>
                                     <td><input class="form-control" type="text" id="txt_storeHolidayType" readOnly/></td>
                                     <th>매장 대기등록 된 횟수</th>
                                     <td><input class="form-control" type="text" id="" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>매장등록일</th>
                                     <td><input class="form-control" type="text" id="txt_insDt" readOnly/></td>
                                     <th>도로명주소</th>
                                     <td><input class="form-control" type="text" id="txt_roadAddr" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>지번주소</th>
                                     <td><input class="form-control" type="text" id="" readOnly/></td>
                                     <th>우편번호</th>
                                     <td><input class="form-control" type="text" id="txt_zip" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>사업자등록번호</th>
                                     <td colspan="3"><input class="form-control" type="text" id="txt_companyNo" readOnly/></td>
                                  </tr>
                                  
                                  <tr>
                                     <th>마지막대기등록수</th>
                                     <td><input class="form-control" type="text" id="txt_lastWaitPersonCnt" readOnly/></td>
                                     <th>마지막대기등록일자</th>
                                     <td><input class="form-control" type="text" id="txt_lastWaitInsDt" readOnly/></td>
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
                                     <td id="upStoreSeq"><input class="form-control" type="hidden" id="hidden_upStoreSeq" readOnly/></td>
                                     <th>매장 카테고리 <span class="text-red">*</span></th>
                                     <td>
                                     <input class="form-control" type="hidden" id="txt_upCtgryNm"/>
                                     <select class="form-control" id="select_upCtgryNm" name="select_upCtgryNm">
                                                <option value="">선택</option>
                                                <option value="감성주점">감성주점</option>
                                                <option value="경양식">경양식</option>
                                                <option value="기타">기타</option>
                                                <option value="기타 휴게음식점">기타 휴게음식점</option>
                                                <option value="김밥(도시락)">김밥(도시락)</option>
                                                <option value="까페">까페</option>
                                                <option value="냉면집">냉면집</option>
                                                <option value="라이브카페">라이브카페</option>
                                                <option value="복어취급">복어취급</option>
                                                <option value="분식">분식</option>
                                                <option value="뷔페식">뷔페식</option>
                                                <option value="식육(숯불구이)">식육(숯불구이)</option>
                                                <option value="외국음식전문점(인도,태국등)">외국음식전문점(인도,태국등)</option>
                                                <option value="이동조리">이동조리</option>
                                                <option value="일식">일식</option>
                                                <option value="전통찻집">전통찻집</option>
                                                <option value="정종/대포집/소주방">정종/대포집/소주방</option>
                                                <option value="중국식">중국식</option>
                                                <option value="출장조리">출장조리</option>
                                                <option value="커피숍">커피숍</option>
                                                <option value="키즈카페">키즈카페</option>
                                                <option value="탕류(보신용)">탕류(보신용)</option>
                                                <option value="통닭(치킨)">통닭(치킨)</option>
                                                <option value="패밀리레스트랑">패밀리레스트랑</option>
                                                <option value="패스트푸드">패스트푸드</option>
                                                <option value="한식">한식</option>
                                                <option value="호프/통닭">호프/통닭</option>
                                                <option value="횟집">횟집</option>
                                                <option></option>
                                            </select>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>매장명 <span class="text-red">*</span></th>
                                     <td ><input class="form-control" id="txt_upStoreNm"/></td>
                                     <th>매장 전화번호</th>
                                     <td><input class="form-control" type="text" id="txt_upStoreTel"/></td>
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
	                                          <input class="form-control" type="text" id="txt_upStoreEndTime"/>
	                                       </div> ~
	                                       <div class="col-auto col-sm-5">
	                                          <input class="form-control" type="text" id="txt_upStoreOpenTime" />
	                                       </div>
                                        </div>
                                     </td>
                                  </tr>
                                  <tr>
                                     <th>매장휴무일</th>
                                     <td><input class="form-control" type="text" id="txt_upStoreHolidayType"/></td>
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
    
