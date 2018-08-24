<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="/WEB-INF/jsp/header.jsp" />
<script>fnSetTitle("New Game");</script>
<c:url var="formAction" value="/account/createNewGame" />
<form method="POST" action="${formAction}">
<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
		<div class="content_col">
			<div class="content_row">
				<label for="firstName">Game Title: </label>
				<input type="text" id="game_title" name="game_title" placeHolder="Game Title" class="form-control" required/>
			</div>
			<div class="content_row">
				<label for="lastName">Start Date: </label>
				<input type="date" id="start_date" name="start_date" class="form-control" required/>
			</div>
			<div class="content_row">
				<label for="end_date">End Date: </label>
				<input type="date"  id="end_date" name="end_date" class="form-control" required/>
			</div>
			<div class="content_row">
				<label for="admin">Administrator: </label>${currentUser.getFirstName()} ${currentUser.getLastName()}
				<input type="hidden" name="admin" value="${currentUser.getEmail()}"/>
			</div>
		</div>
			<hr width="100%" noshade>
		<div class="content_col">
			<div class="content_row">
				<div class="section_label">Invite Players</div>
				<span>Email Address:</span><input type="email"  id="email" name="email" placeHolder="example@email.com" class="add_user"/>
				<input type="button" name="Add" value="add" class="section_button" onlick="fnAddPlayer()">
				<input type="hidden"  id="players" name="players" class="form-control" required/>
			</div>
			<button type="submit" class="btn btn-default">Create Game</button>
		</div>
</form>


<c:import url="/WEB-INF/jsp/footer.jsp" />