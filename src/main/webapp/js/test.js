
var rows = 51;
var j="J0n";var u="kpass"
//var weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
var weekdays = ["SUN","MON","TUE","WED","THU","FRI","SAT"];
var icons = ["clear-day","clear-night","partly-cloudy-day","partly-cloudy-night","cloudy","cloudy","cloudy","cloudy","rain","rain","rain","rain","rain","rain","snow","snow","fog","fog"];
var open_weather_icons = ["01d","01n", "02d", "02n", "03d", "03n", "04d", "04n", "09d", "09n", "10d", "10n", "11d", "11n", "13d", "13n", "50d", "50n"];
var tempHigh = 0.1;
var tempLow = 0.1;
var currTemp = 0.1;
var currHum  = 0.1;
var currCond = "";
var currRain = null;
hass_states = {};
var speakers =['sun_room','kitchen','dining_room','master_bedroom'];

//#####################################
//## Make the volumio iframe resizable
//#####################################

$(function() {
    $("#resizable").resizable();

    $("#resizable").resizable({
        resize: function(event, ui) {
            $("#card_border").css({ "height": ui.size.height+10,"width":ui.size.width+10});
        }
    });
});
//#####################################

function fnPrintDateRow(json, theDate, i, dateIndex){
    blob = document.getElementById("weekday" + dateIndex);
//  blob.innerHTML = '<span class="glyphicon glyphicon-plus"></span>&nbsp;';
    blob.innerHTML += weekdays[theDate.getDay()];
    blob = document.getElementById("ltemp" + dateIndex);
    tempLow = json.list[i].main.temp_min.toPrecision(2);
    blob.innerHTML = tempLow + "&deg;";
    dateIndex==0?$('#temp_lo').html(tempLow):"";
    blob = document.getElementById("htemp" + dateIndex);
    tempHigh = json.list[i].main.temp_max.toPrecision(2);
    blob.innerHTML = tempHigh + "&deg;";
    dateIndex==0?$('#temp_hi').html(tempHigh):"";
    blob = document.getElementById("icon" + dateIndex);
    var dayIcon = json.list[i].weather[0].icon;

    if (dayIcon.substring(dayIcon.length-1, dayIcon.length) == "n") {dayIcon = dayIcon.substring(0, dayIcon.length-1) + "d"}
    blob.innerHTML = '<img src="icons/' + icons[open_weather_icons.indexOf(dayIcon)] + '.png">';
}
function fnPrintHoursCell(json, theDate, i, dateIndex, hoursIndex){
    var timeStr = theDate.toLocaleTimeString();
    var theTemp = 0;
    timeStr = timeStr.substring(0,timeStr.indexOf(":")) + timeStr.substring(timeStr.indexOf(" ") + 1,timeStr.length);
    blob = document.getElementById("time" + dateIndex + "_" + hoursIndex);
    blob.innerHTML = timeStr;
    blob = document.getElementById("temp" + dateIndex + "_" + hoursIndex);
    theTemp = json.list[i].main.temp.toPrecision(2);
    blob.innerHTML = theTemp + "&deg;";
    if (tempLow > theTemp) {tempLow = theTemp;document.getElementById("ltemp" + dateIndex).innerHTML = tempLow + "&deg;";dateIndex==0?$('#temp_lo').html(tempLow):"";}
    blob = document.getElementById("icon"  + dateIndex + "_" + hoursIndex);
    if (tempHigh < theTemp) {tempHigh = theTemp; document.getElementById("htemp" + dateIndex).innerHTML = tempHigh + "&deg;";dateIndex==0?$('#temp_hi').html(tempHigh):"";}
    blob.innerHTML = '<img src="icons/' + icons[open_weather_icons.indexOf(json.list[i].weather[0].icon)] + '.png">';

    document.getElementById("htemp" + dateIndex)
}
function fnLoadForecast(json){
    var oldDate = "";
    var dt = json.list[0].dt;
    var theDate = new Date(dt * 1000);
    var hoursIndex = 0;
    var dateIndex = 0;
    currTemp = json.list[0].main.temp.toPrecision(2);
    currHum = json.list[0].main.humidity.toPrecision(2);
    currCond = json.list[0].weather[0].description;
    currRain = json.list[0].rain;
    currRain!=null && currRain!='undefined' ? currRain=currRain : currRain=0;
//  console.log(currRain);
//  console.log(currRain['3h']);
    var options = { weekday: 'long', month: 'long', day: 'numeric' };
    var today  = new Date();
    document.getElementById("theDate").innerHTML = today.toLocaleDateString("en-US", options).toUpperCase();
    document.getElementById("theTemp").innerHTML = currTemp + "&deg;F";
    $("#temp_curr").html(currTemp);
    $("#humidity").html(currHum);
    for (x=0; x<rows; x++){
        var dt = json.list[x].dt;
        var theDate = new Date(dt * 1000);
        var dateStr = theDate.toDateString();
        dateStr = dateStr.substring(0,dateStr.lastIndexOf(" "))
        if (oldDate != dateStr){
            if (oldDate != "" && oldDate!= dateStr) dateIndex += 1;
            if(dateIndex > 4) {break;}
            fnPrintDateRow(json, theDate, x, dateIndex);
            oldDate = dateStr;
            hoursIndex = 0;
        }
        fnPrintHoursCell(json, theDate, x,  dateIndex, hoursIndex);
        hoursIndex += 1;
    }
    fnHideEmtpyDivs();
    fnCalcWeatherImages();
}
function fnHideEmtpyDivs(){
    var allDivs = document.getElementsByClassName("time_cell");
    for (x=0; x < allDivs.length; x++){
        if(allDivs[x].innerHTML.indexOf("img")=== -1) {
            allDivs[x].style.visibility = "hidden"
        }
    }
}
var activate_weather_toggles = function() {
    $(".day").click(function() {
        $(this).next().toggle();
//    $(this).find('.weekday span').toggleClass('glyphicon-minus');
    });
};
function fnCalcWeatherImages(){
    var imgBase ="images/blue_dial_";
    var x = Math.round(currTemp/10);
    $('.weather_card #curr').attr('src',imgBase + x + ".png");
    x = Math.round(tempHigh/10);
    $('.weather_card #hi').attr('src',imgBase + x + ".png");
    x = Math.round(tempLow/10);
    $('.weather_card #lo').attr('src',imgBase + x + ".png");
    x = Math.round(currHum/10);
    $('.weather_card #hum').attr('src',imgBase + x + ".png");
}
function showTime(){
    var date = new Date();
    var h = date.getHours(); // 0 - 23
    var m = date.getMinutes(); // 0 - 59
    var s = date.getSeconds(); // 0 - 59
    var session = "AM";
    if(h == 0){
        h = 12;
    }
    if(h > 12){
        h = h - 12;
        session = "PM";
    }
    h = (h < 10) ? "0" + h : h;
    m = (m < 10) ? "0" + m : m;
    s = (s < 10) ? "0" + s : s;
    var time = h + ":" + m + ":" + s + " " + session;
    document.getElementById("MyClockDisplay").innerText = time;
    document.getElementById("MyClockDisplay").textContent = time;
    setTimeout(showTime, 1000);
}
function fnToggle(ent){
    var domain = ent.substring(0,ent.indexOf('.'));
    var command = ent.substring(ent.indexOf('.'));
    var rgb = document.getElementById(ent + "_rgb");
//        for(var propertyName in rgb) {console.log(propertyName + " : " + rgb[propertyName])}
    var currSlider = document.getElementById(ent);
    var currPct = document.getElementById(ent + "_pct");
    var pct = Math.round(brightness/2.55);
    var pctStr = pct.toString() + '%';
    tempRGB= (rgb==null?null:rgb==""?null:rgb=="undefined"?null:eval(rgb['value']));
    if(currPct["value"]=="" || currPct["value"]=="0%"){
        fnHACommand(domain, command, ent, 255,tempRGB);
        isLight = true;
        isOn = true;
        brightness = 255;
        entity = ent;
        rgb = (tempRGB==null?null:rgb['value']);
        process("state","on");
    }
    else{
        fnHACommand(domain, command, ent, 0,tempRGB);
        currSlider.childNodes[0].style.width = "0%";
        currSlider.childNodes[1].style.left =  "0%";
        currPct.value = "0%"
    }
}

var i="@";
function fnHACommand(domain, command, entity, brightness, rgb){
    if(brightness!=0&&rgb!=null&&rgb!=""&&rgb!='undefined') var data={ "entity_id":entity, "brightness":brightness, "rgb_color":rgb};
    else if(brightness!=0) var data={ "entity_id":entity, "brightness":brightness};
    else var data={ "entity_id":entity};
    $.ajax({
        url: "https://taaffe.duckdns.org:8123/api/services/" + domain + "/" + command + "?api_password=" + u,
        dataType:"json",
        data:JSON.stringify(data),
        contentType:"application/json",
        type: "POST",
        crossDomain:true,
        success: function(res) {
//          console.log(res);
        }
    });
}
function fnHACommandv2(domain, command, data){
    $.ajax({
        url: "https://taaffe.duckdns.org:8123/api/services/" + domain + "/" + command + "?api_password=" + u,
        dataType:"json",
        data:data,
        contentType:"application/json",
        type: "POST",
        crossDomain:true,
        success: function(res) {
            //console.log(res);
        }
    });
}
function fnToggleScene(scene, myCheckbox){
    debugger;
    if($("#" + scene).prop( "checked" )) fnHACommandv2("hue", "hue_activate_scene", '{"group_name":"Kitchen Lightstrips","scene_name":"' + scene + '"}');
    else fnHACommandv2("light", "turn_off", '{"entity_id":"light.kitchen_lightstrips"}');
}

function fnGetCurrentStates(){
    var sliderStr = "https://taaffe.duckdns.org:8123/api/states?api_password=" + u;
    $.getJSON(sliderStr, function(data) {
        $("#states").html(JSON.stringify(data));
        traverse(data,process);
    });
    return JSON.parse($("#states").html());
}

function fnSetDefaultSliderValues(){
    fnGetCurrentStates();
}

function getObj(name){
    for(o in hass_states){
        if(hass_states[o].hasOwnProperty('entity_id')){
            if(hass_states[o].entity_id==name)return hass_states[o];
        }
    }
    return name + ' not found';
}
function setSpeakerDefaults(){
    for (s in speakers){
        currObj = getObj('media_player.' + speakers[s]);
        if (currObj.attributes.source=="Line-in") $("input[name='speakers'][value='" + speakers[s] + "']" ).prop('checked',true);
    }
}
function sendSpeakerChoices(){
    var checkedSpeakers=[];
    var eId;
    for (s in speakers){
        if ($("input[name='speakers'][value='" + speakers[s] + "']" ).prop('checked')==true){
            checkedSpeakers.push("media_player." + speakers[s]);
        }
    }
    eId = "\"entity_id\":\"" + checkedSpeakers.join() + "\"";
    var join_data = "{" + eId + ",\"master\": \"media_player." + checkedSpeakers[0] + "\"}";
    var source_data = "{" + eId + ",\"source\": \"Line-in\"}";
    fnHACommandv2("media_player", "sonos_join", join_data);
    fnHACommandv2("media_player", "select_source", source_data);
}

var isLight;
var isOn;
var brightness;
var entity;
var rgb;
function process(key,value) {
    if (key=="attributes"){isLight=false;isOn=false;brightness="0";entity="";rgb=""}
    else if (key=="entity_id"){entity=value;if (value.indexOf("light.")!=-1){isLight=true;}}
    else if (key=="brightness"){brightness=value;}
    else if (key=="state" && value=="on") {isOn=true;}
    else if (key=="rgb_color"){rgb=value;}
//console.log(key + " : "+value + " : " + isLight + " : " + isOn + " : " + brightness);
    if (isLight){
        var currSlider = document.getElementById(entity);
        var currPct = document.getElementById(entity + "_pct");
        if (isOn&&brightness!="0"&&currSlider != null){
            var pct = Math.round(brightness/2.55);
            var pctStr = pct.toString() + '%';
            currSlider.childNodes[0].style.width = pctStr;
            currSlider.childNodes[1].style.left =  pctStr;
            currPct.value = pctStr;
            if(rgb!=""&&rgb!=null&&rgb!='undefined'){
                currColorButton = document.getElementById(entity + "_button");
                $(currColorButton).css("background-color",rgb);
                document.getElementById(entity + "_rgb").value=rgb;
            }
//    console.log("FOUND!!" + entity + " : " + isLight + " : " + isOn + " : " + brightness + " : " + rgb);
        }
        else if(currSlider != null) {
            currSlider.childNodes[0].style.width = "0%";
            currSlider.childNodes[1].style.left =  "0%";
            currPct.value = "0%";
        }
    }
}
function traverse(o,func) {
    for (var i in o) {
        func.apply(this,[i,o[i]]);
        //console.log(i + o[i]);
        if (o[i] !== null && typeof(o[i])=="object") {
            //going one step down in the object tree!!
            if(o[i].friendly_name == "Jennifer") fnLoadDeviceTracker(o,i,o[i].friendly_name);
            if(o[i].friendly_name == "Jonathan") fnLoadDeviceTracker(o,i,o[i].friendly_name);
            //if(o[i].friendly_name == "iPhone Battery Level") console.log(o);
            //if(o[i].friendly_name == "Jonathan/'s iPhone Battery Level") console.log(o);
            traverse(o[i],func);
        }
    }
}

function fnLoadDeviceTracker(o,i,fn){
    var imgBase ="images/blue_dial_";
    var x = Math.round(o[i].battery/10);
    var lat = o[i].latitude;
    var lon = o[i].longitude;
    var mapURL = "https://www.google.com/maps/@?api=1&map_action=map&center=" + lat + "," + lon;
    //<br>Lat: " + o[i].latitude + "<br>Lon: " + o[i].longitude + "<br>As of: " + o.last_updated + "<br>State: " + o.state
    $("#" + fn).html("<a href=\"" + mapURL + "\"><img src=\"" + imgBase + x + ".png" + "\" class=\"deviceDial\"><img src=\"" + o[i].entity_picture + "\" class=\"profilePic overlay\"><figcaption class=\"weather_caption\">" + fnDisplayState(o.state) + " (" + o[i].battery + "%) </figcaption></a>");
}
function fnDisplayState(state){
    if(state=="not_home") return("AWAY");
    else if(state=="Jennifers Work") return("WORK");
    else if(state=="home" || state=="Home") return("HOME");
    else return(state);
}
u=j+i+"th"+i+"n";
function update(picker, name) {
    document.getElementById(name).value ='['+
        Math.round(picker.rgb[0]) + ', ' +
        Math.round(picker.rgb[1]) + ', ' +
        Math.round(picker.rgb[2]) + ']';
}

$(document).ready(function(e) {
    showTime();
    includeHTML();
    $.getJSON('https://api.openweathermap.org/data/2.5/forecast?zip=15218,us&apikey=ccb8c2661a426fea5eb9217a8f56cf80&units=imperial', function(data) {
        fnLoadForecast(data);
        $(".mypanel").html(JSON.stringify(data));
    });
    fnSetDefaultSliderValues();
    activate_weather_toggles();
    setSpeakerDefaults();
});
$(document).on('mouseover', '.day', function(){
    $(this).css({'background-color':'white'});
    var w = $(this).find("div[id^='htemp']");
    var dayIndex = (w.attr('id').charAt(5));
    $('#hourly_display').html($('#hourlyRow' + dayIndex).html());
    $('#hourly_display').css({'visibility':'visible'});
    $('#hourly_display').find('#hourlyRow' + dayIndex).css({'visibility':'visible','z-index':'-1'});
    document.getElementById("hourly_display").style.zIndex = "100000";
    document.getElementById("hourly_display").style.position = "absolute";
});
$(document).on('mouseout', '.day', function(){
    $(this).css('background-color','#004C98');
    var w = $(this).find("div[id^='htemp']");
    var dayIndex = (w.attr('id').charAt(5));
    $('#hourly_display').css({'visibility':'hidden'});
});

