<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="/WEB-INF/jsp/header.jsp" />
<script>fnSetTitle("New Game");</script>
<c:url var="formAction" value="/account/createGame" />
<form method="POST" action="${formAction}">
<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
		<div class="content_col">
			<div class="content_row">
				<label for="game_title">Game Title: </label>
				<input type="text" id="game_title" name="game_title" placeHolder="Game Title" class="form-control" required/>
			</div>
			<div class="content_row">
				<label for="start_date">Start Date: </label>
				<input type="date" id="start_date" name="start_date" class="form-control" required/>
			</div>
			<div class="content_row">
				<label for="end_date">End Date: </label>
				<input type="date"  id="end_date" name="end_date" class="form-control" required/>
			</div>
			<div class="content_row">
				<label for="admin">Administrator: </label>${currentUser.getFirstName()} ${currentUser.getLastName()} ${currentUser.getEmail()}
				<input type="hidden" id="admin" name="admin" value="${currentUser.getEmail()}"/>
			</div>
		</div>
			<hr width="100%" noshade>
		<div class="content_col">
			<div class="content_row">
				<div class="section_label">Invite Players</div>
				<div class="add_label">Email Address:</div><input type="email"  id="email" name="email" placeHolder="example@email.com" class="add_user"/>
				<input type="button" name="add" value="Add" class="section_button" onlick="fnAddPlayer()">
				<input type="hidden"  id="players" name="players" class="form-control" required/>
			</div>
			<button type="submit" class="btn btn-default">Create Game</button>
		</div>
</form>


<c:import url="/WEB-INF/jsp/footer.jsp" />