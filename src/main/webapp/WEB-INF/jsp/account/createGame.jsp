<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="/WEB-INF/jsp/header.jsp" />
<script>fnSetTitle("New Game");</script>
<c:url var="formAction" value="/account/createGame" />
<script type="text/javascript">
	$(document).ready(function () {
		$("form").validate({
			onfocus: false,
			onkeyup: false,
			onclick: false,
			onchange: false,
		});
	});
</script>
<form method="POST" action="${formAction}" name="new_game_form" id="new_game_form">

<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
		<div class="section_label">Game Details</div>
		<hr width="100%" noshade>
		<div class="content_col">
			<div class="content_row">
				<label for="admin">Administrator:&nbsp;<span class="admin_name">${currentUser.getFirstName()} ${currentUser.getLastName()}</span></label>
				<input type="hidden" name="admin" value="${currentUser.getEmail()}"/>
			</div>
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
		</div>
		<hr width="100%" noshade>
		<br><br><div class="section_label">Invite Players</div>
		<hr width="100%" noshade>
		<div class="content_col">
			<div class="content_row">
				<table border="0" class="players">
				<tr>
					<td class="add_label">Email Address:</td>
					<td class="add_input"><input type="email"  id="invitee_email" onchange="void()" name="email" placeHolder="example@email.com" class="add_user form-control"/></td>
					<td>&nbsp;<button onclick="fnAddEmail()" type="button" class="add_button">Add</button></td>
				</tr>
				</table>
				<br>
				<div id="invitees_div">
				</div>
			</div>
		</div>
		<hr width="100%" noshade>
<div class="submit_button"><br><button type="submit" class="btn btn-default" >Save</button></div>
<input type="hidden" name="invited_players" value="" multiple>
</form>


<c:import url="/WEB-INF/jsp/footer.jsp" />