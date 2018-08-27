<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="/WEB-INF/jsp/header.jsp" />
<script>fnSetTitle("New Game");</script>

<c:url var="formAction" value="/account/createNewGame" />
<form method="POST" action="${formAction}" name="new_game_form">

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
				<table border="0" class="players">
				<tr>
					<td colspan="2" align="center" class="section_label">Invite Players&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
					<td class="add_label">Email Address:</td><td class="add_input"><input type="email"  id="invitee_email" name="email" placeHolder="example@email.com" class="add_user"/><button onclick="fnAddEmail()" type="button">Add</button></td>
				</table>
				<div id="invitees_div">
				</div>
			</div>
			<button type="submit" class="btn btn-default">Create Game</button>
		</div>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="invited_players" value="" multiple>
</form>


<c:import url="/WEB-INF/jsp/footer.jsp" />