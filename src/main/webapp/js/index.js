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
	debugger;
	f = document.forms['update_game_form'];
	f.action.value = theAction;
	f.quantity.value = f.qty_field.value;
	var price = f.price.value;
	f.valueOfStock.value = f.qty_field.value * 100 * price;
	f.submit();
}

function fnLoadTransactions(arr, qty){
	var htmlStr = "<table class=\"stocks_table\">" +
	"<tr class=\"table_row\">" +
	"<td class=\"stock_header\">Symbol</td>" +
	"<td class=\"stock_header\">Name</td>" +
	"<td class=\"stock_header\">Price</td>" +
	"<td class=\"stock_header\">Open</td>" +
	"<td class=\"stock_header\">Daily Hi</td>" +
	"<td class=\"stock_header\">Daily Lo</td>" +
	"<td class=\"stock_header\">+/-</td>" +
	"<td class=\"stock_header\">Qty</td>" +
	"<td class=\"stock_header\"></td>" +
	"</tr>";
	
	for (x in arr){
		htmlStr +="<tr class=\"table_row\">" +
		"<td class=\"table_col\" id=\"symbol\">" + arr[x].symbol + "</td>" +
		"<td class=\"table_col\" id=\"name\">" + arr[x].name + "</td>" +
		"<td class=\"table_col\" id=\"price\">" + arr[x].price + "</td>" +
		"<td class=\"table_col\" id=\"open\">" + arr[x].price_open + "</td>" +
		"<td class=\"table_col\" id=\"daily_hi\">" + arr[x].day_high + "</td>" +
		"<td class=\"table_col\" id=\"daily_lo\">" + arr[x].day_low + "</td>" +
		"<td class=\"table_col\" id=\"plus_minus\">" + arr[x].day_change + "</td>" +
		"<td class=\"table_col\" id=\"qty\">" + qty[x] + "</td>" +
		"<td class=\"table_col\" id=\"buy_sell\"> buy | sell </td>" +
		"</tr>";
	}
	htmlStr += "</table>";
	console.log(htmlStr);
	$('#transactions_div').html(htmlStr);
}


