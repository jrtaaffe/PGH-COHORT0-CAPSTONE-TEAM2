<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="/WEB-INF/jsp/header.jsp" />
<script>fnSetTitle("Login");</script>
<script type="text/javascript">
	$(document).ready(function () {
	
		$("form").validate({
			
			rules : {
				userName : {
					required : true
				},
				password : {
					required : true
				}
			},
			messages : {			
				confirmPassword : {
					equalTo : "Passwords do not match"
				}
			},
			errorClass : "error"
		});
	});
</script>

<script>
      function onSignIn(googleUser) {
    	  
        var profile = googleUser.getBasicProfile();
        console.log("ID: " + profile.getId()); // Don't send directly to server
        console.log('Name: ' + profile.getName());
        console.log("Email: " + profile.getEmail());

        // Send the ID token to backend:
        var id_token = googleUser.getAuthResponse().id_token;
        console.log("ID Token: " + id_token);
      };
    </script>

<div class="row">
	<div class="col-sm-4"></div>
	<div class="col-sm-4">
		<c:url var="formAction" value="/login" />
		<form method="POST" action="${formAction}">
		<input type="hidden" name="destination" value="${param.destination}"/>
		<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
		<table class="login_table"><tr>
			<td>
			<a href="javascript: void();"><img src="/img/login_options.png" width="150"></a>
			</td>
			<td class="login_fields">
			<div class="form-group">
				<label for="userName">User Name: </label>
				<input type="text" id="userName" name="userName" placeHolder="User Name" class="form-control" />
			</div>
			<div class="form-group">
				<label for="password">Password: </label>
				<input type="password" id="password" name="password" placeHolder="Password" class="form-control" />
			</div>
			<button type="submit" class="btn btn-default">Login</button>
			</td	>
		</tr></table>
			
			
			
		<!--  	<div class="g-signin2" data-onsuccess="onSignIn"></div> -->
			
		</form>
	</div>
	<div class="col-sm-4"></div>
</div>
<div id="new_registration" class="modal"> 
        <p class="modal_message">You have successfully registered with Equity Elevator!<br><br>Please sign in to begin using the system.</p> 
        <input type="button" class="modal_button" id="ok" value="OK" onclick="$.unblockUI();" /> 
        <br>&nbsp;
</div> 


<c:import url="/WEB-INF/jsp/footer.jsp" />