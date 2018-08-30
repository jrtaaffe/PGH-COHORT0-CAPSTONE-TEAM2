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

function fnBuyStock(theAction, tickerSymbol, qty, price){
	f = document.forms['update_game_form'];
	f.action.value = theAction;
	f.quantity.value = qty;
	f.tickerSymbol.value = tickerSymbol;
	f.price.value = price;
	f.valueOfStock.value = qty * 100 * price;
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
	"<td class=\"stock_header\">Shares</td>" +
	"<td class=\"stock_header\">&nbsp;Qty</td>" +
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
		"<td class=\"table_col\" id=\"buy_sell\">" +
		"<input type=\"text\"  id=\"sell_qty_" + arr[x].symbol + "\" \" name=\"sell_qty_" + 
		arr[x].symbol + "\" class=\"sell_qty td_align_center\"/></td><td>" +
		"<button class=\"buy_button\" onclick=\"fnBuyStock('S','" + arr[x].symbol + "', $('#sell_qty_" + arr[x].symbol +"').val(),"+arr[x].price+");\">SELL</button></td>" +
		"</tr>";
	}
	htmlStr += "</table>";
	$('#transactions_div').html(htmlStr);
	if(  $("#transactions_div").is(":visible") == false ) $('#transactions_div').toggle();
}

function countDownTimer(){
	// Set the date we're counting down to
	var countDownDate = new Date("Jan 5, 2019 15:37:25").getTime();

	// Update the count down every 1 second
	var x = setInterval(function() {

	  // Get todays date and time
	  var now = new Date().getTime();

	  // Find the distance between now and the count down date
	  var distance = countDownDate - now;

	  // Time calculations for days, hours, minutes and seconds
	  var days = Math.floor(distance / (1000 * 60 * 60 * 24));
	  var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
	  var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
	  var seconds = Math.floor((distance % (1000 * 60)) / 1000);

	  // Display the result in the element with id="demo"
	  document.getElementById("count_down_timer").innerHTML = days + "d " + hours + "h "
	  + minutes + "m " + seconds + "s ";

	  // If the count down is finished, write some text 
	  if (distance < 0) {
	    clearInterval(x);
	    document.getElementById("count_down_timer").innerHTML = "EXPIRED";
	  }
	}, 1000);
}