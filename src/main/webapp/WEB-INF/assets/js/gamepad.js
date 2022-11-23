var hasGP = false;
var repGP;
var snendMsgCount = 0; // 1번만 0값을 전달하기 위함.


function canGame() {
    return "getGamepads" in navigator;
}

function reportOnGamepad() {
    var gp = navigator.getGamepads()[0];
    var pitch = 0, roll = 0, yaw = 0, throttle = 0;
    //console.log(gp.axes);

    roll = gp.axes[2]; // 좌우
    if (Math.abs(roll) < 0.02) {
        roll = 0;
    }


    pitch = gp.axes[5]; // 전진 후진
    if (Math.abs(pitch) < 0.02) {
        pitch = 0;

    } else {
        if(pitch > 0) { // 양수 -> 음수
            pitch = -Math.abs(pitch)

        } else { // 음수 -> 양수
            pitch = Math.abs(pitch)
        }
    }


    yaw = gp.axes[0]; // 회전
    if (Math.abs(yaw) < 0.02) {
        yaw = 0;
    }


    throttle = gp.axes[1]; // 고도
    if (Math.abs(throttle) < 0.02) {
        throttle = 0;

    } else {
        if(throttle > 0) { // 양수 -> 음수
            throttle = -Math.abs(throttle)

        } else { // 음수 -> 양수
            throttle = Math.abs(throttle)
        }
    }

    for(var gpi=0; gpi<gp.buttons.length; gpi++){
        if(gp.buttons[gpi].pressed||gp.buttons[gpi].touched){
            switch(gpi){
                case 0:      // X버튼
                    $("#screenJoystickGimbal4").trigger("onmousedown");
                    setTimeout(function(){
                        $("#screenJoystickGimbal4").trigger("onmouseout");
                    }, 50);
                    
                break;
                case 1:      // A버튼
                    $("#screenJoystickGimbal8").trigger("onmousedown");
                    setTimeout(function(){
                        $("#screenJoystickGimbal8").trigger("onmouseout");
                    }, 50);
                break;
                case 2:      // B버튼
                    $("#screenJoystickGimbal6").trigger("onmousedown");
                    setTimeout(function(){
                        $("#screenJoystickGimbal6").trigger("onmouseout");
                    }, 50);
                break;
                case 3:      // Y버튼
                    $("#screenJoystickGimbal2").trigger("onmousedown");
                    setTimeout(function(){
                        $("#screenJoystickGimbal2").trigger("onmouseout");
                    }, 50);
                break;
                case 4:      // L1버튼
                    $("#div_controlPanelBrightOut").trigger("onmousedown");
                    setTimeout(function(){
                        $("#div_controlPanelBrightOut").trigger("onmouseout");
                    }, 50);
                break;
                case 5:      // R1버튼
                    $("#div_controlPanelZoomOut").trigger("onmousedown");
                    setTimeout(function(){
                        $("#div_controlPanelZoomOut").trigger("onmouseout");
                    }, 50);
                break;
                case 6:      // L2버튼
                    $("#div_controlPanelBrightIn").trigger("onmousedown");
                    setTimeout(function(){
                        $("#div_controlPanelBrightIn").trigger("onmouseout");
                    }, 50);
                break;
                case 7:      // R2버튼
                    $("#div_controlPanelZoomIn").trigger("onmousedown");
                    setTimeout(function(){
                        $("#div_controlPanelZoomIn").trigger("onmouseout");
                    }, 50);
                break;
                case 8:      // Select버튼
                break;
                case 9:      // Start버튼
                break;
            }
        }

    }


    msgSend(pitch, roll, yaw, throttle)
    
}

$(document).ready(function() {
    if(canGame()) {
        //var prompt = "To begin using your gamepad, connect it and press any button!"; // 게임 패드 사용을 시작하려면 게임 패드를 연결하고 아무 버튼이나 누르십시오!
        //$("#gamepadPrompt").text(prompt);

        $(window).on("gamepadconnected", function() { // 게임 패드
            hasGP = true;

            //$("#gamepadPrompt").html("Gamepad connected!"); // 게임 패드 연결!

            console.log("connection event"); // 연결 이벤트

            
            // if(droneControlArray.length == 0 && testMode === false){
            //     fun_alert("CM0239"); // 드론을 선택해주세요
            //     return;
                
            // } else {
                repGP = window.setInterval(reportOnGamepad, 100);
            // }
        });

        $(window).on("gamepaddisconnected", function() {
            console.log("disconnection event"); // 단절 이벤트

            //$("#gamepadPrompt").text(prompt);

            window.clearInterval(repGP);
        });

        //setup an interval for Chrome // Chrome 간격 설정
        var checkGP = window.setInterval(function() {
            //console.log('checkGP'); // GP 확인

            if(navigator.getGamepads()[0]) {
                if(!hasGP) $(window).trigger("gamepadconnected");

                window.clearInterval(checkGP);
            }
        }, 100);
    }
});