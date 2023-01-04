// 사업자번호 법인 번호 포맷
function getBusinessNumberFormat(value){
	if(value.length == 10){
		return value.substring(0, 3) + "-" + value.substring(3, 5) + "-"  + value.substring(5);

	}else if(value.length == 13){
		return value.substring(0,6) + "-" + value.substring(6);

	}else {
		return value;
	}
}

// 일자 포맷 yyyy-mm-dd
function getDateFormat2(value){
	if(value != "null" && value.length == 14){
		return value.substring(0,4) + "-" + value.substring(4,6) + "-" +value.substring(6,8) + " " +
		value.substring(8,10) + ":"+value.substring(10,12) + ":"+value.substring(12);

	}else if(value.length == 8){
		return value.substring(0,4) + "-" + value.substring(4,6) + "-" +value.substring(6);

	}else if(value.length == 6){
		return value.substring(0,4) + "-" + value.substring(4,6);

	}else{
		return value;
	}
}

//일자 포맷 hh:mm
function getDateFormat3(value){

	if(value != null && value.length == 6){
		return value.substring(0,2) + ":" + value.substring(2,4);// + ":" +value.substring(4);

	}else if(value != null && value.length == 4){
		return value.substring(0,2) + ":" + value.substring(2);

	}else{
		return value;
	}
}

//일자 포맷 hh:mm:ss
function getDateFormat4(value){
	if(value != null && value.length == 6){
		return value.substring(0,2) + ":" + value.substring(2,4) + ":" +value.substring(4);

	}else if(value != null && value.length == 4){
		return value.substring(0,2) + ":" + value.substring(2);

	}else{
		return value;
	}
}

// 초 -> 분초
function getDateSecondiversion(value){
	if(value != null && value >= 60){

		var minute = value/60;
		var second = value%60;
		return Math.floor(minute)+"분"+second+"초";

	}else if(value != null && value < 60){

		var second = value%60;
		return second+"초";

	}else{
		return value;
	}

}

// 전화번호 포맷
function getPhoneNumberFormat(value){
	if (value == undefined || value == null || value == "null") {
		return "";
	}

	var value2 = value.split('-').join('');

	if(value.length == 9 && value2.substring(0,2) == "02"){
		return value2.substring(0,2) + "-" + value2.substring(2,5) + "-" + value2.substring(5);
	}else if(value2.length == 10 && value2.substring(0,2) == "02"){
		return value2.substring(0,2) + "-" + value2.substring(2,6) + "-" + value2.substring(6);

	}else if(value2.length == 10 && value2.substring(0,2) != "02"){
		return value2.substring(0,3) + "-" + value2.substring(3,6) + "-" + value2.substring(6);

	}else if(value2.length == 11 && value2.substring(0,2) != "02"){
		return value2.substring(0,3) + "-" + value2.substring(3,7) + "-" + value2.substring(7);

	}else{
		return isNullChange(value);
	}
}

//전화번호 포맷 2
function fun_PhoneNumberFormat2(str) {
	if (str == undefined || str == null || str == "null") {
		return "";
	}

	str = str.replace(/[^0-9]/g, '');

	var tmp = '';

	if (str.length < 4) {
		return str;

	} else if (str.length < 7) {
		tmp += str.substr(0, 3);
		tmp += '-';
		tmp += str.substr(3);

		return tmp;

	} else if (str.length < 11) {
		tmp += str.substr(0, 3);
		tmp += '-';
		tmp += str.substr(3, 3);
		tmp += '-';
		tmp += str.substr(6);

		return tmp;

	} else {
		tmp += str.substr(0, 3);
		tmp += '-';
		tmp += str.substr(3, 4);
		tmp += '-';
		tmp += str.substr(7);

		return tmp;
	}
	return str;
}

// 숫자 포맷
function getNumberFormat(str){
	if(str == "") return "";

	var regMustNumberComma = /^[0-9|,]+$/;
	var regMustNoStartZero = /^[0]/;

	str = str.replace(/,/g,'');
	var retValue = "";
    for(var i = 1; i <= str.length; i++ ) {
        if( i > 1 && (i%3) == 1 )
            retValue = str.charAt(str.length - i) + "," + retValue;
        else
            retValue = str.charAt(str.length - i) + retValue;
    }
    if( regMustNoStartZero.test(retValue) == true && window.event.keyCode != 9 && str.length > 1) {
        alert("입력숫자는 '0'으로 시작할 수 없습니다.");
        return "";
    }
    if( regMustNumberComma.test(retValue) == false ) {
        alert("숫자만 입력하실 수 있습니다.");
        return "";
    }
    return getNumberFormat2(retValue);
}

// 숫자 포맷
function getNumberFormat2(str){
	if(str == null || str == "") return "";
	return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g,"$1,");
}

function getNumberFormat3(str){
	if(str == null || str == "") return "-";
	return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g,"$1,");
}

function getNullFormat(str){
	if(str == null || str == "") return "-";
	return str;
}

// 일자 생성2
function date2(day, str){
	var date = new Date(day);
	var targetDate = date.getDate() + str;
	date.setDate(targetDate);
	return date.getFullYear() +"-"+ getDateFormat(date.getMonth()+1) +"-"+ getDateFormat(date.getDate());
}

// 일자 생성
function date(str){
	var date = new Date();
	var targetDate = date.getDate() + str;
	date.setDate(targetDate);
	return date.getFullYear() +"-"+ getDateFormat(date.getMonth()+1) +"-"+ getDateFormat(date.getDate());
}

// 월의 마지막 일자 yyyy-MM-dd 출력
function totalDate(){
	var date = new Date();
	var targetDate = date.getDate();
	date.setDate(targetDate);
	return date.getFullYear() +"-"+ getDateFormat(date.getMonth()+1) +"-"+ getDateFormat(getTotalDate(date.getFullYear(), date.getMonth()+1));
}

function getTotalDate(year, month){
	if(month==4 || month==6 || month==9 || month==11){
		return 30;

	}else if(month==2){ // 2월일때
		if(year%4 == 0) // 2월이면서 윤년일 때
			return 29;

		else{
			return 28; // 2월이면서 윤년이 아닐 때
		}

	}else{
		return 31;
	}
}

function fun_getToday(){
	var msg;
    var now = new Date();
    var mil = now.getMilliseconds();
    var sec = now.getSeconds();
    var min = now.getMinutes();
    var hour = now.getHours();

	var dd = now.getDate();
	var mm = now.getMonth()+1;
	var yyyy = now.getFullYear();
	if(dd<10) {
	    dd='0'+dd;
	}
	if(mm<10) {
	    mm='0'+mm;
    }

    if(sec<10){
        sec='0'+sec;
    }
    if(min<10){
        min='0'+min;
    }
    if(hour<10){
        hour='0'+hour;
    }

    var nowDateRemoveSplit = String(yyyy) + String(mm) + String(dd);
    var nowTimeRemoveSplit = String(hour) + String(min) + String(sec);

	var nowDate = yyyy + '-' + mm + '-' + dd;
    var nowTime = hour + ":" + min + ":" + sec;
    var fullDateTime = nowDate + " " + nowTime;
    var fullDateTimeMil = nowDate + " " + nowTime + ":" + mil;
    msg = {"yyyy" : yyyy, "mm" : mm, "dd" : dd, "hour" :hour, "min" : min, "sec":sec, "mil":mil
        , "date" : nowDate, "time" : nowTime, "fullDateTime" : fullDateTime, "fullDateTimeMil" : fullDateTimeMil
        , "nowDateRemoveSplit" : nowDateRemoveSplit , "nowTimeRemoveSplit" : nowTimeRemoveSplit};
	return msg;
}

function getDateFormat(month) {
	if(month < 10) return "0" + month;
	return month;
}

// 단위 표시 포맷
function getMarkFormat(str, mark){
	if(str !== "") return getNumberFormat2(str) + mark;
	else return str;
}

function showProgressBar(){
	$("body").append("<div id='progressBarPopup'><img src='./common/images/comm/ico/viewProgressBar.gif' /></div>");
	$("#progressBarPopup").width(32);
	$("#progressBarPopup").height(32);

	$("#progressBarPopup").modal({opacity:50, overlayCss:{"background-color": "#fff"}});
}

function hideProgressBar(){
	if($("#progressBarPopup").attr("id") != null
			&& $("#progressBarPopup").attr("id") != undefined
			&& $("#progressBarPopup").attr("id") != "")	{

		$.modal.close();
		$("#progressBarPopup").hide().remove();
		$("#simplemodal-container").hide().remove();
		$("#simplemodal-placeholder").hide().remove();
		$("#simplemodal-overlay").hide().remove();
	}
}

function getDomain() {
	var dns, arrDns, str;
	dns = document.location.href;
	arrDns = dns.split("//");
	str = arrDns[1].substring(0,arrDns[1].indexOf("/"));
	return str;
}

function isNullChange(val){
	if(val == undefined || val == null || val == "null"){
		return "";
	}
	return val;
}

// 날짜차이
function daysBetween(date1, date2) {
    // First we split the values to arrays date1[0] is the year, [1] the month and [2] the day
    date1 = date1.split('-');
    date2 = date2.split('-');

    // Now we convert the array to a Date object, which has several helpful methods
    date1 = new Date(date1[0], date1[1], date1[2]);
    date2 = new Date(date2[0], date2[1], date2[2]);

    // We use the getTime() method and get the unixtime (in milliseconds, but we want seconds, therefore we divide it through 1000)
    var date1_unixtime = parseInt(date1.getTime() / 1000);
    var date2_unixtime = parseInt(date2.getTime() / 1000);

    // This is the calculated difference in seconds
    var timeDifference = date2_unixtime - date1_unixtime;

    // in Hours
    var timeDifferenceInHours = timeDifference / 60 / 60;

    // and finaly, in days :)
    var timeDifferenceInDays = timeDifferenceInHours  / 24;

    return timeDifferenceInDays;
}


// ajax get send
function fun_ajaxGetSend(url, inputData, bAsync, callback) {
	$.ajax({
        type: 'GET'
        , url: url
        , async : bAsync
        , contentType: 'application/json; charset=utf-8'
        , data: JSON.stringify(inputData)
        , dataType: "json"
        , success: function (msg) {
            callback(msg);
        } // end success
        , error: function (xhr, status, error) {
			if(xhr.status==403){
				alert("세션이 만료되었습니다");
				location.href='/admin/loginView.do';
			}
        } // end error
    }); // end ajax
} // end fun_ajaxPostSend

function fun_startBlockUI(){
	$.blockUI({ 
				message: "Loading 중입니다.", 
				css: { 
		            border: 'none', 
		            padding: '15px', 
		            backgroundColor: '#000', 
		            '-webkit-border-radius': '10px', 
		            '-moz-border-radius': '10px', 
		            opacity: .5, 
		            color: '#fff' ,
		            baseZ: 2000
		            } 
		       }); 
		       
	$.blockUI.defaults.baseZ = 4000;
}

function fun_endBlockUI(){
	$.unblockUI();
}


// ajax post send - No BlockUI
function fun_ajaxPostSendNoBlock(url, inputData, bAsync, callback) {
	//console.log("fun_ajaxPostSend " + url);
        
	$.ajax({
        type: 'POST'
        , url: url
        , async : bAsync
        , contentType: 'application/json; charset=utf-8'
        , data: JSON.stringify(inputData)
        , dataType: "json"
        , success: function (msg) {
            callback(msg);
        } // end success
        , error: function (xhr, status, error) {
        
        	fun_endBlockUI();
        
			if(xhr.status==403){
				alert("세션이 만료되었습니다");
				location.href='/admin/loginView.do';
			}
			console.log("xhr statusText :" + xhr.status + "xhr statusText :" + xhr.statusText + "xhr responseText :" + xhr.responseText + ", status : " + status + ", error : " + error);
			
			var msg = null;
			callback(msg);
			//alert('서비스가 일시적으로 원활하지 않습니다.');
			//history.go(-1);
        } // end error
    }); // end ajax
} // end fun_ajaxPostSend

// ajax post send
function fun_ajaxPostSend(url, inputData, bAsync, callback) {
	//console.log("fun_ajaxPostSend " + url);
	
	fun_startBlockUI();
        
	$.ajax({
        type: 'POST'
        , url: url
        , async : bAsync
        , contentType: 'application/json; charset=utf-8'
        , data: JSON.stringify(inputData)
        , dataType: "json"
        , success: function (msg) {
        	fun_endBlockUI();
            callback(msg);
        } // end success
        , error: function (xhr, status, error) {
        	fun_endBlockUI();
			if(xhr.status==403){
				alert("세션이 만료되었습니다");
				location.href='/admin/loginView.do';
			}
			console.log("xhr statusText :" + xhr.status + "xhr statusText :" + xhr.statusText + "xhr responseText :" + xhr.responseText + ", status : " + status + ", error : " + error);
			
			var msg = null;
			callback(msg);
			//alert('서비스가 일시적으로 원활하지 않습니다.');
			//history.go(-1);
        } // end error
    }); // end ajax
} // end fun_ajaxPostSend

function fun_ajaxSendOther(url, inputData, sendType, contentType, processData, dataType, asyncType, callback) {

	fun_startBlockUI();
	
	$.ajax({
          type        : sendType
        , url         : url
        , async       : asyncType // false
        , contentType : contentType
        , processData : processData // defaults : true
        , data        : inputData
        , dataType    : dataType
        , success     : function (msg) {
        	fun_endBlockUI()
            callback(msg);

        } // end success
        , error       : function (xhr, status, error) {
        	fun_endBlockUI()
        } // end error
    }); // end ajax
} // end fun_ajaxSendOther

// ajax post send
function fun_ajaxPostSendOther(url, inputData, sendType, contentType, processData, dataType, enctype, callback) {
	
	fun_startBlockUI();
	
	$.ajax({
        type: sendType
        , url: url
        , contentType: contentType
        , processData: processData
        , data: inputData
		//, dataType: dataType
		, enctype: enctype
        , success: function (msg) {
        	fun_endBlockUI()
            callback(msg);

        } // end success
        , error: function (xhr, status, error) {
        	fun_endBlockUI()
            console.log("xhr : " + xhr + "  , status : " + status + " , error : " + error);
        } // end error
    }); // end ajax
} // end fun_ajaxPostSendOther


// data Table add data
function fun_dataTableAddData(selector, resultMsg){
	var t = $(selector).dataTable();
	t.fnClearTable();

	if(typeof(resultMsg) !== "undefined" && resultMsg.length > 0) {
	    t.fnAddData(resultMsg);
	}

	t.fnAdjustColumnSizing(); // 컬럼 너비 리사이징
} // end fun_dataTableAddData

// cookie read
function readCookie(name){
	var searchName = name;
	var cookies = document.cookie.split(';');

	for(var i=0; i<cookies.length; i++){
		var c = cookies[i].split(' ').join('');

		var tmpC = c.split('=');

		if(tmpC[0] == searchName) {
			return tmpC[1];
		}
	}
	return null;
}

//cookie add
function addCookie(name, value, days) {
	var expires = "";
	if(days) {
		var date = new Date();
		date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		expires = ";expires=" + date.toGMTString();
	}

	document.cookie = name + "=" + value + expires + ";path=/";
}

//cookie del
function delCookie(name){
	addCookie(name, "", -1);
}

//다국어 list 조회
function fun_wordDictionaryList() {
	$.ajax({
		type: 'POST'
		, contentType: 'application/json; charset=utf-8'
		, url: "../assets/wordDictionaryList.json"
		, dataType: "json"
		, success: function(json) {
			wordDictionaryList = json.wordDictionaryList;
			fun_loadWordDictionaryData(json.wordDictionaryList, function(){
				var language = readCookie("language");
				if(language !== "kr") {
					fun_selectLanguage(language);
				}
			});
		}
	}); // end ajax
} // end fun_wordDictionaryList

function fun_loadWordDictionaryData(wordDictionary, callback){
	wordDictionaryList = wordDictionary;
	callback();
}

// 사용자 언어 선택
/**
 * 사용자 언어 선택
 *
 *
 * data-lang : 택스트를 변경한다.
 * img[data-img] : 이미지를 변경한다. 수정이 필요함...
 * data-class : css를 변경한다.
 *
 * @param changeLanguage
 * @returns
 */
function fun_selectLanguage(changeLanguage) {
	if(typeof(wordDictionaryList) === "undefined") {
		console.log("### wordDictionaryList undefined");
		return false;
	}

    delCookie('language');
    addCookie('language', changeLanguage, 365);

    $('[data-lang]').each(function() { // 화면 text list
        var $currentLanguageThis           = $(this);
        var currentLanguageText            = isNullChange($currentLanguageThis.html());
        var currentLanguageTextPlaceholder = isNullChange($currentLanguageThis.attr('placeholder'));
        var currentLanguageTexttitle       = isNullChange($currentLanguageThis.attr('title'));
        var currentLanguage                = $currentLanguageThis.data('lang');

        for(var i = 0; i < wordDictionaryList.length; i++) {
            // 확인이 좀필요하다.... 뭔가이상함.
        	//if(changeLanguage === currentLanguage) { // 선택한 언어가 같은 언어미면 변경 변환 중지
                //console.log("### break [" +  currentLanguageText +" / " + currentLanguageText2 + "]");

             //   return false;
            //}

            if(JSON.stringify(currentLanguageText) === JSON.stringify(wordDictionaryList[i][currentLanguage])) { // .html()로 불러온 내용변경
                $currentLanguageThis.html(wordDictionaryList[i][changeLanguage]);
                $currentLanguageThis.data('lang', changeLanguage);
            }

            if(JSON.stringify(currentLanguageTextPlaceholder) === JSON.stringify(wordDictionaryList[i][currentLanguage])) { // .attr('placeholder')로 불러온 내용 변경
                $currentLanguageThis.attr('placeholder', wordDictionaryList[i][changeLanguage]);
                $currentLanguageThis.data('lang', changeLanguage);
            }

            if(JSON.stringify(currentLanguageTexttitle) === JSON.stringify(wordDictionaryList[i][currentLanguage])) { // .attr('title')로 불러온 내용 변경
                $currentLanguageThis.attr('title', wordDictionaryList[i][changeLanguage]);
                $currentLanguageThis.data('lang', changeLanguage);
            }
        } // end for
    }); // end each

    $('img[data-img]').each(function() {
    	var $currentImgThis       = $(this);
    	var currentLanguageClass  = isNullChange($currentImgThis.attr('class'));
    	var currentLanguage       = $currentImgThis.data('img');

    	for(var i = 0; i < wordDictionaryList.length; i++) {
    		//if(changeLanguage === currentLanguage) { // 선택한 언어가 같은 언어미면 변경 변환 중지
    			//console.log("### break [" +  currentLanguageText +" / " + currentLanguageText2 + "]");

    		//	return false;
    		//}

    		if(JSON.stringify(currentLanguageClass) === JSON.stringify(wordDictionaryList[i][currentLanguage])) { // .html()로 불러온 내용변경
    			$currentImgThis.attr('class', wordDictionaryList[i][changeLanguage]);
    			$currentImgThis.data('img', changeLanguage);
    		}
    	} // end for
	}); // end each
	
	$('[data-radio]').each(function() {
    	var $currentLanguageThis       = $(this);
    	var currentLanguageHtml  = isNullChange($currentLanguageThis[0].nextSibling.data.replace(/\n/gi, '').replace(/\t/gi, '').replace(/\s/gi, ''));
		var currentLanguage                = $currentLanguageThis.data('radio');

    	for(var i = 0; i < wordDictionaryList.length; i++) {
    		//if(changeLanguage === currentLanguage) { // 선택한 언어가 같은 언어미면 변경 변환 중지
    			//console.log("### break [" +  currentLanguageText +" / " + currentLanguageText2 + "]");

    		//	return false;
    		//}

    		if(JSON.stringify(currentLanguageHtml) === JSON.stringify(wordDictionaryList[i][currentLanguage])) { // .html()로 불러온 내용변경
    			$currentLanguageThis[0].nextSibling.data = wordDictionaryList[i][changeLanguage];
    		}
    	} // end for
    }); // end each

    $('[data-class]').each(function() {
    	var $currentImgThis       = $(this);
    	var currentLanguageClass  = isNullChange($currentImgThis.attr('class'));
    	var currentLanguage       = $currentImgThis.data('class');

    	var temp_class = new Array();
    	temp_class = currentLanguageClass.split(' ');

    	for(var j = 0; j < temp_class.length; j++) {
    		for(var i = 0; i < wordDictionaryList.length; i++) {
    			//if(changeLanguage === currentLanguage) { // 선택한 언어가 같은 언어미면 변경 변환 중지
    			//console.log("### break [" +  currentLanguageText +" / " + currentLanguageText2 + "]");

    			//	return false;
    			//}

    			if(JSON.stringify(temp_class[j]) === JSON.stringify(wordDictionaryList[i][currentLanguage])) { // .html()로 불러온 내용변경
//    				$currentImgThis.attr('class', wordDictionaryList[i][changeLanguage]);
    				$currentImgThis.attr('class', currentLanguageClass.split(temp_class[j]).join(wordDictionaryList[i][changeLanguage]));
    				$currentImgThis.data('class', changeLanguage);
    			}
    		} // end for
    	}
    }); // end each
} // end fun_selectLanguage

// alert msg
function fun_alert(idValue) { // idValue CM0001 형식으로 사용해야함.
    var changeLanguage = $('[data-lang]').data("lang");

    var text = wordDictionaryList.filter(function(object) {
    	return object['id'] === idValue;
    });

    alert(text[0][changeLanguage]);
} // end fun_alert


// alert msg
/*
 * idValue : CM0001 형식으로 사용해야함.
 * values : var values = new Array();
 * values[0] = "값0";
 * values[1] = "값1"; 형식으로 사용해야함.
 * */
function fun_alert2(idValue, values) {
    var changeLanguage = $('[data-lang]').data("lang");

    var text = wordDictionaryList.filter(function(object) {
    	return object['id'] === idValue;
    });

    var retValues = text[0][changeLanguage];

    for(var i = 0; i < values.length; i++) {
    	retValues = retValues.split("[" + i + "]").join(values[i]);
    }

    alert(retValues);
} // end fun_alert

// confirm msg
function fun_confirm(idValue) { // idValue CM0001 형식으로 사용해야함.
    var changeLanguage = $('[data-lang]').data("lang");

    var text = wordDictionaryList.filter(function(object) {
    	return object['id'] === idValue;
    });

    return confirm(text[0][changeLanguage]);
} // end fun_alert


//text msg
function fun_text(idValue) { // idValue CM0001 형식으로 사용해야함.
    var changeLanguage = $('[data-lang]').data("lang");

    var text = wordDictionaryList.filter(function(object) {
        return object['id'] === idValue;
    });

    return text[0][changeLanguage];
} // end fun_text



function fun_initializingShare(){
	$("a[data-toggle='sns_share']").click(function(e){
		e.preventDefault();
		
		var _this = $(this);
		var sns_type = _this.attr('data-service');
		var href = $("#hdf_urlLink").val();
		var title = _this.attr('data-title');
		var loc = "";
		var img = $("meta[name='og:image']").attr('content');
		
		if( ! sns_type || !href || !title) return;
		
		if( sns_type == 'facebook' ) {
			loc = '//www.facebook.com/sharer/sharer.php?u='+href+'&t='+title;
		}
		else if ( sns_type == 'twitter' ) {
			loc = '//twitter.com/home?status='+encodeURIComponent(title)+' '+href;
		}
		else if ( sns_type == 'google' ) {
			loc = '//plus.google.com/share?url='+href;
		}
		else if ( sns_type == 'pinterest' ) {
			
			loc = '//www.pinterest.com/pin/create/button/?url='+href+'&media='+img+'&description='+encodeURIComponent(title);
		}
		else if ( sns_type == 'kakaostory') {
			loc = 'https://story.kakao.com/share?url='+encodeURIComponent(href);
		}
		else if ( sns_type == 'band' ) {
			loc = 'http://www.band.us/plugin/share?body='+encodeURIComponent(title)+'%0A'+encodeURIComponent(href);
		}
		else if ( sns_type == 'naver' ) {
			loc = "http://share.naver.com/web/shareView.nhn?url="+encodeURIComponent(href)+"&title="+encodeURIComponent(title);
		}
		else {
			return false;
		}
		
		window.open(loc);
		return false;
	});
}

function fun_copyTheLink(){
	$('#hdf_urlLink').select();
	document.execCommand("copy"); //클립보드 복사 실행
	alert('복사완료')
}


//=== 문자열 > Money 변환
function addCommas(nStr) {
	if (nStr == "" || nStr == "NaN" || nStr == null) {
		return "0";
	}
	else {
		nStr += '';
		x = nStr.split('.');
		x1 = x[0];
		x2 = x.length > 1 ? '.' + x[1] : '';
		var rgx = /(\d+)(\d{3})/;
		while (rgx.test(x1)) {
			x1 = x1.replace(rgx, '$1' + ',' + '$2');
		}
		return x1 + x2;
	}
}

//=== Money > 문자열 변환
function replaceComma(b) { // 콤마 변경
	var temp_len = String(b).length;
	var temp_str = "";
	var temp_return = "";
	for (i = 0; i < temp_len; i++) {
		temp_str = Mid(b, i, 1);
		temp_str = String(temp_str).replace(/^\$|,/, "");
		temp_return = temp_return + temp_str;
	}
	return parseInt(temp_return);
}

function mid(str, start, len) {
	// Make sure start and len are within proper bounds
	if (start < 0 || len < 0) return "";
	var iEnd, iLen = String(str).length;
	if (start + len > iLen)
		iEnd = iLen;
	else
		iEnd = start + len;
	return String(str).substring(start, iEnd);
}


// 비동기 로드 시 단 한건의 오류만 출력
var bLoadingError = false;
var loadingErrorCount = 0; 
function fun_loadingJustOneError(loadingObject){
	if(loadingErrorCount==0){
		if(bLoadingError){
			loadingErrorCount++
			console.log("loading Error : " + loadingObject);
			alert('서비스가 일시적으로 원활하지 않습니다.');
			history.go(-1);
		}
	}
}


function fun_getTextLength(str){
	var len = 0;
    for (var i = 0; i < str.length; i++) {
        if (escape(str.charAt(i)).length == 6) {
            len++;
        }
        len++;
    }
    return len;
}

//AES 암호화
function fun_encryptMdn(strMdn){
	var bytes = [];
	var windowIv = window.crypto.getRandomValues(new Uint8Array(16));
	for (var j=0; j<windowIv.length; ++j) {
		var code = windowIv[j];
			bytes = bytes.concat([code]);
	}
	var wordIv = byteArrayToWordArray(windowIv);
	var mdn = strMdn;
	var encryptMdn = CryptoJS.AES.encrypt(mdn, key, { iv: wordIv, mode: CryptoJS.mode.CBC, padding: CryptoJS.pad.Pkcs7 });
	//console.log('encrypted : ' + encryptMdn.toString() + ", iv : " + wordIv);
	var wordByte = wordArrayToByteArray(wordIv, wordIv.length);
	var iv = wordByte;

	var data = CryptoJS.AES.decrypt(encryptMdn, key, { iv: wordIv });
	//console.log('decrypted : ', hex2a(data.toString()) + ", iv : " + wordIv);

	mdn = encryptMdn.ciphertext.toString(CryptoJS.enc.Base64);
	return {"mdn":mdn, "iv":iv};
}

function jsonToExcel(wsData, fileName, columnCodeArray, wscols) {
	
	console.log("jsonToExcel");
    
    var curTime = fun_getToday().yyyy + "" + fun_getToday().mm + "" + fun_getToday().dd + "" + fun_getToday().hour + "" + fun_getToday().min + "" + fun_getToday().sec + "" + fun_getToday().mil;
    
    for (var i=0; i<wsData.length; i++){
    	
    	//console.log(i + "번째 엑셀");
    	
    	// workbook 생성
        var wb = XLSX.utils.book_new();

        // 문서 속성세팅 ( 윈도우에서 엑셀 오른쪽 클릭 속성 -> 자세히에 있는 값들
        // 필요 없으면 안써도 괜찮다.
        wb.Props = {
            Title: fileName,
            Subject: fileName,
            Author: "infovine",
            Company: "infovine",
            CreatedDate: new Date()
        };
        
    	// sheet명 생성 
        wb.SheetNames.push("sheet " + i);	
        // 배열 데이터로 시트 데이터 생성
//      var ws = XLSX.utils.aoa_to_sheet(wsData);
        var ws = XLSX.utils.json_to_sheet (wsData[i], {header: columnCodeArray});
//    	var ws2 = XLSX.utils.aoa_to_sheet(wsData2); 	//시트가 여러개인 경우
    
        ws["!cols"] = wscols;
        
        // 시트 데이터를 시트에 넣기 ( 시트 명이 없는 시트인경우 첫번째 시트에 데이터가 들어감 )
        wb.Sheets["sheet "+i] = ws;
//      wb.Sheets["sheet 2"] = ws2;	//시트가 여러개인 경우+
        
        
     	// 엑셀 파일 쓰기
        var wbout = XLSX.write(wb, {bookType:'xlsx',  type: 'binary'});
    	
        fun_endBlockUI();
        
        // 파일 다운로드
        saveAs(new Blob([s2ab(wbout)],{type:"application/octet-stream"}), fileName + '_' + curTime + '_' + i + '.xlsx');
    }

    fun_endBlockUI();

}

function s2ab(s) {
    var buf = new ArrayBuffer(s.length); //convert s to arrayBuffer
    var view = new Uint8Array(buf);  //create uint8array as viewer
    for (var i=0; i<s.length; i++) view[i] = s.charCodeAt(i) & 0xFF; //convert to octet
    return buf;
}
