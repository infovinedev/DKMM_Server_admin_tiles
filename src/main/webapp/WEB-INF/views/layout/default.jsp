<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page trimDirectiveWhitespaces="true" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<tiles:insertAttribute name="head"/>
	</head>
	<body class="no-skin">
	<tiles:insertAttribute name="header"/>
	<div class="main-container" id="main-container">
    
	    <!--Top Menu-->
	    <div id="top_menu" style="display:none;">
	        <div id="head_div" class="sidebar h-sidebar navbar-collapse collapse">
	            <div class="sidebar-shortcuts" id="sidebar-shortcuts">
					<div class="sidebar-shortcuts-large" id="sidebar-shortcuts-large">
						<a href="#" class="btn btn-danger">
	                        <i class="ace-icon fa fa-tachometer"></i>
						</a>
					</div>
	
					<div class="sidebar-shortcuts-mini" id="sidebar-shortcuts-mini">
						<a href="#" class="btn btn-danger"></a>
					</div>
				</div><!-- /.sidebar-shortcuts -->
	
	        </div>
	    </div>
	    
	   <aside class="main-sidebar sidebar-dark-primary">
            <a href="#none" class="brand-link text-center">
                대기몇명
                <div class="mt-1"></div>
            </a>
         <div id="side_div" class="sidebar">
         	<nav>
         		<ul id="nav_side" class="nav nav-pills nav-sidebar flex-column nav-child-indent" data-widget="treeview" role="menu" data-accordion="false">
         		
         		</ul>
         	</nav>
         </div>
       </aside> 
        
	    
	     <!-- Content -->
		 <div class="main-content">
		 	<div class="main-content-inner">
		    	<div class="page-content">
				<tiles:insertAttribute name="body" />
		        </div>
		    </div>
		 </div>
		<tiles:insertAttribute name="footer" />
	</div>
	<iframe id="txtArea1" style="display:none"></iframe>
	</body>
	
</html>