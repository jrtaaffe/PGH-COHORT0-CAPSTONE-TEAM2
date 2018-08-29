<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>


<c:import url="/WEB-INF/jsp/header.jsp" />
<script>fnSetTitle("Game Details");</script>
${transactions}
<c:url var="formAction" value="/account/game" />
<form method="POST" action="${formAction}" name="new_game_form" id="update_game_form">

<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
<table class="games_table">
	<tr class="table_row">
		<td class="table_header">Title</td>
		<td class="table_header">Start Date</td>
		<td class="table_header">End Date2</td>
	</tr>
	<tr class="table_row">
		<td class="table_col1">${currGame.name}</td>


		<td class="table_col2"><fmt:formatDate type = "date" 
         value = "${currGame.startDate}" /></td>
		<td class="table_col3"><fmt:formatDate type = "date" 
         value = "${currGame.endDate}" /></td>
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
		<td class="table_col" id="qty"><input type="text" id="qty_field"><button onclick="fnBuyStock('B')">BUY</button></td>
	</tr>
</table>

</div>


</div><!-- end of inner container div -->
</div><!-- end of outter container div -->



<div class="outter_main_container">
<div class="inner_main_container">
<div id="stocks">
<br>
<table class="stocks_table">
	<tr class="table_row">
		<td class="stock_header">Symbol</td>
		<td class="stock_header">Name</td>
		<td class="stock_header">Price</td>
		<td class="stock_header">Open</td>
		<td class="stock_header">Daily Hi</td>
		<td class="stock_header">Daily Lo</td>
		<td class="stock_header">+/-</td>
		<td class="stock_header"></td>		
	</tr>
	<tr class="table_row">
		<td class="table_col" id="symbol"></td>
		<td class="table_col" id="name"></td>
		<td class="table_col" id="price"></td>
		<td class="table_col" id="open"></td>
		<td class="table_col" id="daily_hi"></td>
		<td class="table_col" id="daily_lo"></td>
		<td class="table_col" id="plus_minus"></td>
		<td class="table_col" id="buy_sell"></td>
	</tr>
</table>

</div>


<input type="hidden" name="action">
<input type="hidden" name="portfolioId" value="${portfolioId}">
<input type="hidden" name="tickerSymbol">
<input type="hidden" name="quantity">
<input type="hidden" name="price">
<input type="hidden" name="valueOfStock">

</form>

<!-- portfolio_id, action, ticker_symbol, quantity, value_of_stock (qty * price * 100) -->

<c:import url="/WEB-INF/jsp/footer.jsp" />

