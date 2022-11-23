<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>

var jdtListParcelInfo;
var jdtListParcelInfoDetail;

window.onload = function(){
};

$(document).ready(function () {
	var ua = navigator.userAgent;
	var checker = {
		iphone: ua.match(/(iPhone|iPod|iPad)/),
		blackberry: ua.match(/BlackBerry/),
		android: ua.match(/Android/)
	};

	fun_initializeClickEvent();
	fun_selectJoinMessage(function(){});
	fun_selectCommonJoinMessage(function(){});
});


function fun_selectJoinMessage(callback){
	var inputData = { };
	
	fun_ajaxPostSend("/realestate/select/joinMessage.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			$("#txt_currentMessage").val(tempResult[0].joinMsg);
			callback();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}

function fun_selectCommonJoinMessage(callback){
	var inputData = { };
	
	fun_ajaxPostSend("/realestate/select/common/joinMessage.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			$("#txt_futureMessage").val(tempResult.codeDescription);
			callback();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}

function fun_initializeClickEvent(){
}


//=== 추가/수정 이후 히든값 및 텍스트 초기화
function fun_changeAfterinit() {
};	


function fun_validationSaveChk(){
	var chk = 0;
	var alert_temp = "";

	var message = $("#txt_newFutureMessage").val();
	
	if (message == "") {
		alert_temp = alert_temp + "다음 달에 보여줄 메시지의 내용이 없습니다.";
	}
	else{
		chk ++;
	}
	
	
	if (chk == "1") {
		return true;
	}
	else {
		alert_temp = alert_temp + "추가 할 수 없습니다";
		alert(alert_temp);
		return false;
	}
	return false;
}

function fun_clickButtonOfInsertCommonJoinMessage() {
	if(fun_validationSaveChk()){
	}else{
		return false;
	}
	var message = $("#txt_newFutureMessage").val();
	message = message.replace(/(?:\r\n|\r|\n)/g, '');
	
	//=== Save Line Data
	var inputData = {"codeDescription": message };

	fun_ajaxPostSend("/realestate/insert/common/joinMessage.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			fun_selectCommonJoinMessage(function(){});
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
	return false;
};
</script>



<form id="membership" method="post" enctype="multipart/form-data" action="">
   	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header" style="font-size:24px">가입메시지</h1>
	    </div>
	    <!-- /.col-lg-12 -->
    </div>

	<div class="row" id="div_row1">
        <div class="col-lg-12">
            <div id="accordion1" class="accordion-style1 panel-group accordion-style2">
                <div class="panel panel-default" id="tog_Head">
                    <div class="panel-heading clearfix" style="font-size:16px">
                        <span class="toggle_accordion">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse1" >
				    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
				    &nbsp;현재 가입메시지 / 다음 月에 보여질 메시지 
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                        </span>
                    </div>
                    <div id="collapse1" class="panel-collapse collapse in">
                        <div class="panel-body">
							<div class="col-lg-6">
								<textarea id="txt_currentMessage" style="width:100%; height:150px;resize: none;background-color:#F0F0F0;color:black" disabled></textarea>
							</div>
							<div class="col-lg-6">
								<textarea id="txt_futureMessage" style="width:100%; height:150px;resize: none;background-color:#F0F0F0;color:black" disabled></textarea>
							</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</div>
	

	<div class="row" id="div_row2">
        <div class="col-lg-12">
            <div id="accordion2" class="accordion-style1 panel-group accordion-style2">
                <div class="panel panel-default" id="tog_Head">
                    <div class="panel-heading clearfix" style="font-size:16px">
                        <span class="toggle_accordion">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse2" >
				    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
				    &nbsp;다음 月에 보여줄 메시지
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                        </span>
                    </div>
                    <div id="collapse2" class="panel-collapse collapse in">
                        <div class="panel-body">
							<textarea id="txt_newFutureMessage" style="width:100%; height:150px;resize: none;"></textarea>
							<br>
							<p style="color:red">※ 이곳에 메시지를 작성하여 저장하면 다음달 0시 0분에 자동으로 갱신됩니다.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</div>
	
    
    <div class="space-16"></div>
    
    <div class="row">
		<div class="col-lg-12">
			<div class="col-lg-4 col-md-4">
			</div>
			<div class="col-lg-4 col-md-4" >
				<!-- <button type="button" id="btn_Delete" class="btn btn-white btn-warning btn-bold" onclick="return ();" >
					<i class="ace-icon fa fa-trash-o bigger-120 red"></i>
					
				</button> -->
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				
			</div>
			<div class="col-lg-4 col-md-4" style="text-align: right">
				<button type="button" id="btn_Save" class="btn btn-white btn-default btn-bold" onclick="return fun_clickButtonOfInsertCommonJoinMessage();">
					<i class="ace-icon fa fa-clipboard green"></i>
					저장
				</button> 
			</div>
		</div>
	</div>

</form>
