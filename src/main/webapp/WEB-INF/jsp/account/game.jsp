<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>


<c:import url="/WEB-INF/jsp/header.jsp" />
<script>fnSetTitle("${currGame.name}");fnSetCurrPage("game");</script>
<c:url var="formAction" value="/account/game" />
<form method="POST" action="${formAction}" name="new_game_form" id="update_game_form">
<fmt:setLocale value="en_US"/>
<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
<span class="game_title">Game Details</span><span class="game_dates"><fmt:formatDate type = "date" 
         value = "${currGame.startDate}" /> - <fmt:formatDate type = "date" 
         value = "${currGame.endDate}" /></span><span class="game_status"> (${currGame.status})</span>
<table class="games_table" id="current_game">
	<tr class="table_row">
		<td class="table_header" style="text-align: left;">Name</td>
		<td class="table_header">Available Cash</td>
		<td class="table_header">Net Worth</td>
		<td class="table_header">Rank <span class="view_all_link"><a href="javascript:fnShowStandings()">(view all)</a></span></td>
	</tr>
	<tr class="table_row">
		<td class="td_align_left table_col">${currentUser.userName} (${currentUser.lastName}, ${currentUser.firstName})</td>
		<td class="table_col"><fmt:formatNumber value="${walletValue/100}" type="currency"/></td>
		<td class="table_col"><fmt:formatNumber value="${leaderboard[0].netWorth}" type="currency"/></td>
         <td class="td_align_center table_col" id="curr_standing"></td>
	</tr>
</table>
</div><!-- end of inner container div -->
</div><!-- end of outter container div -->


<div class="outter_main_container">
<div class="inner_main_container">
<span class="game_title">Find / Buy Stocks</span>
<br>
<br>
<table class="stock_table">
<tr class="stock_row">
	<td class="add_stock_label">Stock Symbol:</td>
	<td class="add_stock_cell"><input type="text"  id="stock_symbol" name="stock_symbol" class="add_stock_input"/></td>
	<td class="add_stock_button">&nbsp;<button onclick="stockLookup(document.forms['update_game_form'].stock_symbol.value)" type="button" class="add_button">Lookup</button>
	</td>
</tr>
</table>
<div id="symbolLookup">
<table class="games_table">
	<tr class="table_row">
		<td class="td_align_left stock_header">Symbol</td>
		<td class="td_align_left stock_header">Name</td>
		<td class="stock_header">Price</td>
		<td class="stock_header">Open</td>
		<td class="stock_header">Daily Hi</td>
		<td class="stock_header">Daily Lo</td>
		<td class="stock_header">+/-</td>
		<td class="stock_header">Qty</td>		
	</tr>
	<tr class="table_row">
		<td class="td_align_left stock_col" id="symbol"></td>
		<td class="td_align_left stock_col" id="name"></td>
		<td class="stock_col" id="price"></td>
		<td class="stock_col" id="open"></td>
		<td class="stock_col" id="daily_hi"></td>
		<td class="stock_col" id="daily_lo"></td>
		<td class="stock_col" id="plus_minus"></td>
		<td class="stock_col" id="qty"><input type="text" id="qty_field">&nbsp;<button id="buy_button" class="buy_button" >BUY</button></td>
	</tr>
</table>
</div>

</div><!-- end of inner container div -->
</div><!-- end of outter container div -->


<div class="outter_main_container">
<div class="inner_main_container">
<div id="stocks">
<span class="game_title">My Portfolio</span>
<div id="count_down_timer"></div>
<br>
<div id="transactions_div"></div><div id="no_transactions"></div>
<!-- ############### TRANSACTIONS TABLE HERE ############ -->


</div>


<input type="hidden" name="action">
<input type="hidden" name="portfolioId" value="${portfolioId}">
<input type="hidden" name="gameId" value="${currGame.gameId}">
<input type="hidden" name="tickerSymbol">
<input type="hidden" name="quantity">
<input type="hidden" name="price">
<input type="hidden" name="valueOfStock">

</form>

<!-- ####################  Message Dialogs ############## -->
<div id="purchase_successful" class="modal">
	<span class="modal_message">${transactionDetails} was successful!</span><br><br>
	<p></p>
	<input type="button" class="modal_button" id="ok" value="OK" onclick="$.unblockUI();" />
</div>

<div id="no_money" class="modal"> 
        <p class="modal_message">You do not have enough money to make this purchase.</p> 
        <input type="button" class="modal_button" id="ok" value="OK" onclick="$.unblockUI();" /> 
        <br>&nbsp;
</div> 

<div id="not_enough_stock" class="modal"> 
        <p class="modal_message">You do not have enough stock to make this sale.</p> 
        <input type="button" class="modal_button" id="ok" value="OK" onclick="$.unblockUI();" /> 
        <br>&nbsp;
</div> 

<div  id="research_stock" class="modal_research">
<table width="100%"><tr>
<td class="td_align_left"><span class="game_title">Stock Research</span></td>
<td class="td_align_right"><input type="button" class="modal_button" id="cancel" value="Close" onclick="$.unblockUI();" /> 
</td></tr>
<tr><td>&nbsp;</td><td></td></tr>
</table>
<!-- $('.input-3lfOzLDc-:first').val() -->
<!-- TradingView Widget BEGIN -->
<div class="tradingview-widget-container">
  <div id="tradingview_77832"></div>
  <div class="tradingview-widget-copyright"><a href="https://www.tradingview.com/symbols/NASDAQ-AAPL/" rel="noopener" target="_blank"><span class="blue-text">AAPL chart</span></a> by TradingView</div>
  <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
  <script type="text/javascript">
  new TradingView.widget(
  {
  "width": 700,
  "height": 550,
  "symbol": researchSymbol,
  "interval": "D",
  "timezone": "Etc/UTC",
  "theme": "Light",
  "style": "3",
  "locale": "en",
  "toolbar_bg": "#f1f3f6",
  "enable_publishing": false,
  "allow_symbol_change": true,
  "container_id": "tradingview_77832"
}
  );
  </script>
</div>
<!-- TradingView Widget END -->
</div>

<script>
var names = []; 
var cash = []; 
var worth = []; 
var standing = []; 
<c:set var = "count" value ="0" />
<c:forEach items="${leaderboard}" var="userGame">
	names[${count}] = "${userGame.username} (${userGame.lastName}, ${userGame.firstName})";
	cash[${count}] = "${userGame.wallet}";
	worth[${count}] = "${userGame.netWorth}";
	standing[${count}] = "${count + 1}";
	<c:set var="count" value="${count + 1}"/>
	if('${userGame.username}'== '${currentUser.userName}') $('#curr_standing').html('#${count}');
</c:forEach>	
</script>	
<c:import url="/WEB-INF/jsp/footer.jsp" />

