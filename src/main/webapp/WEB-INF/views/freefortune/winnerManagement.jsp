<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="../assets/js/cryptoJs/aes.js"></script>
<script>

var jdtListParcelInfo;
var jdtListWinner;

window.onload = function(){
};

$(document).ready(function () {
	var ua = navigator.userAgent;
	var checker = {
		iphone: ua.match(/(iPhone|iPod|iPad)/),
		blackberry: ua.match(/BlackBerry/),
		android: ua.match(/Android/)
	};
	
});


function fun_outputExcel(){
	//location.href = "/freefortune/event/promotion.do?startDate=" + $("#dtp_startDate").val() + "&closeDate=" + $("#dtp_closeDate").val();
	location.href = "/freefortune/event/promotion.do";
}
</script>



<form id="membership" method="post" enctype="multipart/form-data" action="">
   	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header" style="font-size:24px">프로모션관리</h1>
	    </div>
	    <!-- /.col-lg-12 -->
    </div>
	
	<div class="row">
		<div class="col-lg-12">
		<input type="button" id="btn_excel" onclick="fun_outputExcel();" class="btn btn-info btn-xs" value="엑셀출력">
		</div>
	</div>
	<!--자동완성 제거목적-->
	<div class="row" id="div_row1" style="display:none;">
		<div class="col-lg-12">
			<div class="col-lg-1">
				시작일자 : 
			</div>
			<div class="col-lg-2">
				<div class="input-group">
					<input type="text" id="dtp_startDate" class="form-control" autocomplete="no">
                    <span class="input-group-addon">
				        <i class="fa fa-calendar"></i>
			        </span>
                </div>
			</div>
			<div class="col-lg-1">
				종료일자 : 
			</div>
			<div class="col-lg-2">
				<div class="input-group">
					<input type="text" id="dtp_closeDate" class="form-control" autocomplete="no">
					<span class="input-group-addon">
				        <i class="fa fa-calendar"></i>
			        </span>
				</div>
			</div>
			<div class="col-lg-1">
				<input type="button" id="btn_excel" onclick="fun_outputExcel();" class="btn btn-info btn-xs" value="엑셀출력">
			</div>
		</div>
	</div>


	<div class="space-16" style="display:none;"></div>

	<div class="row" id="div_row3" style="display:none;">
        <div class="col-lg-12">
            <div id="accordion3" class="accordion-style1 panel-group accordion-style2">
                <div class="panel panel-default" id="tog_Head">
                    <div class="panel-heading clearfix" style="font-size:16px">
                        <span class="toggle_accordion">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse3" >
				    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
				    &nbsp;당첨자 등록
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                            
                        </span>
                    </div>
                    <div id="collapse3" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="dataTable_wrapper">
                                <table id="jdtListWinner" class="table table-striped table-bordered table-hover">
                                    <thead>

                                    </thead>
                                    <tbody>

                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</div>
	

	<div class="row" id="div_row4" style="display:none;">
        <div class="col-lg-12">
            <div id="accordion4" class="accordion-style1 panel-group accordion-style2">
                <div class="panel panel-default">
                    <div class="panel-heading clearfix" style="font-size:13px;font-family:'Malgun Gothic' !important;">
                        <span class="toggle_accordion">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse4" >
				    <i class="ace-icon fa fa-angle-down bigger-110" data-icon-hide="ace-icon fa fa-angle-down" data-icon-show="ace-icon fa fa-angle-right"></i>
				    &nbsp;당첨자
                            
			    </a>
                        </span>
                        <span class="toggle_accordionSearch">
                            
                        </span>
                    </div>
                    <div id="collapse4" class="panel-collapse collapse in">
                        <div class="panel panel-body">
                            <div class="row form-group form-group-sm">
                                <div class="col-lg-1 col-md-2" style="padding-top:4px;">
									프로모션 연도
                                </div>
                                <div class="col-lg-2 col-md-4">
									<select id="sel_years" class="form-control">
									</select>
                                </div>
                                <div class="hidden-lg hidden-xs col-md-12">
                                    <p></p>
                                </div>
                                <div class="col-lg-1 col-md-2" style="padding-top:4px;">
                                    프로모션 월
                                </div>
                                <div class="col-lg-2 col-md-4">
                                    <select id="sel_months" class="form-control">
										<option value="01">1월</option>
										<option value="02">2월</option>
										<option value="03">3월</option>
										<option value="04">4월</option>
										<option value="05">5월</option>
										<option value="06">6월</option>
										<option value="07">7월</option>
										<option value="08">8월</option>
										<option value="09">9월</option>
										<option value="10">10월</option>
										<option value="11">11월</option>
										<option value="12">12월</option>
									</select>
                                </div>
                                <div class="col-lg-1 col-md-2" style="padding-top:4px;">
                                    전화번호
                                </div>
                                <div class="col-lg-2 col-md-4">
                                	<input type="text" ID="txt_mdn" class="form-control" placeholder="010-5555-4444" onkeyup="">
                                </div>
                            </div>
	                	</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    
    
    <div class="row" style="display:none;">
        <div class="col-lg-12">
            <div class="col-lg-5 col-md-5">
                
            </div>
            <div class="hidden-lg hidden-md col-sm-12"><p></p></div>
            <div class="col-lg-7 col-md-7">
                <div class="btn-group btn-overlap pull-right" style="padding-right:20px;">
                    <div class="btn-group" data-toggle="tooltip" data-placement="top" data-original-title="라인선택삭제">
                        <button type="button" id="btn_DeleteSelect" class="btn btn-white btn-danger btn-bold">
                            <span><i class="ui-icon ace-icon fa fa-trash red"></i>&nbsp;항목삭제</span>
                        </button>
                        &nbsp;
                    </div>
                    <div class="btn-group" data-toggle="tooltip" data-placement="top" data-original-title="라인수정">
                    &nbsp;
                        <button type="button" id="btn_ModiLine" class="btn btn-white btn-inverse btn-bold" onclick="return fun_clickButtonModifyLine();">
                            <span><i class="ui-icon ace-icon fa fa-pencil black"></i>&nbsp;항목수정</span>
                        </button>
                    </div>
                    <div class="btn-group" data-toggle="tooltip" data-placement="top" data-original-title="라인추가">
                    	&nbsp;
                        <button type="button" id="btn_AddLine" class="btn btn-white btn-info btn-bold" onclick="return fun_clickButtonAddLine();">
                            <!--<span><i class="ui-icon ace-icon glyphicon glyphicon-plus blue"></i></span>-->
                            <span><i class="ui-icon ace-icon fa fa-plus blue"></i>&nbsp;항목추가</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="space-16" style="display:none;"></div>
    
    <div class="row" style="display:none;">
		<div class="col-lg-12">
			<div class="col-lg-4 col-md-4">
			</div>
			<div class="col-lg-4 col-md-4">
				<!-- <button type="button" id="btn_Delete" class="btn btn-white btn-warning btn-bold" onclick="return ();" >
					<i class="ace-icon fa fa-trash-o bigger-120 red"></i>
					
				</button> -->
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				
			</div>
			<div class="col-lg-4 col-md-4" style="text-align: right">
				<button type="button" id="btn_Save" class="btn btn-white btn-default btn-bold" onclick="return fun_clickButtonOfInsertParcelInfo();">
					<i class="ace-icon fa fa-clipboard green"></i>
					저장
				</button> 
			</div>
		</div>
	</div>

</form>
