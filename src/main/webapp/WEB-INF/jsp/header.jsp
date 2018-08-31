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
		<script src="http://widgets.freestockcharts.com/script/WBIHorizontalTicker2.js?ver=12334" type="text/javascript"></script> 
		<link href="http://widgets.freestockcharts.com/WidgetServer/WBITickerblue.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" href="/css/style.css">
		
	<meta name="google-signin-scope" content="patrick.mcgrath992@gmail.com">   <%--sign-in api--%>
    <meta name="google-signin-client_id" content="477833877206-3t9nj45ls1obq0fke2rkpi4nmfhcg0iu.apps.googleusercontent.com">
    <script src="https://apis.google.com/js/platform.js" async defer></script>
		
		
	<c:set var = "isHomePage" value = "false"/>	
	<c:set var = "leaderboard" value = "${leaderboard}"/>	

	
	<c:set var = "string1" value = "${pageContext.request.requestURL}"/>
<c:if test="${fn:substring(string1, string1.length() - 8, string1.length()).equals('home.jsp')}">
			<c:set var = "isHomePage" value = "true"/>
	</c:if>
		
		<script type="text/javascript">
		var currPage = "";
			$(document).ready(function() {
				$("time.timeago").timeago();
				
				$("#logoutLink").click(function(event){
					$("#logoutForm").submit();
				});
				$('#buy_button').click(function (e) {
					fnBuyStock('B',$('#symbol').html(), $('#qty_field').val(), $('#price').html());
					return false;
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
				if(currPage=='game') myStocksLookup(symbols, qtys);
				if ("${modalMessage}" != ""){
					$.blockUI({ message: $('#${modalMessage}'), css: { width: '275px' } });
				}
				//if (currPage == "game") countDownTimer();
			});
			
			function fnResearch(tickerSymbol){
				researchSymbol = tickerSymbol;
				$.blockUI({ message: $('#research_stock'), css: { width: '750px' } });
			}
			
			function fnSetTitle(currTitle){
				document.getElementById("page_title").innerHTML = currTitle;
			}
			function fnSetCurrPage(page){
				currPage = page;
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
				$('#price').html('$'+Number(arr.price).format(2));
				$('#open').html('$'+Number(arr.price_open).format(2));
				$('#daily_hi').html('$'+Number(arr.day_high).format(2));
				$('#daily_lo').html('$'+Number(arr.day_low).format(2));
				$('#plus_minus').html('$'+Number(arr.day_change).format(2));
				if(  $("#symbolLookup").is(":visible") == false ) $('#symbolLookup').toggle();
				f = document.forms['update_game_form'];
				f.tickerSymbol.value = arr.symbol;
				f.price.value = arr.price;
			}
			function fnShowStandings(){
				var leaderboard = "";
				var leaderboardHTML = "";
				for (x in names){
					leaderboardHTML += "<tr id=\"leaderboard_row\"><td class=\"td_align_left table_col\">"+names[x]+"</td>";
					leaderboardHTML += "<td class=\"table_col\">$"+Number(cash[x]).format(2)+"</td>";
					leaderboardHTML += "<td class=\"table_col\">$"+Number(worth[x]).format(2)+"</td>";
					leaderboardHTML += "<td class=\"td_align_center table_col\">#"+standing[x]+"</td></tr>";
				}
				$('#current_game tr:last').after(leaderboardHTML);
				$('.view_all_link').html("<a href=\"javascript:fnHideStandings()\">(hide all)</a>");
			}
			function fnHideStandings(){
				$('.view_all_link').html("<a href=\"javascript:fnShowStandings()\">(view all)</a>");
				$("#current_game tr:eq(0)").after($("#current_game tr:contains('${currentUser.userName}'):last"));
				$("#current_game tr:gt(1)").remove();
				$("#current_game tr:eq(1)").addClass('table_row');
			}
		</script>
		
	</head>
	<body>
	<iframe width="1600" noresize="noresize" scrolling="no" height="20" frameborder="0" src="https://widgets.tc2000.com/WidgetServer.ashx?id=115011"></iframe>
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