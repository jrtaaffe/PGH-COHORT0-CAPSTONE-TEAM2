function fnAddEmail(){
	var myList = document.getElementById("invitees_div");
	var myEmail = document.getElementById("invitee_email");
	var myPlayers = document.new_game_form.invited_players;	
	var display_list = "";
	var playerArray = [];
	if(myEmail.value != ""){
		if(myPlayers==null) playerArray[0] = myEmail.value;
		else if (myPlayers.value == "") playerArray[0] = myEmail.value;
		else {
			playerArray[0] = myPlayers.value;
			playerArray.push(myEmail.value);
		}
		myPlayers.value = jQuery.unique(playerArray);
		var tempArr = myPlayers.value.split(",");
		debugger;
		for (x in tempArr){
			display_list += "<li id=\"" + tempArr[x] + "\">" + tempArr[x]  + "<button onclick=\"fnRemove('" + tempArr[x] + "')\"></button></li>";
		}
		myList.innerHTML = display_list;
		myEmail.value = "";
		
	}
}
