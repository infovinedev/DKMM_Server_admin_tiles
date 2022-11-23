<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
function fun_test(){
	var inputData = {};
	fun_ajaxPostSend("/realestate/test.do", inputData, true, function(msg){
	        if(msg!=null){
	        	
	        }
	        else{
	        
	        }
        });
}
</script>