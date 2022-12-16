/*
1.map 사용하기
var map = new c21.Map();
map.put("A", 1); map.get("A");

// map 데이터 꺼내기
for(var i in Object.keys(map.elements)){
	var key = Object.keys(map.elements)[i];
	var value = map.get(key);
	console.log("------1---"+key+"/"+value);
}
*/


var _mainUrl = "";
var ckuAwsUrl = "";

var _serverTime;
var _serverType = "admin";
var c21 = {
	popList : [],

    Map : function(obj) {
		if(typeof obj == 'object'){
			// this.elements = obj.elements;
			this.elements = {};
			this.length = obj.length;
			for ( var key in  obj.elements) {
				var value = this.elements[key];
				this.elements[key] =  obj.elements[key]
			}
		}else{
			this.elements = {};
			this.length = 0;
		}
	},

	init_map : function(){
		this.Map.prototype.put = function(key,value) {
		   this.length++;
		   this.elements[key] = value;
		}
		this.Map.prototype.get = function(key) {
		   return this.elements[key];
		}
		this.Map.prototype.size = function() {
			return this.length;
		}
		this.Map.prototype.containsKey = function(key) {
		      if(this.elements[key] == null){
		    	 return false;
		      }else{
		    	  return true;
		      }
		}
		this.Map.prototype.containsValue = function(value) {
			for ( var key in this.elements) {
				var value2 = this.elements[key];
				if(value == value2){
					return true;
				}
			}
			return false;
		}
		this.Map.prototype.remove = function(key) {
			if(this.elements[key] != null || typeof this.elements[key] == "undefined"){
				this.elements[key] = undefined;
		    }
		};
	},

	// 날짜 포맷 dt=2021/01/01, format=yyyy.MM.dd
	date_format : function(dt, format){
        var date = new Date(dt);
    	if (!date) {
    		return "";
    	}

        if (!format) {
            format = 'yyyy-MM-dd';
        }

        return format.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
            switch ($1) {
                case "yyyy": return date.getFullYear();
                case "yy": return date.getFullYear() % 1000 % 100;
                case "MM": return c21.date_zero(date.getMonth() + 1);
                case "dd": return c21.date_zero(date.getDate());
                case "E": return weekName[date.getDay()];
                case "HH": return c21.date_zero(date.getHours());
                case "hh": return c21.date_zero((h = date.getHours() % 12) ? h : 12);
                case "mm": return c21.date_zero(date.getMinutes());
                case "ss": return c21.date_zero(date.getSeconds());
                case "a/p": return date.getHours() < 12 ? "오전" : "오후";
                default: return $1;
            }
        });
    },

    date_format2 : function(dt, format){
    	var dt2 = dt.substring(0,4)+"/"+dt.substring(4,6)+"/"+dt.substring(6,8);
        var date = new Date(dt2);
    	if (!date) {
    		return "";
    	}

        if (!format) {
            format = 'yyyy-MM-dd';
        }

        return format.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
            switch ($1) {
                case "yyyy": return date.getFullYear();
                case "yy": return date.getFullYear() % 1000 % 100;
                case "MM": return c21.date_zero(date.getMonth() + 1);
                case "dd": return c21.date_zero(date.getDate());
                case "E": return weekName[date.getDay()];
                case "HH": return c21.date_zero(date.getHours());
                case "hh": return c21.date_zero((h = date.getHours() % 12) ? h : 12);
                case "mm": return c21.date_zero(date.getMinutes());
                case "ss": return c21.date_zero(date.getSeconds());
                case "a/p": return date.getHours() < 12 ? "오전" : "오후";
                default: return $1;
            }
        });
    },

    // 날짜에 공백 넣기
    date_zero : function (d, digits) {
	    if (digits == undefined) {
	      digits = 2;
	    }
	    var zero = "";
	    d = d.toString();
	    if (d.length < digits) {
	      for (var i = 0; i < digits - d.length; i++) {
	        zero += "0";
	      }
	    }
	    return zero + d;
    },

       // 현재 시간 가져오기  date_today("yyyyMMddhhmmss")
    date_today : function(format) {
        var d = new Date();
        var s =
            this.date_zero(d.getFullYear(), 4)+
            this.date_zero(d.getMonth() + 1, 2)+
            this.date_zero(d.getDate(), 2)+
            this.date_zero(d.getHours(), 2)+
            this.date_zero(d.getMinutes(), 2)+
            this.date_zero(d.getSeconds(), 2);
        if(format=="yyyy") s = s.substring(0, 4);
        if(format=="yyyyMM") s = s.substring(0, 6);
        if(format=="yyyyMMdd") s = s.substring(0, 8);
        if(format=="yyyy.MM.dd") s= s.substring(0,4)+"."+s.substring(4,6)+"."+s.substring(6,8);
        if(format=="yyyy-MM-dd") s= s.substring(0,4)+"-"+s.substring(4,6)+"-"+s.substring(6,8);
        if(format=="yyyyMMddhh") s= s.substring(0,10);
        if(format=="yyyyMMddhhmm") s= s.substring(0,12);
        if(format=="yyyyMMddhhmmss") s= s.substring(0,14);
        if(format=="yyyy-MM-dd hh:mm:ss") s= s.substring(0,4)+"-"+s.substring(4,6)+"-"+s.substring(6,8)+" "+s.substring(8,10)+":"+s.substring(10,12)+":"+s.substring(12,14);
        return s;
    },
    
    //이번주 월,화,수,목,금,토,일  월.일() 
    date_Week : function(format) {
         var currentDay = new Date();  
				var theYear = currentDay.getFullYear();
				var theMonth = currentDay.getMonth();
				var theDate  = currentDay.getDate();
				var theDayOfWeek = currentDay.getDay();
				 
				var s = [];
                 for(var i=1; i<8; i++) {
				  var resultDay = new Date(theYear, theMonth, theDate + (i - theDayOfWeek));
				  var yyyy = resultDay.getFullYear();
				  var mm = Number(resultDay.getMonth()) + 1;
				  var dd = resultDay.getDate();
				 
				  mm = String(mm).length === 1 ? '0' + mm : mm;
				  dd = String(dd).length === 1 ? '0' + dd : dd;
				 
				  s[i] = yyyy + '/' + mm + '/' + dd;
				}
				
        return s;
    },

       // 날짜 전체 기본 정보  defineDate="20210101"
   	date_total : function(defineDate){
		var year = defineDate.substring(0,4);
		var month = defineDate.substring(4,6);
		var	day = defineDate.substring(6,8);
		var	date = new Date(year+"-"+month+"-"+day);
   		var obj = {};
   		if (('' + month).length == 1) { month = '0' + month; }
   		if (('' + day).length   == 1) { day   = '0' + day;   }
   		obj.year = year;
   		obj.month = month;
   		obj.day = day;
   		obj.yyyymm =obj.year+""+obj.month;
   		obj.yyyymmdd =obj.year+""+obj.month+""+obj.day;
   		obj.yyyymmdd2 = obj.year+"-"+obj.month+"-"+obj.day;
   		obj.yyyymmdd3 = obj.year+"."+obj.month+"."+obj.day;
   		obj.yyyymmdd4 = obj.year+"/"+obj.month+"/"+obj.day;
   		obj.date = date;
   		var idx = new Date(obj.year+'-'+obj.month+'-'+obj.day).getDay();
   		var week = ['일', '월', '화', '수', '목', '금', '토'];
   		obj.week = week[idx];
   		obj.idx = idx;									// 일요일 0부터 시작하여 날짜에 해당하는 순번째
   		var currentMonth = new Date(year,month,0);
   		obj.dayTot = currentMonth.getDate();			// 한달 총 일수
   		var beforeMonth = new Date(year, (month-1), 1);
   		obj.startIdx = beforeMonth.getDay();
   		obj.startWeek = week[obj.startIdx];

   		var dowOffset = 0;
   		var newYear = new Date(date.getFullYear(),0,1);
   		var day = newYear.getDay() - dowOffset;
   		day = (day >= 0 ? day : day + 7);
   		var daynum = Math.floor((date.getTime() - newYear.getTime() - (date.getTimezoneOffset()-newYear.getTimezoneOffset())*60000)/86400000) + 1;
   		var weeknum;
   		if(day < 4) {
   		  weeknum = Math.floor((daynum+day-1)/7) + 1;
   		  if(weeknum > 52) {
   		    let nYear = new Date(date.getFullYear() + 1,0,1);
   		    let nday = nYear.getDay() - dowOffset;
   		    nday = nday >= 0 ? nday : nday + 7;
   		    weeknum = nday < 4 ? 1 : 53;
   		  }
   		}
   		else {
   		  weeknum = Math.floor((daynum+day-1)/7);
   		}
   		obj.weekCnt = weeknum;
   		return obj;
   	},


   	// 일 더하기 빼기
   	date_addDay: function(num, type, defineDate){
   		var defineDate = defineDate.replace(/-/gi, "");
		var year = defineDate.substring(0,4);
		var month = defineDate.substring(4,6);
		var	day = defineDate.substring(6,8);
		var	date = new Date(year+"-"+month+"-"+day);
   		date.setDate(date.getDate() + num);
   		var year  = date.getFullYear();
   		var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
   		var day   = date.getDate();
   		if (('' + month).length == 1) { month = '0' + month; }
   		if (('' + day).length   == 1) { day   = '0' + day;   }
   		if(type =="yyyy-MM-dd") return year+'-'+month+'-'+day;
   		if(type == "yyyy.MM.dd") return year+'.'+month+'.'+day;
   		return year+''+month+''+day;
   	},

   	// 월 더하기 빼기
   	date_addMonth: function(num, type, dt){
   		var defineDate = dt.replace(/-/gi, ""); defineDate = dt.replace(/\./gi, "");
		var year = defineDate.substring(0,4);
		var month = defineDate.substring(4,6);
		var	day = defineDate.substring(6,8);
		var	date = new Date(year+"-"+month+"-"+day);
   		date.setMonth(date.getMonth() + num);
   		var year  = date.getFullYear();
   		var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
   		var day   = date.getDate();
   		if (('' + month).length == 1) { month = '0' + month; }
   		if (('' + day).length   == 1) { day   = '0' + day;   }
   		if(type =="yyyy-MM-dd") return year+'-'+month+'-'+day;
   		if(type == "yyyy.MM.dd") return year+'.'+month+'.'+day;
   		return year+''+month+''+day;
   	},

   	// 날짜 차이  c21.diffDay("20210101", "20210401");
   	date_diffDay: function(sDate, eDate){
   		sDate = sDate.replace(/-/gi, ""); sDate = sDate.replace(/\./gi, "");
   		eDate = eDate.replace(/-/gi, ""); eDate = eDate.replace(/\./gi, "");
   		var sDate1 = sDate.substring(0, 4);
   		var sDate2 = sDate.substring(4, 6);
   		var sDate3 = sDate.substring(6, 8);
   		eDate = eDate+'';
   		var eDate1 = eDate.substring(0, 4);
   		var eDate2 = eDate.substring(4, 6);
   		var eDate3 = eDate.substring(6, 8);
   		var sDate2 = new Date(sDate1, sDate2, sDate3) ;
   		var eDate2 = new Date(eDate1, eDate2, eDate3) ;
   		var diffDay = eDate2.getTime() - sDate2.getTime() ;
   		var diff = diffDay / (1000*60*60*24) ;
   		return diff;
   	},

   	// 한주의 시작과 종료 날짜들
   	date_weekDay: function(dt){
   		dt = dt.replace(/-/gi, ""); dt = dt.replace(/\./gi, "");
   		var checkDate = dt.replace(/-/gi, "");
   		var obj = {};
  		var a = this.date_total(checkDate);
  		var week = a.week;
  		var idx = a.idx;
  		var idx2 = 0-idx;
  		var dateArr = [];
  		dateArr[0] = common_date.addDay(idx2, 	'', checkDate);
  		dateArr[1] = common_date.addDay(idx2+1, '', checkDate);
  		dateArr[2] = common_date.addDay(idx2+2, '', checkDate);
  		dateArr[3] = common_date.addDay(idx2+3, '', checkDate);
  		dateArr[4] = common_date.addDay(idx2+4, '', checkDate);
  		dateArr[5] = common_date.addDay(idx2+5, '', checkDate);
  		dateArr[6] = common_date.addDay(idx2+6, '', checkDate);
  		return dateArr;
   	},

   	// 경력 구하기
   	date_workText : function(cnt){
   		 var text = "";
   		 if(cnt > 0){
		      var year = parseInt(cnt/365);
		      var month = parseInt( (cnt-year*365)/30);
		      var day = cnt-(year*365+month*30);
		      if(year > 0) text += year+"년";
		      if(month > 0) text += " "+month+"개월";
		  }else{
		  	text = "0년 0개월";
		  }
		  return text;
   	},

   	// 현재부터 경력 구하기
   	date_workText_today : function(startDt){
   		  var today = c21.date_today("yyyyMMdd");
   		  var cnt = c21.date_diffDay(startDt, today);
   		  var text = "";
   		  if(cnt > 0){
   		  	var year = parseInt(cnt/365);
		      var month = parseInt( (cnt-year*365)/30);
		      var day = cnt-(year*365+month*30);
		      if(year > 0) text += year+"년";
		      if(month > 0) text += " "+month+"개월";
   		  }else{
   		  	text = "0년 0개월";
   		  }
		  return text;
   	},

    // 화폐, 숫자, 적용
    set_limit : function(s){
    	// 숫자만 입력 input=text 의 태그안에 nuberOnly 넣으면 된다.
		$("input:text[numberOnly]").on("keyup", function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		});

    	// 화폐단위 찍기
		$("input:text[won]").on("keyup", function() {
			$(this).val(c21.set_addComma($(this).val().replace(/[^0-9]/g,"")));
		});

		// 최대 max값 제한
		$("input:text[maxNumber]").on("keyup", function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
			var v = Number($(this).val());
			var max = Number($(this).attr("max"));
			if(v > max){
				$(this).val("0");
			}else{
				$(this).val(v);
			}
		});

		// 기본값 0 세팅
		$("input:text[zeroNumber]").on("keyup", function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
			var v = Number($(this).val());
			var max = Number($(this).attr("max"));
			if($(this).val()==""){
				$(this).val("0");
			}
		});

		// 이름은 한글과 영문만 입력
		$("input:text[nmCheck]").on("keyup", function() {
			$(this).val($(this).val().replace(/[^ㄱ-힣a-zA-Z]/gi, ''));
		});

		// 공백제거
		$("input:text[noBlank]").on("keyup", function() {
			$(this).val($(this).val().replace(/ /gi, ''));
		});

		// 아이디는 영문, 숫자
		$("input:text[idCheck]").on("keyup", function() {
			$(this).val($(this).val().replace(/[^a-z0-9]/gi,""));
		});

		// 비밀번호 입력에 공백방지
		$("input:password[pwCheck]").on("keyup", function() {
			$(this).val($(this).val().replace(/ /gi, ''));
		});
	},

	// 화폐 , 찍기 (e 은 ojbect로 넘어온 경우)
	set_addComma : function(e){
		if(isNaN(e)){
			var num = $(e).val();
			var len, point, str;
		    num = num + "";
		    num = num.replace(/\,/gi, '');
		    point = num.length % 3 ;
		    len = num.length;
		    str = num.substring(0, point);
		    while (point < len) {
		        if (str != "") str += ",";
		        str += num.substring(point, point + 3);
		        point += 3;
		    }
			$(e).val(str);

		}else{
			var num = Math.abs(e);
			var len, point, str;
		    num = num + "";
		    num = num.replace(/\,/gi, '');
		    point = num.length % 3 ;
		    len = num.length;
		    str = num.substring(0, point);
		    while (point < len) {
		        if (str != "") str += ",";
		        str += num.substring(point, point + 3);
		        point += 3;
		    }
		    if(Number(e) < 0 ) str = "-"+str;
			return str;
		}
	},

	// 화폐 콤마 지우기
	set_removeComma : function(num){
		return  num = num.replace(/\,/gi, '');
	},

	// 특수문자 제거하기
	set_rm : function(data){
        var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-+<>@\#$%&\\\=\(\'\"]/gi;
        if(regExp.test(data)){
            data = data.replace(regExp, "");
        }
        return data
    },

    // uuid 만들기
    set_uuid : function(){
    	function s4() {
            return ((1 + Math.random()) * 0x10000 | 0).toString(16).substring(1);
        }
        var time = c21.date_today("yyyyMMddhhmmss");
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()+"-"+time;
    },

    // jquery datepicker 사용하기
    set_datepicker : function(){
    	$(".form-datepicker").datepicker({
    			inline: true,
				showOtherMonths: true,
				showMonthAfterYear: true,
				// buttonImage: "http://"+location.host+"/admin/images/calender.png",
				monthNames: [ '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12' ],
				dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
				dateFormat: 'yy-mm-dd'
		});
    },

    // 자바스크립트 unll, undefined 체크하기
    set_isEmpty : function(str){
        if(typeof str == "undefined" || str == null || str == "")
            return true;
        else
            return false ;
    },

   	// null 인경우 대체문자 사용하기
    set_nvl : function(str, defaultStr){
        if(typeof str == "undefined" || str == null || str == "")
            str = defaultStr ;
        return str ;
    },

	// 다음 지도 외부 api  api_zipAddress(callack)
	/*
		<script type="text/JavaScript" src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
 	 	<script type="text/JavaScript" src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
	*/
	api_zipAddress : function(callback) {
        new daum.Postcode({
            oncomplete:function(data) {
                if(typeof callback =="function"){
                    callback(data);
                }
            }
        }).open();
    },

	//  자바스크립트에서만 파일 업로드 처리하기 <input type="file" onchange="c21.file_uploae_script(this, callback)";/>
	file_uploadScript : function(th, callback){
        var id = $(th).attr("id");
        var name = $(th).attr("name");
        var fileIdx = $(th).attr("fileIdx");
        var fileName = "";
        if(window.FileReader){ // modern browser
            filename = $(th)[0].files[0].name;
        } else { // old IE
            filename = $(th).val().split('/').pop().split('\\').pop(); // 파일명만 추출
        }
        var maxSize  = 50 * 1024 * 1024                                 //50MB
        var fileSize = 0;
        var browser=navigator.appName;
        if (browser=="Microsoft Internet Explorer"){                    // 익스플로러일 경우
            var oas = new ActiveXObject("Scripting.FileSystemObject");
            fileSize = oas.getFile( $(th).val()).size;
        }else{
            fileSize = $(th)[0].files[0].size;                          // 익스플로러가 아닐경우
        }
        var kSize = fileSize/1024;
        var fileSize = parseInt(kSize);
        fileSize = addCommas(fileSize);                                 // 3자리 마다 콤마 찍기
        var obj = {};
        obj.id = id;
        obj.name = name;
        obj.fileSize = fileSize;
        obj.fileNm = filename;
        obj.fileIdx = fileIdx;
        callback(obj);
	},

	// 파일 업로드 전체 체크하기
	file_check : function(th, fileType){
       var name = "";
		if(window.FileReader){ // modern browser
            name = $(th)[0].files[0].name;
        } else { // old IE
            name = $(th).val().split('/').pop().split('\\').pop(); // 파일명만 추출
        }

		var ext = name.split('.').pop().toLowerCase();
		var fileArr = ['png','jpg','jpeg', 'gif', 'pdf', 'xls', 'xlsx', 'txt', 'doc', 'docx', 'ppt', 'pptx', 'zip', 'hwp', 'avi', 'mp4', 'm4v', 'wmv', 'mkv', 'mov', 'bz2'];
		if(fileType == "img"){
			fileArr = ['png','jpg','jpeg', 'gif'];
			if(fileArr.indexOf(ext) == -1) {
				alert("이미지 파일을 업로드 해 주세요.");
				return false;
			}

		}else if(fileType == "txt"){
			fileArr = ['pdf', 'xls', 'xlsx', 'txt', 'doc', 'docx', 'ppt', 'pptx', 'hwp'];
			if(fileArr.indexOf(ext) == -1) {
				alert("문서 파일을 업로드 해 주세요.");
				return false;
			}

		}else if(fileType == "imgTxt"){
			fileArr = ['png','jpg','jpeg', 'gif', 'pdf', 'xls', 'xlsx', 'txt', 'doc', 'docx', 'ppt', 'pptx', 'hwp'];
			if(fileArr.indexOf(ext) == -1) {
				alert("문서 파일을 업로드 해 주세요.");
				return false;
			}
			fileType = "file";

		}else if(fileType == "zip"){
			if(fileType != ext) {
				alert("파일 형식을 확인해 주세요.");
				return false;
			}
		}else if(fileType == "video"){
			fileArr = ['avi','mp4','m4v','wmv','mkv','mov'];
			if(fileArr.indexOf(ext) == -1) {
				alert("영상 파일을 업로드 해 주세요.");
				return false;
			}

		}else{
			if(fileArr.indexOf(ext) == -1) {
				alert("업로드 불가 파일입니다.");
				return false;
			}
		}

        var maxSize  = 100 * 1024 * 1024 * 1024 ;                        //50MB
        var fileSize = $(th)[0].files[0].size;
        var browser=navigator.appName;

        if (browser=="Microsoft Internet Explorer"){                    // 익스플로러일 경우
            var oas = new ActiveXObject("Scripting.FileSystemObject");
            fileSize = oas.getFile( $(th).val()).size;
        }else{
            fileSize = $(th)[0].files[0].size;                          // 익스플로러가 아닐경우
        }
        if(fileSize>maxSize){
        	alert("업로드 사이트는 1G 이하입니다.");
        	return false;
        }
        $(th).next().html(name);
       	return true;
	},

	// 파일 업로드 btn 형식으로 클릭한 경우  onclick="c21.file_click(this, event);"
	file_click : function(th, e){
		e.preventDefault();
		$(th).closest("file").find("input[name=fileUpload]").click();
	},

	/*  파일업로드
		<input type="file" multiple onchange="c21.file_upload('file', this, callback);" name="fileUpload" style="display:none"/>
		saveType : 파일 업로드 가능한것 (img:이미지, txt:텍스트, file:전체)
	*/
	file_upload : function(th, callback, fileType, pageType){
		var v = $(th).val();
		if(v==""){
			alert("파일을 업로드 해주세요.");
			return false;
		}
		var name = "";
		try{
			if(window.FileReader){ // modern browser
	            name = $(th)[0].files[0].name;
	        } else { // old IE
	            name = $(th).val().split('/').pop().split('\\').pop(); // 파일명만 추출
	        }
	    }catch(e){
	    	return false;
	    }

		var ext = name.split('.').pop().toLowerCase();
		var fileArr = ['png','jpg','jpeg', 'gif', 'pdf', 'xls', 'xlsx', 'txt', 'doc', 'docx', 'ppt', 'pptx', 'zip', 'hwp', 'avi', 'mp4', 'm4v', 'wmv', 'mkv', 'mov', 'bz2'];
		if(fileType == "img"){
			fileArr = ['png','jpg','jpeg', 'gif'];
			if(fileArr.indexOf(ext) == -1) {
				alert("이미지 파일을 업로드 해 주세요.");
				return false;
			}

		}else if(fileType == "txt"){
			fileArr = ['pdf', 'xls', 'xlsx', 'txt', 'doc', 'docx', 'ppt', 'pptx', 'hwp'];
			if(fileArr.indexOf(ext) == -1) {
				alert("문서 파일을 업로드 해 주세요.");
				return false;
			}

		}else if(fileType == "imgTxt"){
			fileArr = ['png','jpg','jpeg', 'gif', 'pdf', 'xls', 'xlsx', 'txt', 'doc', 'docx', 'ppt', 'pptx', 'hwp'];
			if(fileArr.indexOf(ext) == -1) {
				alert("문서 파일을 업로드 해 주세요.");
				return false;
			}
			fileType = "file";

		}else if(fileType == "zip"){
			if(fileType != ext) {
				alert("파일 형식을 확인해 주세요.");
				return false;
			}
		}else if(fileType == "video"){
			fileArr = ['avi','mp4','m4v','wmv','mkv','mov'];
			if(fileArr.indexOf(ext) == -1) {
				alert("영상 파일을 업로드 해 주세요.");
				return false;
			}

		}else{
			if(fileArr.indexOf(ext) == -1) {
				alert("업로드 불가 파일입니다.");
				return false;
			}
		}

	    try {
	      var formData = new FormData();
	      formData.append("uploadfile", $(th)[0].files[0]);
	      formData.append("fileType", fileType);  // 저장할 파일 성격 (이미지, 문서, 전체파일)
	      formData.append("pageType", pageType);  // 기본 경로에 추가적인 부분

	      var changeFileNm = $("input[name=changeFileNm]").val();
		  if(typeof changeFileNm !="undefined" && changeFileNm!="" && changeFileNm != null && changeFileNm.length > 0){
			  formData.append("changeFileNm", changeFileNm);
		  }else{
		     formData.append("changeFileNm", "");
		  }

		  /*
			  // formdata 내용보기
			  for (var key of formData.keys()) {
				  console.log(key);
			  }
			  for (var value of formData.values()) {
				 console.log(value);
			  }
		  */

	      var _fileCallback = function (data) {
				$(th).val("");

		      	// console.log(data);

		      	if(data.result){
					callback(th, data, pageType);
		      	}else{
		      		alert(data.message);
		      		$(".modal").modal("hide");
		      	}
	      };
	      this.file_submit(formData, _fileCallback);
	    } catch (e) {	}
	},

	// 파일 삭제하기 <file_del></file_del> 태그로 감싸야 한다.
	file_remove : function(th, parentId){
		$(th).closest("file_del").remove();
		$(th).closest(".file_del").remove();
		if(typeof parentId !="undefined" && parentId !="") $("#"+parentId).find(".addImg").css("display", "");
	},

	// 파일 서버로 전송하기
	file_submit : function(formData, callback) {
        $.ajax({
            url: _mainUrl+"/common/file/upload",
            enctype: 'multipart/form-data',
            processData: false,
            contentType: false,
            data: formData,
            type: 'POST',
            // async : false,
            success: function(response){
                callback(response);
            }
        });
	},

	// 서버에서 파일 다운로드 (이름과 저장이름으로)
	file_download : function(fileNm, fileSaveNm, pageType){
			var form = document.createElement("form");
			form.setAttribute("method", "post");
			form.setAttribute("action", _mainUrl+"/common/file/download");
			var input = document.createElement('input');
				input.type = 'hidden'; 	input.name = "fileNm";	input.value = fileNm;	form.appendChild(input);
				input = document.createElement('input');
				input.type = 'hidden'; 	input.name = "fileSaveNm";	input.value = fileSaveNm;	form.appendChild(input);
				input = document.createElement('input');
				input.type = 'hidden'; 	input.name = "pageType";	input.value = pageType;	form.appendChild(input);
			document.body.appendChild(form);
			form.submit();
			document.body.removeChild(form);
	},

	// 파일 uuid와 subSeq로 다운로드
	file_download_uuid : function(fileUuid, fileSubSeq, pageType){
			var form = document.createElement("form");
			form.setAttribute("method", "post");
			form.setAttribute("action", "/common/file/download");
			var input = document.createElement('input');
				input.type = 'hidden'; 	input.name = "fileUuid";	input.value = fileUuid;	 form.appendChild(input);
				input = document.createElement('input');
				input.type = 'hidden'; 	input.name = "fileSubSeq";	input.value = fileSubSeq;	form.appendChild(input);
				input = document.createElement('input');
				input.type = 'hidden'; 	input.name = "pageType";	input.value = pageType;	form.appendChild(input);
			document.body.appendChild(form);
			form.submit();
			document.body.removeChild(form);
	},

	// 파라미터 체크하기 구현로직 필요함
	params_check : function(type, checkVal1, checkVal2){
	      var txt = "";
	      var reg = "";
	      if(type == "id") 	{	txt = "아이디"; 		reg = /^[a-z]+[a-z0-9]{5,20}$/g;}
	      if(type == "pw") 	{	txt = "비밀번호"; 		reg = /^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,20}$/;}
	      if(type == "phone") {	txt = "휴대폰번호"; 	reg = /^((01[1|6|7|8|9])[0-9]+[0-9]{6,7})|(010[0-9][0-9]{7})$/;}
	      if(type == "email") {	txt = "이메일"; 		reg = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;}
		  if(type == "emailId") {	txt = "아이디(이메일)"; 		reg = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;}
	      if(type == "company") { txt = "사업자등록번호"; reg =""}

		  if(type == "university_emailId") {	txt = "ID(이메일)"; 		reg = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;}
		  if(type == "university_phone") {	txt = "연락처"; 	reg = /^(01[0|1|6|7|8|9])([0-9]{3,4})([0-9]{4})$/;}
		  if(type == "university_tel") {	txt = "연락처"; 	reg = /^(02|0[3-9]{1}[0-9]{1})([0-9]{3,4})([0-9]{4})$/;}
		  if(type == "university_fax") {	txt = "팩스 번호"; 	reg = /^(02|0[3-9]{1}[0-9]{1})([0-9]{3,4})([0-9]{4})$/;}
		  if(type == "university_pw") {	txt = "비밀번호"; 	reg = /^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[~`!@#$%^&*()-]).{8,12}$/;}

	      if(checkVal1 == ""){
	        alert(txt + "을(를) 입력하세요.");
	        return false;
	      }
	      var blank_pattern = /[\s]/g;
	      if(blank_pattern.test(checkVal1) == true){
		      alert(txt + '에 공백은 입력하실 수 없습니다.');
		      return false;
		    }
	      if(type == "id" && !isNaN(parseInt(checkVal1.charAt(0)))){
				alert("아이디 첫 번째 문자는 영어 소문자만 입력 가능합니다.");
				return false;
		  }

		  if(type !="company"){
		      if(false === reg.test(checkVal1)) {
		        var msg = txt + " 형식을 확인해 주세요.";
		        if(type == "id") msg = msg+"\n아이디는 영문 소문자, 숫자만 사용하여\n6자리 이상 20자리 이하로 입력해 주세요.";
		        if(type == "pw") msg = msg+"\n영문 소/대, 숫자, 특수문자를 조합하여\n6자이상 20자 이하로 비밀번호를 입력해 주세요.";
				if (type == "cku_pw") msg = msg + "\n(8~12자 영문, 숫자, 특수문자(~`!@#$%^&*()-) 포함 사용)";
			    	alert(msg);
			    	return false;
			  }
		 }

		 if(type == "id"){// id 체크
	        var idArr = ["admin", "root", "aes", "AES"];
	        var checkSuc = true;
		      for(var i=0; i<idArr.length; i++){
		      	var v = idArr[i];
		      	if(checkVal1.indexOf(v) > -1){
		      		checkSuc = false;
			      }
		      }
		      if(!checkSuc){
		      	alert('부적절한 ID 유형 입니다.');
		        return false;
		      }

	      }else if(type == "pw"){// 비밀번호 체크
	        	var checkPwd = checkVal2;

				var alpaBig= "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			    var alpaSmall= "abcdefghijklmnopqrstuvwxyz";
			    var keyboard1= "qwertyuiop asdfghjkl asdfghjkl";
			    var keyboard2= "QWERTYUIOP ASDFGHJKL ZXCVBNM";
			    var num = "01234567890";
		      	// var hanReg = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
		      	if(/(\w)\1\1/.test(checkVal1)){
		        	alert("3자 이상 동일한 연속된 문자 사용이 불가능 합니다.");
		        	return false;
		      	}
		      	var checkSuc = true;
		        /*
		        // id, pwd 중복 글자 방지
		        var len = id.length;
			      for(var i=0;i<len-3; i++){
			      	var v = id.substring(i, i+3);
			      	if(pw.indexOf(v) > -1){
			      		checkSuc = false;
			      	}
			      }
		        */
	        if(checkVal1 != checkPwd){
	          alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
	          return false;
	        }
		      for(var i=0;i<alpaBig.length-3;i++){
		      	var v = alpaBig.substring(i, i+3);
		      	if(checkVal1.indexOf(v) > -1){
		      		alert("ABC 처럼 연속 문자 사용 불가합니다. ");
			        return false;
		      	}
		      }
		      for(var i=0;i<alpaSmall.length-3;i++){
		      	var v = alpaSmall.substring(i, i+3);
		      	if(checkVal1.indexOf(v) > -1){
		      		alert("abc 처럼 연속 문자 사용 불가합니다. ");
			        return false;
		      	}
		      }
		      for(var i=0;i<num.length-3;i++){
		      	var v = num.substring(i, i+3);
		      	if(checkVal1.indexOf(v) > -1){
		      		alert("123 처럼 연속 숫자 사용 불가합니다. ");
			        return false;
		      	}
		      }
		      for(var i=0;i<keyboard1.length-3;i++){
		      	var v = keyboard1.substring(i, i+3);
		      	if(checkVal1.indexOf(v) > -1){
		      		alert("qwe, asd, zxc 처럼 키보드 연속 사용 불가합니다. ");
			        return false;
		      	}
		      }
		      for(var i=0;i<keyboard2.length-3;i++){
		      	var v = keyboard2.substring(i, i+3);
		      	if(checkVal1.indexOf(v) > -1){
		      		alert("QWE, ASD, ZXC 처럼 키보드 연속 사용 불가합니다. ");
			        return false;
		      	}
		      }

	      }else if(type=="company"){
		      	// 넘어온 값의 정수만 추츨하여 문자열의 배열로 만들고 10자리 숫자인지 확인합니다.
		      	var bisNo = checkVal1;
				if ((bisNo = (bisNo+'').match(/\d{1}/g)).length != 10) {
					alert("올바른 사업자 번호가 아닙니다");
					return false;
				}
				/*
				// 합 / 체크키
				var sum = 0, key = [1, 3, 7, 1, 3, 7, 1, 3, 5];

				// 0 ~ 8 까지 9개의 숫자를 체크키와 곱하여 합에더합니다.
				for (var i = 0 ; i < 9 ; i++) { sum += (key[i] * Number(bisNo[i])); }

				// 각 8번배열의 값을 곱한 후 10으로 나누고 내림하여 기존 합에 더합니다.
				// 다시 10의 나머지를 구한후 그 값을 10에서 빼면 이것이 검증번호 이며 기존 검증번호와 비교하면됩니다.
				var checkNo =  (10 - ((sum + Math.floor(key[8] * Number(bisNo[8]) / 10)) % 10)) == Number(bisNo[9]);
				if(checkNo ==1){
					return true;
				}else{
					alert("올바른 사업자 번호가 아닙니다");
					return false;
				}
				*/
	      }

		  if (type == "cku_pw") {
			if (checkVal2 == "") {
				alert("비밀번호 확인을 입력해 주세요.");
				return false;
			}

			if (checkVal1 != checkVal2) {
				alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
				return false;
			}
		  }
	      return true;
    },

	// 전체 파라미터 값 가져오기 (groupId : 전체를 감싸는 id)
    params_data : function(groupId){
        var params = {};
        $("#"+groupId).find("input").each(function (e) {
          var name = $(this).attr("name");

          // var checkList = $(this).attr("required");
          // requrired="email,number,null";
          // var checkResult = this.params_check(chekList);

          if (typeof name=="undefined" || name=="" || name == "undefined" || name=="null") {
                return true;
          }
          var type = $(this).attr("type");
          var nmArr = name.split("_");
          var name2 = nmArr[nmArr.length-1];
          if (type == "text" || type == "hidden" || type == "password") {
				var len = $("#"+groupId).find('input[name="'+name+'"]').length;
				if(len > 1){
					var pArr = [];
					$("#"+groupId).find('input[name="'+name+'"]').each(function() {
					    pArr.push($(this).val());
					});
					params[name2] = JSON.stringify(pArr);
				}else{
		            var a = $(this).val();
		            if(typeof a =="undefined") a ="";
		            params[name2] = a;
		            if (name2.indexOf("Dt") > 0 ) {
		                params[name2] = $(this).val().replace(/\./gi, "");
		            }
		        }
          } else if (type == "radio") {
	            var r = $("#"+groupId).find("input:radio[name=" + name + "]:checked").val();
	            if(typeof r=="undefined") r ="";
	            params[name2] = r;
          } else if (type == "checkbox") {
	            var totCheckVal = "";
	            $("#"+groupId).find("input:checkbox[name=" + name + "]:checked").each(function () {
	              var checkVal = $(this).val();
	              totCheckVal += checkVal + ":";
	            });
	            if(totCheckVal==":") totCheckVal="";
	            params[name2] = totCheckVal;
          }
        });

        $("#"+groupId).find("select").each(function (e) {
            var name = $(this).attr("name");
            if (typeof name=="undefined" || name=="" || name == "undefined" || name=="null") {
                return true;
            }
            var nmArr = name.split("_");
            var name2 = nmArr[nmArr.length-1];
            var a = $(this).val();
            if(typeof a =="undefined") a ="";
            params[name2] = a;
        });

        $("#"+groupId).find("textarea").each(function (e) {
            var name = $(this).attr("name");
            if (typeof name=="undefined" || name=="" || name == "undefined" || name=="null") {
                return true;
            }
            var len = $("#"+groupId).find('textarea[name="'+name+'"]').length;
			if(len > 1){
				var pArr = [];
				$("#"+groupId).find('textarea[name="'+name+'"]').each(function() {
				    pArr.push($(this).val());
				});
				params[name2] = JSON.stringify(pArr);
			}
            var nmArr = name.split("_");
            var name2 = nmArr[nmArr.length-1];
            var a = $(this).val();
            if(typeof a =="undefined") a ="";
            params[name2] = a;
        });
        return params;
     },

     // json Ojbect으로 key, value 값 가져오기 len은 json처리 개수
     params_json : function(groupId){
		var jsonData = [] ;
		var size = $("."+groupId).length;
		for(var i=0; i<size; i++){
		    var params = {};
	        $("."+groupId).eq(i).find("input").each(function (e) {
		          var name = $(this).attr("name");
		          if (typeof name == "undefined" || name=="" || name==null) {
		            	return true;  // for문 건너 띄기
		          }
		          var type = $(this).attr("type");
		          var nmArr = name.split("_");
		          var name2 = nmArr[nmArr.length-1];
		          if (type == "text" || type == "hidden" || type == "password") {
						var len = $("."+groupId).eq(i).find('input[name^="'+name+'"]').length;
						if(len > 1){
							var pArr = [];
							$("."+groupId).eq(i).find('input[name^="'+name+'"]').each(function() {
							    pArr.push($(this).val());
							});
							params[name2] = JSON.stringify(pArr);
						}else{
				            var a = $(this).val();
				            if(typeof a =="undefined") a ="";
				            params[name2] = a;
				            if (name2.indexOf("Dt") > 0 ) {
				                params[name2] = $(this).val().replace(/\./gi, "");
				            }
				        }
		          } else if (type == "radio") {
			            var r = $("."+groupId).eq(i).find("input:radio[name=" + name + "]:checked").val();
			            if(typeof r=="undefined") r ="";
			            params[name2] = r;
		          } else if (type == "checkbox") {
						if (name2.indexOf("Yn") == -1) {
							var totCheckVal = "";
							$("."+groupId).eq(i).find("input:checkbox[name=" + name + "]:checked").each(function () {
								var checkVal = $(this).val();
								totCheckVal += checkVal + ":";
							});
							if(totCheckVal==":") totCheckVal="";
							params[name2] = totCheckVal;
						} else if (name2.indexOf("Yn") != -1) {
							var totCheckVal = "";
							$("."+groupId).eq(i).find("input:checkbox[name=" + name + "]").each(function () {
								totCheckVal += $(this).is(":checked") ? "Y:" : "N:";
							});
							params[name2] = totCheckVal;
						}

		          }
	        });

	        $("."+groupId).eq(i).find("select").each(function (e) {
	            var name = $(this).attr("name");
	            if (typeof name == "undefined") {
	                return true;
	            }
	            var nmArr = name.split("_");
	            var name2 = nmArr[nmArr.length-1];
	            var a = $(this).val();
	            if(typeof a =="undefined") a ="";
	            params[name2] = a;
	        });

	        $("."+groupId).eq(i).find("textarea").each(function (e) {
	            var name = $(this).attr("name");
	            if (name == "undefined") {
	                return true;
	            }
	            var nmArr = name.split("_");
	            var name2 = nmArr[nmArr.length-1];
	            var a = $(this).val();
	            if(typeof a =="undefined") a ="";
	            params[name2] = a;
	        });
	        jsonData[i] = params;
	    }
	    return jsonData;
    },

       // 비동기 방식
    common_ajaxCallback : function(url, params, callback){
		$.ajax({
		    type : "POST",
		    url : url,
		    dataType : "html",
		    data : params,
		    error : function(e){
				console.log(e);
		        alert('정상적으로 처리 되지 않았습니다.');
		    },
		    success : function(data){
		    	callback(data);
		   }
		});
	},

	// 동기 방식
    common_ajaxCallback2 : function(url, params, callback){
		$.ajax({
		    type : "POST",
		    url : url,
		    dataType : "html",
		    data : params,
		    async : false,
		    error : function(){
		        alert('정상적으로 처리 되지 않았습니다.');
		    },
		    success : function(data){
		    	callback(data);
		   },
		   complete : function(){
				try {
					if(typeof params.pageCntHidden  != "undefined"){
						$("select[name=search_pageCnt]").val(params.pageCntHidden);
					}
				}catch (error) {
				}
		   }
		});
	},

	// post 방식으로 팝업 열기
	common_postPop : function(){
			var form = document.createElement("form");
			form.setAttribute("method", "post");
			form.setAttribute("action", popObj.url);
			form.setAttribute("target", popObj.popupId);
			for (var key in params) {
			    var input = document.createElement('input');
				input.type = 'hidden';
				input.name = key;
				input.value = params[key];
				form.appendChild(input);
			}
			document.body.appendChild(form);
			var p = window.open(popObj.url, popObj.popupId, popObj.option);
			this.popList.push(p);

			/*
			if( /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor) ){
				window.open(popObj.url, popObj.popupId , "_blank", popObj.option);
			}else{
				window.open(popObj.url, popObj.popupId, popObj.option);
			}
			*/
			form.submit();
			document.body.removeChild(form);
	},

    /*
         첫번째 excel 다운로드
         ex) c21.excel_export("eventModal3_list2", "구매현황");
    */
    excel_export : function(id, nm) {
    	var rowArr = [];
    	var colArr = [];
    	$("#"+id+" thead").find("th").each(function(){
    	 	colArr.push($(this).text());
    	});
    	rowArr.push(colArr);

    	$("#"+id+" tbody").find("tr").each(function(){
    	    colArr = [];
    		$(this).find("td").each(function(){
    			colArr.push($(this).text());
    		});
    	 	rowArr.push(colArr);
    	});


		const workSheetData = rowArr;
		const workSheet = XLSX.utils.aoa_to_sheet(workSheetData);
		// workSheet['!autofilter'] = {ref : "A1:R11"};
		const workBook = XLSX.utils.book_new();
		XLSX.utils.book_append_sheet(workBook, workSheet, 'sheet title');
		XLSX.writeFile(workBook, nm + "_excel" + ".xlsx");
    },

    /*
    	두번째 excel 다운로드
    	ex) c21.excel_export2("eventModal3_list2", "구매현황");
    */
	excel_export2 : function(id, nm) {
      var data_type = "data:application/vnd.ms-excel;charset=utf-8";
      var table_html = encodeURIComponent(document.getElementById(id).outerHTML);
      var a = document.createElement("a");
      a.href = data_type + ",%EF%BB%BF" + table_html;
      a.download = nm + "_excel" + ".xlsx";
      a.click();
    },

    /*
    	excel import 하기
    	ex) type="file" onchange="c21.excel_import(fn_readExcel)"
    */
    excel_import : function(callback){
    	let input = event.target;
	    let reader = new FileReader();
	    reader.onload = function () {
	        let data = reader.result;
	        let workBook = XLSX.read(data, { type: 'binary' });
	        let index = 0;
	        workBook.SheetNames.forEach(function (sheetName) {
	            let rows = XLSX.utils.sheet_to_json(workBook.Sheets[sheetName]);
	            let jsonData = JSON.stringify(rows);
	            input.value = null;   	// file 초기화 시켜야 한다.
	            callback(sheetName, jsonData);
	        })
	    };
	    reader.readAsBinaryString(input.files[0]);
    },

	// 방문 통계
	referrerCheck : function () {	// 유입경로
		var referrer = document.referrer.toUpperCase();
		if(referrer.indexOf("NAVER") != -1){ return "NAVER"; }
		else if(referrer.indexOf("DAUM") != -1){ return "DAUM"; }
		else if(referrer.indexOf("GOOGLE") != -1){ return "GOOGLE"; }
		else if(referrer.indexOf("ZUM") != -1){ return "ZUM"; }
		else {
			return "OTHER";
		}
	},

	browserCheck : function () { 	// 브라우저
		var agt = navigator.userAgent.toLowerCase();
		if (agt.indexOf("trident") != -1) { return 'IE'; }
		if (agt.indexOf("edg") != -1) { return 'Edge'; }
		if (agt.indexOf("whale") != -1) { return 'Whale'; }
		if (agt.indexOf("firefox") != -1) { return 'Firefox'; }
		if (agt.indexOf("opera") != -1) { return 'Opera'; }
		if (agt.indexOf("staroffice") != -1) { return 'Star Office'; }
		if (agt.indexOf("webtv") != -1) { return 'WebTV'; }
		if (agt.indexOf("beonex") != -1) { return 'Beonex'; }
		if (agt.indexOf("chimera") != -1) { return 'Chimera'; }
		if (agt.indexOf("netpositive") != -1) { return 'NetPositive'; }
		if (agt.indexOf("phoenix") != -1) { return 'Phoenix'; }
		if (agt.indexOf("skipstone") != -1) { return 'SkipStone'; }
		if (agt.indexOf("netscape") != -1) { return 'Netscape'; }
		if (agt.indexOf("chrome") != -1) { return 'Chrome'; }
		if (agt.indexOf("safari") != -1) { return 'Safari'; }
		if (agt.indexOf("mozilla/5.0") != -1) { return 'Mozilla'; }
		if (agt.indexOf("msie") != -1) {
			var rv = -1;
			if (navigator.appName == 'Microsoft Internet Explorer') {
				var ua = navigator.userAgent;
				var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
			if (re.exec(ua) != null)
				rv = parseFloat(RegExp.$1);
			}
			return 'Internet Explorer '+rv;
		}
	},

	deviceCheck : function () {// PC, MOBILE 구별	// 접속한 디바이스 환경
		var pcDevice = "win16|win32|win64|mac|macintel";
		if ( navigator.platform ) {
			if ( pcDevice.indexOf(navigator.platform.toLowerCase()) < 0 ) {
				return "MOBILE";
			} else {
				return "PC";
			}
		}
	},

	mobileCheck : function () {
		var m = new Array('iPhone', 'iPod', 'BlackBerry', 'Android', 'Windows CE', 'Windows CE;', 'LG', 'MOT', 'SAMSUNG', 'SonyEricsson', 'Mobile', 'Symbian', 'Opera Mobi', 'Opera Mini', 'IEmobile');
		for (var word in m) {
			if (navigator.userAgent.match(m[word]) != null) {
				return navigator.userAgent.match(m[word]);
				break;
			}
		}
	},

	cookie: {	/** 쿠키 */
		get: function (cookieName) {
			cookieName = cookieName + '=';
			var cookieData = document.cookie;
			var start = cookieData.indexOf(cookieName);
			var cookieValue = '';
			if (start != -1) { // 쿠키가 존재하면
				start += cookieName.length;
				var end = cookieData.indexOf(';', start);
				if (end == -1) // 쿠키 값의 마지막 위치 인덱스 번호 설정
					end = cookieData.length;
				cookieValue = cookieData.substring(start, end);
			}
			return unescape(cookieValue);
		},
		set: function (cookieName, cookieValue, expires) {
			cookieValue = escape(cookieValue);
			if (expires !== null) {
				var exdate = new Date();
				exdate.setDate(exdate.getDate() + Number(expires));
				cookieValue = cookieValue + ';expires=' + exdate.toUTCString();
			}
			document.cookie = cookieName + '=' + cookieValue;
		},
		delete: function (cookieName) {
			document.cookie = cookieName + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
		},
	},
}

// 파일 업로드 callback 하기
function fn_register_file_callback(th, data, pageType){
	if(data.result){
		var fileNm = data.data.fileNm;
	    var fileUuid = data.data.fileUuid;
	    var fileSaveNm = data.data.fileSaveNm;
	    var fileSubSeq = data.data.fileSubSeq;

	    var parentId = $("input[name=file_parent_id]").val();
	    var html="";
	    html +='<div class="uploadImg file_del">';
	    html +='<input type="hidden" class="fileSaveNm" name="fileSaveNm" value="'+fileSaveNm+'"/>';
	    html +='<input type="hidden" class="fileNm" name="fileNm" value="'+fileNm+'"/>';
	    html +='<input type="hidden" class="fileUuid" name="fileUuid" value="'+fileUuid+'"/>';
	    html +='<a href="javascript:;" onclick="c21.file_remove(this, \''+parentId+'\')" class="iconImg"><i class="bi bi-x-circle-fill"></i></a>';
	    html +='<img src="'+ckuAwsUrl+'/'+fileSaveNm+'" />';
	    html +='</div>';

      	$("#"+parentId).find(".fileArea").append(html);

      	var max = $("#"+parentId).attr("max");
      	var max2 = Number(max);
      	var fileLen = $("#"+parentId).find(".fileArea").find("input[name=fileUuid]").length;
      	if(fileLen == max2){
      		$("#"+parentId).find(".addImg").css("display", "none");
      	}else if(fileLen < max2){
      		$("#"+parentId).find(".addImg").css("display", "");
      	}

      	// 이미지 정렬
      	$( "#sortable, #sortable2, #sortable3" ).sortable();
		$( "#sortablem, #sortable2, #sortable3" ).disableSelection();

		// 업로드 후에 초기화
		$("#file_upload1").val("");
		$(".custom-file-label").html("Choose Image");
   	}else{
   		alert(data.message);
   	}
   	$(".modal").modal("hide");
}

// 파일 삭제하기
function fn_register_file_del(th, event){
	var obj = $(th).closest("file");
	obj.find(".custom-file-label").text("파일 선택");
	obj.find("file").val("");
	$(th).closest("file_del").remove();
	return false;
}

c21.init_map();