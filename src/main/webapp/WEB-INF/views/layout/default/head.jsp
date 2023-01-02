<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>	
	<title>infovine Admin</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>
	<meta name="viewport" content="width=device-width, initial-scale=1"></meta>
	<meta name="description" content=""></meta>
	<meta name="author" content=""></meta>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width , initial-scale=1, maximum-scale=1">
	
	<link rel="shortcut icon" href="../assets/images/favicon.ico">
	<link rel="icon" type="image/png" href="../assets/images/favicon.png" sizes="192x192">
	<link rel="stylesheet" href="../assets/lib/chart/Chart.min.css">
	<link rel="shortcut icon" href="../assets/images/favicon.ico">
	<link rel="icon" type="image/png" href="../assets/images/favicon.png" sizes="192x192">
	<link rel="stylesheet" type="text/css" href="../assets/lib/fontawesome-free/css/all.css">
	<link rel="stylesheet" type="text/css" href="../assets/lib/bootstrap/css/bootstrap-select.min.css">
	<link rel="stylesheet" type="text/css" href="../assets/css/bootstrap.css">
	<link rel="stylesheet" type="text/css" href="../assets/lib/swiper/css/swiper.min.css">
	<link rel="stylesheet" type="text/css" href="../assets/lib/jquery-ui/jquery-ui.min.css">
	<link rel="stylesheet" href="../assets/lib/chart/Chart.min.css">
	<link rel="stylesheet" href="../assets/css/adminlte.css">
	<link rel="stylesheet" href="../assets/css/style.css">
	<!-- Additional style(개발단에서 수정 및 추가 필요한 경우 additional.css에 작성)  -->
	<link rel="stylesheet" href="../assets/css/additional.css">
	<link rel="stylesheet" href="../assets/css/custom_pagenate.css">
	
	<!-- 	Toast UI Editor -->
	<link rel="stylesheet" href="../assets/css/editor/toastui-editor.min.css">
	
	<script  src="../assets/js/jquery-3.3.1.js"></script>
	<script  src="../assets/js/c21.js"></script>
	<script  src="../assets/js/common.js"></script>
	<script src="../assets/lib/jquery-ui/jquery-ui.min.js"></script>
	<script src="../assets/js/ui.js" defer></script>
	<script  src="../assets/js/adminlte.min.js"></script>
	<!-- basic scripts -->
	<script src="../assets/js/bootstrap.js?version=0.0" type="text/javascript"></script>
	<script src="../assets/js/jquery-ui.custom.js" type="text/javascript"></script>
	<script src="../assets/js/jquery.ui.touch-punch.js" type="text/javascript"></script>

	<!-- Datatable Script -->
	<script src="../assets/js/dataTables/jquery.dataTables.js" type="text/javascript"></script>
	<script src="../assets/js/dataTables/jquery.dataTables.bootstrap.js" type="text/javascript"></script>

	<script src="../assets/js/excel/xlsx.full.min.js"></script>
	<script src="../assets/js/excel/FileSaver.min.js"></script>
	
	<script src="../assets/js/cryptoJs/sha512.js"></script>
	<script src="../assets/js/module.js?version=0.1"></script>
	<script src="../assets/js/blockUI.js?version=0.1"></script>
	
	<!-- 	Toast UI Editor -->
	<script src="../assets/js/editor/toastui-editor-all.min.js?version=0.1"></script>
	
	<script>
	let leftMenuLevel1 = [];
	let leftMenuLevel2 = [];
	let leftMenuLevel3 = [];
	let parentsProgramPageNumber = "";
	let myProgramPageNumber = "";
	$(document).ready(function () {
		fun_selectLeftMenu(function(){
			fun_leftTreeActivation(function(){
				fun_setLeftTreeActive('${leftPageUrl}');
			});
		});
	});
	
	function fun_setLeftTreeActive(obj){
		var leftMenulength = $(".nav-item.division").length;
		for(var i=0; i<leftMenulength; i++){
			
			var id = $(".nav-item.division")[i].id;
			var hrefUrl = $("#aHref_" + id)[0].href;
			//var checkIndexOf = hrefUrl.indexOf("/store/store.do");
			var checkIndexOf = hrefUrl.indexOf(obj);
			if(checkIndexOf>0){
				var parentsProgramId = $("#"+ id).data("parentsprogramid");
				parentsProgramPageNumber = parentsProgramId;
				//$('#' + parentsProgramId).addClass("active");
				
				$('a[name='+ parentsProgramId +']').addClass("active");
				$('#parent_' + parentsProgramId).addClass("menu-open");
				$("#aHref_" + id).addClass("active");
			}
		}
	}
	
	// function fun_leftMenuActive(id){
	// 	if($('#parent_' + id).attr('class') == "nav-item has-treeview menu-open"){
	// 		$('#parent_' + id).removeClass('menu-open');
	// 		$('#ul_' + id).attr("style", "display : none;");
	// 	}else{
	// 		$('#parent_' + id).addClass("menu-open");
	// 		$('#ul_' + id).attr("style", "display : block;");
	//
	// 	}
	// }
	      
	function fun_leftTreeActivation(callback){
			var temp_side = '';
				//temp_side += 		'<nav>';
				//temp_side += 			'<ul class="nav nav-pills nav-sidebar flex-column nav-child-indent" data-widget="treeview" role="menu" data-accordion="false">';
				temp_side += 				'<li class="nav-item has-treeview">';
				temp_side += 					'<a href="/main/page.do" class="nav-link">';
				temp_side += 						'<i class="nav-icon fas fa-chalkboard-teacher"></i>';
				temp_side += 						'<p>홈으로 <i class="right fas fa-angle-right"></i></p>';
				temp_side += 					'</a>';
				temp_side += 				'</li>';
			$.each(leftMenuLevel1, function (key1, value1) {
// 				if(value1.programId != 30000000){
					temp_Value1 = mid(value1.programId, 0, 2);
					temp_side += '<li class="nav-item has-treeview" id="parent_' + value1.programId + '">';	//onclick=fun_leftMenuActive("' +value1.programId +'")
					temp_side += '<a class="nav-link" id="' + value1.programId + '"><i class="nav-icon fas fa-chalkboard-teacher"></i><p>' + value1.programName + '<i class="right fas fa-angle-right"></i></p></a>';
					temp_side += '<ul class="nav nav-treeview" id="ul_' + value1.programId + '">';
					
 					$.each(leftMenuLevel2, function (key2, value2) {
							if (value1.programId == value2.parentsProgramId) {
								temp_side += '<li class="nav-item division" id="' + value2.programId + '" data-parentsProgramId="' + value2.parentsProgramId + '" ><a href="' + value2.location + '" class="nav-link" id="aHref_' + value2.programId + '" ><i class="far fa-circle nav-icon"></i>' + value2.programName + '</a>';      // 2LEVEL 프로그램
								
							}
					});  //each2
					temp_side += '</ul>';
// 				}
			});//each1 
				//temp_side += 			'</ul>';
				//temp_side += 		'</nav>';
				
			$("#nav_side").append(temp_side);
			callback();
		}
	
	function fun_selectLeftMenu(callback){
		var inputData = { };
		
		fun_ajaxPostSend("/admin/left/menu.do", inputData, true, function(msg){
	        if(msg!=null){
	        	switch(msg.code){
		        	case "0000":
		        		location.href="/main/page.do";
		        		break;
		        	case "0001":
		        		alert("아이디나 비밀번호를 확인해주세요");
		        		location.href="/admin/loginView.do";
		        		break;
		        	case "0002":
		        		alert("비밀번호 임시 발급 이후 30분이 지났습니다");
		        		location.href="/admin/loginView.do";
		        		break;
		        	case "0003":
		        		alert("해당 아이디는 5분간 계정이 잠깁니다");
			        	location.href="/admin/loginView.do";
		        		break;
		        	case "0004":
		        		alert("세션이 만료되었습니다.");
			        	location.href="/admin/loginView.do";
		        		break;
	        	}
	        	
				var tempResult = JSON.parse(msg.result);
				for(var i=0; i<tempResult.length;i++){
					
					var adminProgram = tempResult[i].adminProgram;
					if ( adminProgram != null && adminProgram != undefined ){
						var level = adminProgram.level;
						switch(level){
							case "1":
								leftMenuLevel1.push(adminProgram);
								break;
							case "2":
								leftMenuLevel2.push(adminProgram);
								break;
							case "3":
								leftMenuLevel3.push(adminProgram);
								break;
						}
					}
				}
	        	callback();
	        }
	        else{
	        	location.href="/admin/loginView.do";
	        	//alert('서비스가 일시적으로 원활하지 않습니다.');
	        }
        });
	}
	
	</script>
