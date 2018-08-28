<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>


<c:import url="/WEB-INF/jsp/header.jsp" />
<script>fnSetTitle("Game Details");</script>
${transactions}
<c:url var="formAction" value="/account/updategame" />
<form method="POST" action="${formAction}" name="new_game_form" id="update_game_form">

<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
<table class="games_table">
	<tr class="table_row">
		<td class="table_header">Title</td>
		<td class="table_header">Start Date</td>
		<td class="table_header">End Date</td>
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
	<td class="add_stock_button">&nbsp;<button onclick="fnAddSymbol()" type="button" class="add_button">Add</button></td>
</tr>
</table>




</form>

<script>

var Api =  function() {    
    
    var url = 'https://query.yahooapis.com/v1/public/yql';
    var query = 'env "store://datatables.org/alltableswithkeys"; select * from yahoo.finance.historicaldata where symbol = "AAPL" and startDate = "2018-08-28" and endDate = "2018-08-28"';
    var def = new $.Deferred(); 

    this.getData = function() {
        $.ajax({
            'url': url,
            'data': {
                'q': query,
                'format': 'json',
                'jsonCompat': 'new',
            },
            'dataType': 'jsonp',
            'success': function(response) {
                def.resolve(response);
            },
        });
        return def.promise();
    };
}
console.log(Api);

</script>





<c:import url="/WEB-INF/jsp/footer.jsp" />

