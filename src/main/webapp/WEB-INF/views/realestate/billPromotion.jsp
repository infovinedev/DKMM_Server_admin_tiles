<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>

jQuery.fn.serializeObject = function() {
	var obj = null;
	try {
		if (this[0].tagName && this[0].tagName.toUpperCase() == 'FORM') {
			var arr = this.serializeArray();
			if (arr) {
				obj = {};
				jQuery.each(arr, function() {
					obj[this.name] = this.value;
				});
			}//if ( arr ) {
		}
	} catch (e) {
		alert(e.message);
	} finally {
	}
	
	return obj;
};

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
	
	<%-- 조회 호출 --%>
	fun_selectPromotion('current', function(){});
	fun_selectPromotion('future', function(){});
});

<%-- 조회 --%>
function fun_selectPromotion(mode, callback){
	var inputData = {
		"mode": mode
	};
	
	fun_ajaxPostSend("/realestate/select/billPromotion.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					break;
				case "0001":
			}
			var tempResult = JSON.parse(msg.result);
			
			var frm = $('#' + mode + 'Promotion');
			frm.find('input[name="startDate"]').val(tempResult['startDate']);
			frm.find('input[name="closeDate"]').val(tempResult['closeDate']);
			frm.find('input[name="promotionImage"]').val(tempResult['promotionImage']);
			frm.find('input[name="promotionImageAlt"]').val(tempResult['promotionImageAlt']);
			frm.find('textArea[name="promotionContent"]').val(tempResult['promotionContent']);
			
			//for (key in tempResult) {
			//}
			
			callback();
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}

<%-- 유효성 검증 --%>
function fun_validationSaveChk(mode){
	var regexDate = RegExp(/^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$/);
	var regexUrl = RegExp(/^((http|https):\/\/(\w+:{0,1}\w*@)?(\S+)|)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?$/);
	
	var frm = $('#' + mode + 'Promotion');
	
	var startDate = frm.find('input[name="startDate"]').val();
	var closeDate = frm.find('input[name="closeDate"]').val();
	var promotionImage = frm.find('input[name="promotionImage"]').val();
	var promotionImageAlt = frm.find('input[name="promotionImageAlt"]').val();
	var promotionContent = frm.find('textArea[name="promotionContent"]').val();
	
	if (!regexDate.test(startDate)) {
		alert('시작일이 날짜 형식이 아닙니다.(ex:20210601)');
		frm.find('input[name="startDate"]').focus();
		return false;
	}
	if (mode == 'future') {
		var currCloseDate = $('#currentPromotion').find('input[name="closeDate"]').val();
		if (currCloseDate >= startDate) {
			alert('다음 시작일이 현재 종료일과 같거나 작습니다.');
			frm.find('input[name="startDate"]').focus();
			return false;
		}
	}
	
	if (!regexDate.test(closeDate)) {
		alert('종료일이 날짜 형식이 아닙니다.(ex:20210601)');
		frm.find('input[name="closeDate"]').focus();
		return false;
	}
	if (startDate > closeDate) {
		alert('종료일이 시작일보다 작습니다.');
		frm.find('input[name="closeDate"]').focus();
		return false;
	}
	
	if (!regexUrl.test(promotionImage)) {
		alert('이미지가 URL 형식이 아닙니다.');
		frm.find('input[name="promotionImage"]').focus();
		return false;
	}
	
	return true;
}

<%-- 저장 --%>
function fun_clickButtonOfUpdateCommonPromotion(mode){
	<%-- 유효성 검증 호출 --%>
	if(fun_validationSaveChk(mode)){
	}else{
		return false;
	}
	
	if (!confirm("저장하시겠습니까?")) {
		return false;
	}
	var inputData = $('#' + mode + 'Promotion').serializeObject();
	
	fun_ajaxPostSend("/realestate/update/billPromotion.do", inputData, true, function(msg){
		if(msg!=null){
			switch(msg.code){
				case "0000":
					alert("저장되었습니다.");
					break;
				case "0001":
					alert("실패했습니다.");
			}
			
			<%-- 조회 호출 --%>
			fun_selectPromotion(msg.result, function(){});
		}
		else{
			//alert('서비스가 일시적으로 원활하지 않습니다.');
		}
	});
}

<%-- 포로모션 화면 새창 --%>
function fun_clickButtonOfOpwnWindowCommonPromotion(mode){
	var url = 'https://www.estateletter.co.kr/cp/billletter';
	if (mode == 'future') {
		url += '?futureKey=3qa@kljh2KslWTEOJk2390ufPmio2';
	}
	
	window.open(url, '_blank')
}

</script>

	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header" style="font-size:24px">빌레터프로모션</h1>
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
									&nbsp;현재 프로모션 정보
							</a>
						</span>
						<span class="toggle_accordionSearch">
						</span>
					</div>
					<div id="collapse1" class="panel-collapse collapse in">
						<div class="panel-body">
						<form id="currentPromotion" role="form" class="form-horizontal" onsubmit="return false;">
							<input type="hidden" name="mode" value="current" />
							
							<div class="form-group">
								<label for="startDate" class="col-lg-2 control-label no-padding-right"><span style="color: red;">*</span>시작일</label>
								<div class="col-lg-10">
									<input type="text" id="startDate" name="startDate" maxlength="8" />
								</div>
							</div>
							<div class="form-group">
								<label for="closeDate" class="col-lg-2 control-label no-padding-right"><span style="color: red;">*</span>종료일</label>
								<div class="col-lg-10">
									<input type="text" id="closeDate" name="closeDate" maxlength="8" />
								</div>
							</div>
								
								
							<div class="form-group">
								<label for="currentImage" class="col-lg-2 control-label no-padding-right">이미지 경로</label>
								<div class="col-lg-10">
									<input type="text" id="currentImage" name="promotionImage" class="form-control" />
								</div>
							</div>
							<div class="form-group">
								<label for="currentImageAlt" class="col-lg-2 control-label no-padding-right">이미지 Alt</label>
								<div class="col-lg-10">
									<input type="text" id="currentImageAlt" name="promotionImageAlt" class="form-control" />
								</div>
							</div>
							<div class="form-group">
								<label for="currentContent" class="col-lg-2 control-label no-padding-right">컨텐츠</label>
								<div class="col-lg-10">
									<textarea id="currentContent" name="promotionContent" rows="5" cols="100" class="form-control"></textarea>
								</div>
							</div>
							
							<div class="row">
								<div class="col-lg-12">
									<div class="col-lg-4 col-md-4">
									</div>
									<div class="col-lg-4 col-md-4" >
									</div>
									<div class="col-lg-4 col-md-4" style="text-align: right">
										<button type="button" id="btn_Save" class="btn btn-white btn-default btn-bold" onclick="return fun_clickButtonOfUpdateCommonPromotion('current');">
											<i class="ace-icon fa fa-clipboard green"></i>
											저장
										</button>
										<button type="button" class="btn btn-white btn-default btn-bold" onclick="return fun_clickButtonOfOpwnWindowCommonPromotion('current');">
											<i class="ace-icon fa fa-eye green"></i>
											화면보기
										</button>
									</div>
								</div>
							</div>
						</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="row" id="div_row2">
		<div class="col-lg-12">
			<div id="accordion1" class="accordion-style1 panel-group accordion-style2">
				<div class="panel panel-default" id="tog_Head">
					<div class="panel-heading clearfix" style="font-size:16px">
						<span class="toggle_accordion">
							<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse2" >
								<i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
									&nbsp;다음 프로모션 정보
							</a>
						</span>
						<span class="toggle_accordionSearch">
						</span>
					</div>
					<div id="collapse2" class="panel-collapse collapse in">
						<div class="panel-body">
						<form id="futurePromotion" role="form" class="form-horizontal" onsubmit="return false;">
							<input type="hidden" name="mode" value="future" />
							
							<div class="form-group">
								<label for="futureStartDate" class="col-lg-2 control-label no-padding-right"><span style="color: red;">*</span>시작일</label>
								<div class="col-lg-10">
									<input type="text" id="futureStartDate" name="startDate" maxlength="8" />
								</div>
							</div>
							<div class="form-group">
								<label for="futureCloseDate" class="col-lg-2 control-label no-padding-right"><span style="color: red;">*</span>종료일</label>
								<div class="col-lg-10">
									<input type="text" id="futureCloseDate" name="closeDate" maxlength="8" />
								</div>
							</div>
								
								
							<div class="form-group">
								<label for="futureImage" class="col-lg-2 control-label no-padding-right">이미지 경로</label>
								<div class="col-lg-10">
									<input type="text" id="futureImage" name="promotionImage" class="form-control" />
								</div>
							</div>
							<div class="form-group">
								<label for="futureImageAlt" class="col-lg-2 control-label no-padding-right">이미지 Alt</label>
								<div class="col-lg-10">
									<input type="text" id="futureImageAlt" name="promotionImageAlt" class="form-control" />
								</div>
							</div>
							<div class="form-group">
								<label for="futureContent" class="col-lg-2 control-label no-padding-right">컨텐츠</label>
								<div class="col-lg-10">
									<textarea id="futureContent" name="promotionContent" rows="5" cols="100" class="form-control"></textarea>
								</div>
							</div>
							
							<div class="row">
								<div class="col-lg-12">
									<div class="col-lg-4 col-md-4">
									</div>
									<div class="col-lg-4 col-md-4" >
									</div>
									<div class="col-lg-4 col-md-4" style="text-align: right">
										<button type="button" id="btn_Save" class="btn btn-white btn-default btn-bold" onclick="return fun_clickButtonOfUpdateCommonPromotion('future');">
											<i class="ace-icon fa fa-clipboard green"></i>
											저장
										</button>
										<button type="button" class="btn btn-white btn-default btn-bold" onclick="return fun_clickButtonOfOpwnWindowCommonPromotion('future');">
											<i class="ace-icon fa fa-eye green"></i>
											화면보기
										</button>
									</div>
								</div>
							</div>
						</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
