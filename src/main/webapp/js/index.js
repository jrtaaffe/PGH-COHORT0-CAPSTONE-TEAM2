function fnAddEmail(){
	var myList = document.getElementById("invitees_div");
	var myEmail = document.getElementById("invitee_email");
	var myPlayers = document.new_game_form.invited_players;	
	var playerArray = [];
	if(myEmail.value != "" ){
		if ($('#invitee_email').valid()){			
			if(myPlayers==null) playerArray[0] = myEmail.value;
			else if (myPlayers.value == "") playerArray[0] = myEmail.value;
			else {
				playerArray[0] = myPlayers.value;
				playerArray.push(myEmail.value);
			}
			myPlayers.value = playerArray;
			var tempArr = myPlayers.value.split(",");
			tempArr = jQuery.unique(tempArr);
			myPlayers.value = tempArr;
			fnLoadEmails();
			myEmail.value = "";		
		}
	}
}
function fnRemove(selector){
	var myPlayers = document.new_game_form.invited_players;	
	var myArr = myPlayers.value.split(",");
	var index = myArr.indexOf(selector);
	if (index > -1) {
	  myArr.splice(index, 1);
	}
	myPlayers.value = myArr;
	fnLoadEmails();
	}
function fnLoadEmails(){
	var myList = document.getElementById("invitees_div");
	var myPlayers = document.new_game_form.invited_players;	
	var arr = myPlayers.value.split(",");
	var display_list = "";
	for (x in arr){
		index= parseInt(x)+1;
		display_list += "<li id=\"" + arr[x] + "\">(" + index + ") " + arr[x]  + "&nbsp;&nbsp;<button onClick=\"fnRemove('" + arr[x] + "')\" label=\"X\" class=\"remove_button\">x</button></li>";
	}
	if (arr[0] =="") myList.innerHTML = ""
	else myList.innerHTML = display_list;
}

function fnBuyStock(theAction){
	f = document.forms['update_game_form'];
	f.action.value = theAction;
	f.portfolio_id.value = ${portfolioId};
	f.ticker_symbol.value = $('#symbol').html();
	f.quantity.value = f.qty_field.value;
	var price = $('#price').html();
	f.value_of_stock.value = f.qty_field.value * 100 * price;
	f.submit();
}



