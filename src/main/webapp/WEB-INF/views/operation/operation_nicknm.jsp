<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<head>
<script language="javascript" src="/assets/js/huge-uploader.js"></script>
</head>
<script>
var nicknmListInfo;

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
	
	
	fun_setNicknmListInfo();
	
	$("#userListLength").change(function(){
		var length = $("#userListLength").val();
		$("#nicknmListInfo").DataTable().page.len(length).draw();
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
	
});

function searchDataTable(){
	 if($('#chk_searchTable').is(':checked')){
	      $("#nicknmListInfo").DataTable().search(
	         $("#txt_searchText").val()
	      ).draw();
	   }
	else{
		$("#nicknmListInfo").DataTable().search("").draw();
	}
}

function fun_search(){
	var searchType = $("#sel_workCond").val();
	var searchText = "";//$("#txt_searchText").val();
	var searchStartDt = $("#search_startDt").val();
	var searchEndDt = $("#search_endDt").val();
	var inputData = {"searchType": searchType, "searchText": searchText, "searchStartDt": searchStartDt,"searchEndDt": searchEndDt};
	
	$('#chk_searchTable').prop('checked', false);
	searchDataTable();
	
	fun_ajaxPostSend("/nicknm/select/defineNicknmList.do", inputData, true, function(msg){
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
			fun_dataTableAddData("#nicknmListInfo", tempResult);
		}
	});
}

//text값 공백처리
function fun_reset(type){
	$("#txt_nickSeq").val("");             //업적번호
	$("#txt_nickSeq").val("");              //업적명
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
//상세보기
function fun_viewDetail(nickSeq) {
	fun_reset();
	$("#section1_detail_edit").css("display", "none");
	$("#section1_detail_view").removeAttr("style");
	var inputData = {"nickSeq": nickSeq};
	fun_ajaxPostSend("/nicknm/select/defineNicknmDetail.do", inputData, true, function(msg){
		if(msg!=null){
			var tempResult = JSON.parse(msg.result);
			var tempResult         = JSON.parse(msg.result);
			var nickSeq            = tempResult.nickSeq == null ? "" : tempResult.nickSeq;            //칭호번호
			var nickNm             = tempResult.nickNm == null ? "" : tempResult.nickNm;              //칭호명
			var fileUuid           = tempResult.fileUuid == null ? "N" : "Y";                         //칭호이미지
			var workNm             = tempResult.workNm == null ? "" : tempResult.workNm;              //연결업적
			var nickComment        = tempResult.nickComment == null ? "" : tempResult.nickComment;    //칭호코멘트
			
			$("#txt_nickSeq").val(nickSeq);
			$("#txt_nickNm").val(nickNm);
			$("#txt_fileUuid").val(fileUuid);
			$("#txt_workNm").val(workNm);
			$("#txt_nickComment").val(nickComment);
			
			//수정 시 text셋팅
			$("#hidden_up_nickSeq").val(nickSeq);
			$("#txt_up_nickNm").val(nickNm);
			$("#txt_up_fileUuid").val(fileUuid);
			$("#txt_up_workNm").val(workNm);
			$("#txt_up_nickComment").val(nickComment);
		}
	});
}

function fun_setNicknmListInfo() {
	nicknmListInfo = $("#nicknmListInfo").DataTable({
		"columns": [
			  {"data":  "listIndex"}
			, {"data":  "nickSeq"}
			, {"data":  "nickNm"}
			, {"data": "workNm"}
			, {"data": "fileUuid"}
			, {"data": "nickComment"}
			, {"data": "add" }
		]
		, "paging": true                     // Table Paging
		, "info": false                      // 'thisPage of allPage'
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
				, "render": function (data, type, row) {
					var msg = row.nickSeq;
					var insertTr = "";
					insertTr += '<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_viewDetail(' + msg + ')">상세보기</button>'; 
					return insertTr;
                }
			}
		]
	});
	
	fun_search();
};

function fun_update(type) {
	$("#btn_insert").show();
	$("#btn_update").show();
	$("#btn_delete").show();
	
	if(type == "insert"){
		$("#btn_update").hide();
		$("#btn_delete").hide();
		$("#txt_up_nickNm").val("");
		$("#txt_up_fileUuid").val("");
		$("#txt_up_workNm").val("-");
		$("#txt_up_nickComment").val("");
	}else{
		$("#btn_insert").hide();
	}
	$("#section1_detail_view").css("display", "none");
	$("#section1_detail_edit").removeAttr("style");
}

function fun_preview(obj, fileType){
    var input = $("#fileUploader");
    var fileObject = input.prop('files')[0];

    var name = fileObject.name;
    if(fileObject==""){
        alert("파일을 업로드 해주세요.");
        return false;
    }

    var ext = name.split('.').pop().toLowerCase();
    var fileArr = ['png','jpg','jpeg', 'gif', 'pdf', 'xls', 'xlsx', 'txt', 'doc', 'docx', 'ppt', 'pptx', 'zip', 'hwp', 'avi', 'mp4', 'm4v', 'wmv', 'mkv', 'mov', 'bz2'];
    if(fileType == "img"){
        fileArr = ['png','jpg','jpeg', 'gif'];
        if(fileArr.indexOf(ext) == -1) {
            alert("이미지 파일을 업로드 해 주세요.");
            return false;
        }

    }

    var data = "";
    switch(ext){
        case "gif":
            data = "data:image/gif;base64,";
            break;
        case "jpg":
        case "jpeg":
            data = "data:image/jpeg;base64,";
            break;
        case "png":
            data = "data:image/png;base64,";
            break;
    }

    var reader = new FileReader();

    reader.onloadend = function() {
        $("#img_preview").attr("src", reader.result);
        $("#tr_preview").show();
    }
    reader.readAsDataURL(fileObject);




}



//칭호 등록,수정,삭제 저장 버튼
function fun_save(type){
    fun_fileUploader('img', 'doc', function(headers){
        var nickSeq          = $("#hidden_up_nickSeq").val();
        var nickNm           = $("#txt_up_nickNm").val();
        var fileUuid         = headers.uniqueId;            //$("#txt_up_fileUuid").val();
        var workNm           = $("#txt_up_workNm").val();
        var nickComment      = $("#txt_up_nickComment").val();


        var inputData = {"nickSeq": nickSeq , "nickNm": nickNm , "fileUuid": fileUuid , "workNm": workNm, "nickComment": nickComment};
        if(type == "I"){
            var result = confirm('추가 하시겠습니까?');
        }else if(type == "U"){
            var result = confirm('수정 하시겠습니까?');
        }else{
            var result = confirm('삭제하시겠습니까?');
        }

        if(result){
            fun_ajaxPostSend("/nicknm/save/nickNmSave.do", inputData, true, function(msg){
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
    });
}
//파일업로드
function generateUUID() {
    var d = new Date().getTime();
    var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = (d + Math.random()*16)%16 | 0;
        d = Math.floor(d/16);
        return (c=='x' ? r : (r&0x3|0x8)).toString(16);
    });
    return uuid;
};


function fun_fileUploader(fileType, pageType, callback){
    /* var input = event.target;
    var fileObject = input.files[0]; */
    var input = $("#fileUploader");
    var fileObject = input.prop('files')[0];

    var name = fileObject.name;
    if(fileObject==""){
        alert("파일을 업로드 해주세요.");
        return false;
    }

    var ext = name.split('.').pop().toLowerCase();
    var fileArr = ['png','jpg','jpeg', 'gif', 'pdf', 'xls', 'xlsx', 'txt', 'doc', 'docx', 'ppt', 'pptx', 'zip', 'hwp', 'avi', 'mp4', 'm4v', 'wmv', 'mkv', 'mov', 'bz2'];
    if(fileType == "img"){
        fileArr = ['png','jpg','jpeg', 'gif'];
        if(fileArr.indexOf(ext) == -1) {
            alert("이미지 파일을 업로드 해 주세요.");
            return false;
        }

    }
    var headers = new Object();
    headers.pageType = pageType;
    headers.fileType = fileType;
    headers.uniqueId = generateUUID();
    headers.fileObjectName = fileObject.name;
    headers.fileObjectSize = fileObject.size;
    headers.fileObjectType = fileObject.type;
    const HugeUploader = require('huge-uploader');
    const uploader = new HugeUploader({ endpoint: '/file/upload.do', file: fileObject, headers:headers });
    // subscribe to events
    uploader.on('error', (err) => {
        console.error('Something bad happened', err.detail);
    });

    uploader.on('progress', (progress) => {
        var data = progress.detail.responseData;
        var code = data.code;
        switch(code){
            case "0000":
            case "0004":
                $(".progress-bar").find("span.data-percent").html(progress.detail.percent + "%");

                $(".progress-bar").animate({
                    width: progress.detail.percent + "%"
                }, 800);
                callback(headers);
                break;
            case "0001":
                uploader.togglePause();
                alert(data.result);
                location.href="admin/loginView.do";
                break;
            case "0002":
            case "0003":
                uploader.togglePause();
                alert(data.result);
                break;

        }
    });

    uploader.on('fileRetry', (msg) => {
        console.log(msg);
    });

    uploader.on('finish', (body) => {
        console.log('yeahhh - last response body:', body);
    });
}
</script>
<head>
	<title>관리자 운영 - 칭호관리</title>
</head>
<body class="hold-transition sidebar-mini">
    <div class="wrapper">
          <div class="content-wrapper">
            <!-- 상단 title -->
            <div class="content-header">
               <div class="container-fluid">
                  <div class="row">
                     <div class="col">
                        <h1 class="title">칭호관리</h1>
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
                                        <th>칭호생성일</th>
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
                                        <th>칭호이미지여부</th>
                                        <td>
                                            <select class="form-control" id="sel_workCond" name="search_workCond" style="width:80%;">
	                                        	<option value="">선택</option>
	                                        	<option value="Y">이미지있음</option>
	                                        	<option value="N">이미지없음</option>
                                            </select>
                                        </td>
                                        <th>검색어</th>
                                        <td>
                                           <div class="row row-10 align-items-center">
                                                  <input type="text" style="width:90%;" class="form-control" placeholder="칭호명" id="txt_searchText" name="searchText" onKeypress="" />
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
                                    <button type="button" class="btn btn-primary mr-1" data-toggle="modal" data-target="#exampleModalScrollable" onclick="fun_update('insert')">칭호등록</button>
                                    <select id="userListLength" class="custom-select w-auto">
                                    	<option value="10">10</option>
                                    	<option value="20">20</option>
                                    	<option value="50">50</option>
                                    </select>
                                </div>
                         </div>
                         <div class="main_search_result_list">
                                <table id="nicknmListInfo" class="table table-bordered">
                                    <thead>
                                    	<tr>
	                                        <th class="text-center">번호</th>
	                                        <th class="text-center">칭호SEQ</th>
	                                        <th class="text-center">칭호명</th>
	                                       	<th class="text-center">연결업적</th>
	                                        <th class="text-center">칭호이미지</th>
	                                        <th class="text-center">칭호코멘트</th>
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
                        <div class="modal-content" id="detailModal" style="width: 1200px;">
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
                                     <th>칭호번호</th>
                                     <td><input class="form-control" type="text" id="txt_nickSeq" readOnly/></td>
                                     <th>칭호명</th>
                                     <td><input class="form-control" type="text" id="txt_nickNm" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>칭호이미지</th>
                                     <td><input class="form-control" type="text" id="txt_fileUuid" readOnly/></td>
                                     <th>연결업적</th>
                                     <td><input class="form-control" type="text" id="txt_workNm" readOnly/></td>
                                  </tr>
                                  <tr>
                                     <th>칭호코멘트</th>
                                     <td colspan="3"><textarea class="form-control" type="text" id="txt_nickComment" readOnly/></textarea>
                                  </tr>
                               </tbody>
                            </table>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-primary" onclick="fun_update('edit');">수정</button>
                            <button type="button" class="btn btn-secondary" id="close" data-dismiss="modal">닫기</button>
                          </div>
                        </div>
                    </section>
                    <!-- 상세보기 모달창 end  -->
                    
                    <!-- 등록, 모달창 -->
                    <section id="section1_detail_edit" style="display:none;">
                        <div class="modal-content" id="insertModal" style="width: 1200px;">
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
                                     <th>칭호명 <span class="text-red">*</span></th>
                                     <td colspan="3"><input class="form-control" type="text" id="txt_up_nickNm"/>
                                        <input class="form-control" type="hidden" id="hidden_up_nickSeq"/>
                                     </td>
                                  </tr>
                                  
                                  
                                  <tr>
                                    <th>칭호이미지 <span class="text-red">*</span></th>
                                    <td colspan="3">
                                        <input type="file" class="btn btn-secondary btn-sm" id="fileUploader" onchange="fun_preview(this, 'img');">
                                        <!-- onchange="fun_fileUploader(fileUploader, 'img', 'doc', fun_fileUploaderCallback);" -->
                                        <div class='progress' style="width:600px; display:none;">
                                          <div class='progress-bar' data-width='0'>
                                            <div class='progress-bar-text'>
                                              Progress: <span class='data-percent'></span>
                                            </div>
                                          </div>
                                        </div>
                                     </td>
                                  </tr>

                                  <tr style="display:none" id="tr_preview">
                                      <th>미리보기</th>
                                      <td colspan="3">
                                          <img src="" style="" id="img_preview">
                                      </td>
                                  </tr>

                                  <tr>
                                    <th>연결업적</th>
                                    <td colspan="3"><input class="form-control" type="text" id="txt_up_workNm" readOnly/></td>
                                  </tr>
                                  
                                  <tr>
                                    <th>칭호코멘트<span class="text-red">*</span></th>
                                    <td colspan="3"><input class="form-control" type="text" id="txt_up_nickComment"/></td>
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
                    <!-- 등록 모달창 end -->
                  </div>
                </div>
            </div>
        </div>
    </div>
    </body>