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
	    <script src="/capstone/js/jquery.blockUI.js"></script>
		<link rel="stylesheet" href="/capstone/css/style.css">
		<link rel="stylesheet" type="text/css" href="${cssHref}">
		
	<meta name="google-signin-scope" content="patrick.mcgrath992@gmail.com">   <%--sign-in api--%>
    <meta name="google-signin-client_id" content="477833877206-3t9nj45ls1obq0fke2rkpi4nmfhcg0iu.apps.googleusercontent.com">
    <script src="https://apis.google.com/js/platform.js" async defer></script>
		
		
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
				
				var symbols= [];
				var qtys = [];
				<c:set var = "index" value ="0" />
				<c:forEach items="${stock_symbols_sorted}" var="stockSymbol">
					symbols[${index}] = "${stockSymbol}";
					qtys[${index}] = "${transactions.get(stockSymbol)}";
					<c:set var="index" value="${index + 1}"/>
				</c:forEach>	
				myStocksLookup(symbols, qtys);
				if ("${modalMessage}" != ""){
					$.blockUI({ message: $('#${modalMessage}'), css: { width: '275px' } });
				}
				countDownTimer();
			});
			
			function fnSetTitle(currTitle){
				document.getElementById("page_title").innerHTML = currTitle;
			}
			async function myStocksLookup (theSymbols, qtys) {
				var nameLookup = await $.getJSON('https://www.worldtradingdata.com/api/v1/stock?symbol=' + theSymbols + '&api_token=CinIFYZ2vNhYRyUY6yRRciEYKGFojmc7qWs9XZjKozOFqaT6VOyuyWXwqvAS', function(myData) {
					fnLoadTransactions(myData.data, qtys);
				});
			}

			async function stockLookup (theSymbol) {
				var nameLookup = await $.getJSON('https://www.worldtradingdata.com/api/v1/stock?symbol=' + theSymbol + '&api_token=CinIFYZ2vNhYRyUY6yRRciEYKGFojmc7qWs9XZjKozOFqaT6VOyuyWXwqvAS', function(myData) {
					fnLoadStockLookupInfo(myData.data[0]);
				});
			}
			function fnLoadStockLookupInfo(arr){
				x = document.getElementById("symbolLookup");
				$('#symbol').html(arr.symbol);
				$('#name').html(arr.name);
				$('#price').html(arr.price);
				$('#open').html(arr.price_open);
				$('#daily_hi').html(arr.day_high);
				$('#daily_lo').html(arr.day_low);
				$('#plus_minus').html(arr.day_change);
				if(  $("#symbolLookup").is(":visible") == false ) $('#symbolLookup').toggle();
				f = document.forms['update_game_form'];
				f.tickerSymbol.value = arr.symbol;
				f.price.value = arr.price;
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
		<table width="100%" border="0"><tr>
			<td><div id="page_title"></div></td>
			<c:if test="${isHomePage}">
				<td align="right"><button type="button"  method="get" class="btn btn-default" onclick="document.location='createGame'">Create Game</button></td>
			</c:if>
		</tr></table>		
		</div>

		<div class="inner_main_container">