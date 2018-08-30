<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>


<c:import url="/WEB-INF/jsp/header.jsp" />
<script>fnSetTitle("Game Details");fnSetCurrPage("game");</script>
<c:url var="formAction" value="/account/game" />
<form method="POST" action="${formAction}" name="new_game_form" id="update_game_form">
<fmt:setLocale value="en_US"/>
<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
<span class="game_title">${currGame.name}</span><span class="game_dates"><fmt:formatDate type = "date" 
         value = "${currGame.startDate}" /> - <fmt:formatDate type = "date" 
         value = "${currGame.endDate}" /></span><span class="game_status"> (${currGame.status})</span>
<table class="games_table" id="current_game">
	<tr class="table_row">
		<td class="table_header">Name</td>
		<td class="table_header">Available Cash</td>
		<td class="table_header">Net Worth</td>
		<td class="table_header">Game Standing <span class="view_all_link"><a href="javascript:fnShowStandings()">(view all)</a></span></td>
	</tr>
	<tr class="table_row">
		<td class="table_col">${currentUser.userName}</td>
		<td class="table_col"><fmt:formatNumber value="${walletValue/100}" type="currency"/></td>
		<td class="table_col"><fmt:formatNumber value="${leaderboard[0].netWorth}" type="currency"/>
		</td>
         <td class="table_col"></td>
	</tr>
</table>
<br>
<br>
<table class="stock_table">
<tr class="stock_row">
	<td class="add_stock_label">Stock Symbol:</td>
	<td class="add_stock_cell"><input type="text"  id="stock_symbol" name="stock_symbol" class="add_stock_input"/></td>
	<td class="add_stock_button">&nbsp;<button onclick="stockLookup(document.forms['update_game_form'].stock_symbol.value)" type="button" class="add_button">Lookup</button></td>
</tr>
</table>
<div id="symbolLookup">
<br>
<table class="games_table">
	<tr class="table_row">
		<td class="stock_header">Symbol</td>
		<td class="stock_header">Name</td>
		<td class="stock_header">Price</td>
		<td class="stock_header">Open</td>
		<td class="stock_header">Daily Hi</td>
		<td class="stock_header">Daily Lo</td>
		<td class="stock_header">+/-</td>
		<td class="stock_header">Qty</td>		
	</tr>
	<tr class="table_row">
		<td class="table_col" id="symbol"></td>
		<td class="table_col" id="name"></td>
		<td class="table_col" id="price"></td>
		<td class="table_col" id="open"></td>
		<td class="table_col" id="daily_hi"></td>
		<td class="table_col" id="daily_lo"></td>
		<td class="table_col" id="plus_minus"></td>
		<td class="table_col" id="qty"><input type="text" id="qty_field"><button id="buy_button" class="buy_button" >BUY</button></td>
	</tr>
</table>

</div>



</div><!-- end of inner container div -->
</div><!-- end of outter container div -->




<div class="outter_main_container">
<div class="inner_main_container">
<div id="stocks">
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


<c:import url="/WEB-INF/jsp/footer.jsp" />

