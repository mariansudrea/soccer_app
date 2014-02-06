// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
var u,v;
function restoreTeam(){
	v = 420;
	alert('pula');
	$('#bottomContainer').html("<h2>SELECT PLAYER</h2>");
	a = setInterval(function(){restoreIt()}, 3);
}

function restoreIt()
{
    if ( v <= 150 ) v=150; 
	else v-=3;
    c = "-"+v+"px";
    $('#teamContainer').css("margin-top",b);
    $('#bottomContainer').css("margin-top",c);
    if ( u == 0 && v == 150)
        {
		clearInterval(a);
		$("#restoreButton").css("display","none");
		
		}

}
