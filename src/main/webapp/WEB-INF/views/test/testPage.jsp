<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>

<head>
	<script language="javascript" src="/assets/js/jquery-3.3.1.js"></script>
	<!-- <script language="javascript" src="/assets/js/shim.js"></script> -->
	<script language="javascript" src="/assets/js/huge-uploader.js"></script>
	<script language="javascript" src="/assets/js/c21.js"></script>
<!-- <script language="javascript" src="/assets/js/bundle.js"></script> -->
<!-- <script language="javascript" src="https://unpkg.com/event-target-shim@6.0.2/umd.js"></script> -->

<!-- <script language="javascript" src="https://cdn.jsdelivr.net/npm/huge-uploader@1.0.6/lib/index.min.js"></script> -->

</head>
<style>
.progress {
    position: relative;
    width: 100%;
    height: 30px;
}
.progress-bar {
    margin-bottom: 5px;
    width: 0%;
    height: 30px;
    position: relative;
    background-color: rgb(66, 139, 202);
}
.progress-bar-text {
    position: absolute;
    top: 0px;
    width: 100%;
    text-align: center;
    line-height: 30px;
    vertical-align: middle;
}
</style>
<script>
var data="";
var test="";
var arr = new Array();
// excel upload 한 후에
function fn_excel_upload(event, callback){
	try{
		var input = event.target;
		var file = input.files[0];
		var chunk = (1024*1024*1);
		var offset = 0;
		var fr = new FileReader();
		var fileIndex=0;
		fr.onload = function(te) {
			var viewUint8Array = new Uint8Array(te.target.result);
			var viewUint8ArrayMap = new Int8Array(te.target.result).map((v, i) => i);
			
			var view = te.target.result;
			var blob = new Blob(viewUint8Array);
			var formData = new FormData();
			formData.append("testFile" + fileIndex, viewUint8ArrayMap);
			fileIndex++;
			var xhr = new XMLHttpRequest();
			xhr.open("POST", "/test/upload.do", false);
			xhr.onreadystatechange =function(e){
				if (xhr.readyState == XMLHttpRequest.DONE) {
					console.log('done! send chunk');
					//console.log("offset : " + offset + ", chunk size : " + chunk); 
					// for (var i = 0; i < view.length; ++i) {
					// 	if (view[i] === 10 || view[i] === 13) {
					// 		// Check if \r or \n found
					// 		// column length = offset + position of \r or \n
					// 		callback(offset + i);
					// 		return;
					// 	}
					// }
					// // continue reading slices if \r or \n not found.
					// offset += chunk;
					// continue_reading();
				}
			};
			xhr.setRequestHeader("fileName", file.name);
			var chunkEnd = Math.min(offset + chunk , file.size );
			var blobEnd = chunkEnd -1;
			//xhr.setRequestHeader("Content-Length", chunkEnd);
			var contentRange = "bytes "+ offset+"/"+ blobEnd+"/"+file.size;
			console.log("bytes "+ offset+"-"+ blobEnd+"/"+file.size + "/fileName : " + file.name); 
			xhr.setRequestHeader("Content-Range",contentRange);
			//console.log("file.name : " + file.name);
			//xhr.setRequestHeader("Content-Type", "multipart/form-data;boundary=t");
			//console.log("file.type : " + file.type);
			xhr.send(view);


			for (var i = 0; i < view.length; ++i) {
				if (view[i] === 10 || view[i] === 13) {
					// Check if \r or \n found
					// column length = offset + position of \r or \n
					callback(offset + i);
					return;
				}
			}
			// continue reading slices if \r or \n not found.
			offset += chunk;
			continue_reading();
			
			// $.ajax({
			// 	url: "/test/upload.do"
			// 	, type: 'POST'
			// 	, data: formData
			// 	, processData: false
			// 	, success:function(e){
			// 		var chunkEnd = Math.min(offset + chunk , file.size );
			// 		var blobEnd = chunkEnd -1;
			// 		var contentRange = "bytes "+ offset+"-"+ blobEnd+"/"+file.size;
			// 		console.log("bytes "+ offset+"-"+ blobEnd+"/"+file.size + "/fileName : " + file.name); 
			// 		for (var i = 0; i < view.length; ++i) {
			// 			if (view[i] === 10 || view[i] === 13) {
			// 				// Check if \r or \n found
			// 				// column length = offset + position of \r or \n
			// 				callback(offset + i);
			// 				return;
			// 			}
			// 		}
			// 		// continue reading slices if \r or \n not found.
			// 		offset += chunk;
			// 		continue_reading();
			// 	}
			// 	, error:function(e){

			// 	}
			// });
		};
		fr.onerror = function() {
			// Something went wrong
			callback(0);
		};
		continue_reading();
		function continue_reading() {
			if (offset >= file.size) {
				// If no \r or \n found. The column size is equal to the full
				// file size
				callback(file.size);
				return;
			}
			var slice = file.slice(offset, offset + chunk);
			fr.readAsArrayBuffer(slice);
		}
	}
	catch(e){
		alert("정상적인 Excel파일을 올려주세요.");
		console.log(e);
	}
}



// excel insert 하는 로직
	function fn_excel_callback(size){
		
		// var bstr = arr.join("");
		// var read_buffer = XLSX.read(bstr, {type : 'array'});
		// read_buffer.SheetNames.forEach(
		// function(sheetName){
		// 		var rowdata =XLSX.utils.sheet_to_json(read_buffer.Sheets[sheetName],{defval:""});
		// 		test += rowdata;
		// 		//console.log("rowdata : " + rowdata);
		// 	}
		// );

		// var read_buffer = XLSX.read(data, {type : 'binary'});
		// read_buffer.SheetNames.forEach(
		// 	function(sheetName){
		// 		var rowdata =XLSX.utils.sheet_to_json(read_buffer.Sheets[sheetName],{defval:""});
		// 		//console.log("rowdata : " + rowdata);
		// 	}
		// );
	}

	function fn_test(event, callback){
		try{
			var input = event.target;
			var file = input.files[0];
			var formData = new FormData();

			formData.append("testfile", file);
			var xhr = new XMLHttpRequest();
			xhr.open("POST", "/test/upload.do", false);
			xhr.onload=function(e){
				//console.log("offset : " + offset + ", chunk size : " + chunk); 
			};
			xhr.setRequestHeader("FILENAME", file.name);
			console.log("file.name : " + file.name);
			//xhr.setRequestHeader("Content-Type", file.type);
			//console.log("file.type : " + file.type);
			xhr.send(formData);
		}
		catch(e){

		}

		callback();
	}

	function generateUUID() {
		var d = new Date().getTime();
		var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
			var r = (d + Math.random()*16)%16 | 0;
			d = Math.floor(d/16);
			return (c=='x' ? r : (r&0x3|0x8)).toString(16);
		});
		return uuid;
	};

	function fn_testCallback(){

	}

	function fn_testUploader(event, fileType, pageType, callback){
		var input = event.target;
		var fileObject = input.files[0];
		var name = fileObject.name;
		if(fileObject==""){
			alert("파일을 업로드 해주세요.");
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

		}
		else if(fileType == "txt"){
			fileArr = ['pdf', 'xls', 'xlsx', 'txt', 'doc', 'docx', 'ppt', 'pptx', 'hwp'];
			if(fileArr.indexOf(ext) == -1) {
				alert("문서 파일을 업로드 해 주세요.");
				return false;
			}

		}
		else if(fileType == "imgTxt"){
			fileArr = ['png','jpg','jpeg', 'gif', 'pdf', 'xls', 'xlsx', 'txt', 'doc', 'docx', 'ppt', 'pptx', 'hwp'];
			if(fileArr.indexOf(ext) == -1) {
				alert("문서 파일을 업로드 해 주세요.");
				return false;
			}
			fileType = "file";

		}
		else if(fileType == "zip"){
			if(fileType != ext) {
				alert("파일 형식을 확인해 주세요.");
				return false;
			}
		}
		else if(fileType == "video"){
			fileArr = ['avi','mp4','m4v','wmv','mkv','mov'];
			if(fileArr.indexOf(ext) == -1) {
				alert("영상 파일을 업로드 해 주세요.");
				return false;
			}

		}
		else{
			if(fileArr.indexOf(ext) == -1) {
				alert("업로드 불가 파일입니다.");
				return false;
			}
		}



		var headers = new Object();
		headers.pageType = pageType;
		headers.fileType = fileType;
		headers.uniqueId = generateUUID();
		headers.fileObjectName = fileObject.name;
		headers.fileObjectSize = fileObject.size;
		headers.fileObjectType = fileObject.type;
		const HugeUploader = require('huge-uploader');
		const uploader = new HugeUploader({ endpoint: '/file/upload.do', file: fileObject, headers:headers });
		// subscribe to events
		uploader.on('error', (err) => {
			console.error('Something bad happened', err.detail);
		});

		uploader.on('progress', (progress) => {
			//console.log('The upload is at ' + progress);
			var data = progress.detail.responseData;
			var code = data.code;
			switch(code){
				case "0000":
				case "0004":
					$(".progress-bar").find("span.data-percent").html(progress.detail.percent + "%");

					$(".progress-bar").animate({
						width: progress.detail.percent + "%"
					}, 800);
					break;
				case "0001":
					uploader.togglePause();
					alert(data.result);
					location.href="admin/loginView.do";
					break;
				case "0002":
				case "0003":
					uploader.togglePause();
					alert(data.result);
					break;

			}
		});

		uploader.on('fileRetry', (msg) => {
			console.log(msg);
		});

		uploader.on('finish', (body) => {
			console.log('yeahhh - last response body:', body);
		});

		//uploader.togglePause();
		callback();
	}

	function fn_testUploaderCallback(e){
		
	}
</script>
<body>
																		<!-- test하려고 video로 바꿈 img로 바꿀 것 -->
	<input type="file" id="testUploader" onchange="fn_testUploader(event, 'img', 'doc', fn_testUploaderCallback);">
	<div class='progress' style="width:600px;">
    <div class='progress-bar' data-width='0'>
        <div class='progress-bar-text'>
            Progress: <span class='data-percent'></span>
        </div>
	</div>
	</div>
</body>
</html>