// convert all characters to lowercase to simplify testing
var agt=navigator.userAgent.toLowerCase();

// *** BROWSER VERSION ***
// Note: On IE5, these return 4, so use is_ie5up to detect IE5.
var is_major = parseInt(navigator.appVersion);
var is_minor = parseFloat(navigator.appVersion);

// Note: Opera and WebTV spoof Navigator.  We do strict client detection.
// If you want to allow spoofing, take out the tests for opera and webtv.
var is_nav  = ((agt.indexOf('mozilla')!=-1) && (agt.indexOf('spoofer')==-1)
            && (agt.indexOf('compatible') == -1) && (agt.indexOf('opera')==-1)
            && (agt.indexOf('webtv')==-1) && (agt.indexOf('hotjava')==-1));
var is_ie     = ((agt.indexOf("msie") != -1) && (agt.indexOf("opera") == -1));

function showForm(setWidth,setHeight,windowName,URL){

    var w = window.screen.availWidth;
    var h = window.screen.availHeight;

    var leftPos = (w-setWidth)/2, topPos = ((h-setHeight)/2)-50; setHeight += 50;
    eval(windowName + " = window.open('"+ URL + "','" + windowName + "', 'toolbar=0,scrollbars=1,location=0,statusbar=1,menubar=0,resizable=0,width="+ setWidth +",height="+ setHeight +",left = "+ leftPos +",top = "+topPos +"');");
}

function showPrintForm(setWidth,setHeight,windowName,URL){

    var w = window.screen.availWidth;
    var h = window.screen.availHeight;

    var leftPos = (w-setWidth)/2, topPos = ((h-setHeight)/2)-50; setHeight += 50;
    eval(windowName + " = window.open('"+ URL + "','" + windowName + "', 'toolbar=1,scrollbars=1,location=0,statusbar=1,menubar=1,resizable=0,width="+ setWidth +",height="+ setHeight +",left = "+ leftPos +",top = "+topPos +"');");
}

function icobtn_out(id) {
  $(id).css("border","1px solid #ffffff");
  $(id).css("cursor","default");
}

function icobtn_over(id) {
  $(id).css("border","1px solid #000000");
  $(id).css("cursor","pointer");
}

function gridbtn_out(id) {
  $(id).css("border","1px solid #CACACA");
  $(id).css("cursor","default");
}

function gridbtn_over(id) {
  $(id).css("border","1px solid #000000");
  $(id).css("cursor","pointer");
}

function menubtn_out(id) {
  $(id).css("border","1px solid #ffffff");
  $(id).css("cursor","default");
}

function menubtn_over(id) {
  $(id).css("border","1px solid #c00000");
  $(id).css("cursor","pointer");
}

function check_reason(reason) {
  // check minimum length 3 char
  reason = reason.toLowerCase();
  if (reason.length > 2) {

      // check minimum there is 1 vocal
      var a = reason.indexOf("a");
      if (a < 0) {

          var i = reason.indexOf("i");
          if (i < 0) {

              var u = reason.indexOf("u");
              if (u < 0) {

                  var e = reason.indexOf("e");
                  if (e < 0) {

                      var o = reason.indexOf("o");
                      if (o < 0) {

                          alert('Minimum 1 vocal characters required for remark');
                          return false;
                      }
                      else {

                          return true;
                      }
                  }
                  else {

                      return true;
                  }
              }
              else {

                  return true;
              }
          }
          else {

              return true;
          }
      }
      else {

          return true;
      }

  }
  else {
      alert('Minimum 3 characters required for remark');
      return false;
  }
}