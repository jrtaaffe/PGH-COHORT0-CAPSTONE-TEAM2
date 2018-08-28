<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>


<c:import url="/WEB-INF/jsp/header.jsp" />
<script>fnSetTitle("Current Games");</script>

<table class="games_table">
	<tr class="table_row">
		<td class="table_header">Title</td>
		<td class="table_header">Start Date</td>
		<td class="table_header">End Date</td>
	</tr>
	<c:forEach items="${games}" var="game">
	<tr class="table_row">
		<td class="table_col1"><a href="">${game.name}</a></td>
		<td class="table_col2"><fmt:formatDate type = "date" 
         value = "${game.startDate}" /></td>
		<td class="table_col3"><fmt:formatDate type = "date" 
         value = "${game.endDate}" /></td>
	</tr>
	</c:forEach>	
</table>

<c:import url="/WEB-INF/jsp/footer.jsp" />

<!-- insert into games (name, start_date, end_date, admin) values ('game#1', '2018-08-01', '2018-08-31', 'jrtaaffe@yahoo.com'); -->