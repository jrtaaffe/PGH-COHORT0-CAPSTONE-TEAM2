<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
	<head>
		<title>Equity Elevator</title>
		<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
	    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
	    <script src="http://cdn.jsdelivr.net/jquery.validation/1.15.0/jquery.validate.min.js"></script>
	    <script src="http://cdn.jsdelivr.net/jquery.validation/1.15.0/additional-methods.js "></script>
	    <script src="https://cdn.jsdelivr.net/jquery.timeago/1.4.1/jquery.timeago.min.js"></script>
	    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
	    <script src="/capstone/js/index.js"></script>
		<link rel="stylesheet" href="/capstone/css/style.css">
		<link rel="stylesheet" type="text/css" href="${cssHref}">

			<c:set var = "isHomePage" value = "false"/>	
	<c:set var = "string1" value = "${pageContext.request.requestURL}"/>
	<c:if test="${fn:substring(string1, string1.length() - 8, string1.length()).equals('home.jsp')}">
	
			<c:set var = "isHomePage" value = "true"/>

	</c:if>
		
		<script type="text/javascript">
			$(document).ready(function() {
				$("time.timeago").timeago();
				
				$("#logoutLink").click(function(event){
					$("#logoutForm").submit();
				});
				
				var pathname = window.location.pathname;
				$("nav a[href='"+pathname+"']").parent().addClass("active");
				
			});
			
			function fnSetTitle(currTitle){
				document.getElementById("page_title").innerHTML = currTitle;
			}
		</script>
		
	</head>
	<body>
		<header>
			<c:url var="homePageHref" value="/" />
			<c:url var="imgSrc" value="/img/logo.png" />
		</header>

		<div class="header">
			<img src="/capstone/img/header.png">
			<div class="nav_row">
					<c:url var="homePageHref" value="/account/home" />
						<div class="nav_button_left"><a href="${homePageHref}">Home</a></div>
					<c:if test="${not empty currentUser}">
						<div class="nav_button_left"><a href="/capstone/account/research">Research Stocks</a></div>
					</c:if>

					<c:choose>
						<c:when test="${empty currentUser}">
							<c:url var="newUserHref" value="/users/new" />
							<div class="nav_button_right"><a href="${newUserHref}">Sign Up</a></div>
							<c:url var="loginHref" value="/login" />
							<div class="nav_button_right"><a href="${loginHref}">Log In</a></div>
						</c:when>
						<c:otherwise>
							<c:url var="logoutAction" value="/logout" />
							<form id="logoutForm" action="${logoutAction}" method="POST">
							<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
							</form>
							<div class="nav_button_right"><a id="logoutLink" href="/capstone/logout">Log Out</a></div>
							<div class="nav_button_right"><p id="currentUser">LOGGED IN AS: ${currentUser.getFirstName()} ${currentUser.getLastName()}</p></div>
						</c:otherwise>
					</c:choose>
			</div>
		</div>

	
		<div class="outter_main_container">
		<div class="subNavigation">
		<table width="100%"><tr>
			<td><div id="page_title"></div></td>
			<c:if test="${isHomePage}">
				<td><button type="button"  method="get" class="btn btn-default" onclick="document.location='createGame'">Create Game</button></td>
			</c:if>
		</tr></table>		
		</div>

				
		

		<div class="inner_main_container">