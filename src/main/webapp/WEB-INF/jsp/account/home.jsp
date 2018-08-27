<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="/WEB-INF/jsp/header.jsp" />
<script>fnSetTitle("Current Games");</script>
HOME PAGE


<c:forEach items="${games}" var="game">
	<p>${game.name}</p>
</c:forEach>


<c:import url="/WEB-INF/jsp/footer.jsp" />

<!-- insert into games (name, start_date, end_date, admin) values ('game#1', '2018-08-01', '2018-08-31', 'jrtaaffe@yahoo.com'); -->