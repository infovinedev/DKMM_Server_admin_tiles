<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>	
<nav class="main-header navbar navbar-expand navbar-white navbar-light">
	<div id="top_user" class="ml-auto">
		<div class="d-flex align-items-center pr-2">
			<div class="d-flex align-items-center">
				<i class="fas fa-user-circle mr-2 font-size-30px"></i>
				<a href="">${userName}</a>
			</div>
			<button type="button" class="btn btn-light btn-round ml-4" onclick="javascript:location.href='/admin/logout.do'">로그아웃</button>
	</div>
	</div>
</nav>