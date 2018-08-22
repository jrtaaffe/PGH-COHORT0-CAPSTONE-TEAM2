<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="/WEB-INF/jsp/header.jsp" />

<script type="text/javascript">
	$(document).ready(function () {
		$.validator.addMethod('capitals', function(thing){
			return thing.match(/[A-Z]/);
		});
		$("form").validate({
			
			rules : {
				password : {
					required : true,
					minlength: 8,
					capitals: true,
				},
				confirmPassword : {
					required : true,		
					equalTo : "#password"  
				}
			},
			messages : {			
				password: {
					minlength: "Password too short, make it at least 15 characters",
					capitals: "Field must contain a capital letter",
				},
				confirmPassword : {
					equalTo : "Passwords do not match"
				}
			},
			errorClass : "error"
		});
	});
</script>

<c:url var="formAction" value="/users" />
<form method="POST" action="${formAction}">
<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
	<div class="row">
		<div class="col-sm-4"></div>
		<div class="col-sm-4">
			<div class="form-group">
				<label for="firstName">First Name: </label>
				<input type="text" id="firstName" name="firstName" placeHolder="First Name" class="form-control" required/>
			</div>
			<div class="form-group">
				<label for="lastName">Last Name: </label>
				<input type="text" id="lastName" name="lastName" placeHolder="Last Name" class="form-control" required/>
			</div>
			<div class="form-group">
				<label for="email">Email: </label>
				<input type="email"  id="email" name="email" placeHolder="example@email.com" class="form-control" required/>
			</div>
			<div class="form-group">
				<label for="userName">User Name: </label>
				<input type="text" id="userName" name="userName" placeHolder="User Name" class="form-control" onBlur="fnCheckDups(this)" required/>
			</div>
			<div class="form-group">
				<label for="password">Password: </label>
				<input type="password" id="password" name="password" placeHolder="Password" class="form-control" required/>
			</div>
			<div class="form-group">
				<label for="confirmPassword">Confirm Password: </label>
				<input type="password" id="confirmPassword" name="confirmPassword" placeHolder="Re-Type Password" class="form-control" required/>	
			</div>
			<button type="submit" class="btn btn-default">Create User</button>
		</div>
		<div class="col-sm-4"></div>
	</div>
</form>

	<script>

function fnCheckDups(theField){
	  var testdata = "{\"" + theField.name.toLowerCase() + "\":\"" + theField.value + "\"}";	
	  var data= {
		      username:$("#userName").val()
		 	 };
		  
	  var data2 = JSON.stringify(data);
	  var myResults = $.ajax({
		  type: "POST",
		  url: "/capstone/validateUsername",
		  data: data2,
		  dataType: 'json',
		  contentType:'application/json'
		});
//	  debugger;

}
	</script>


		
<c:import url="/WEB-INF/jsp/footer.jsp" />