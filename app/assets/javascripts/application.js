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
	v = 605;

	a = setInterval(function(){restoreIt()}, 30);
}

function restoreIt()
{
    if ( v <= 150 ) v=150; 
	else v-=50;
    c = "-"+v+"px";
    $('#bottomContainer').css("margin-top",c);
    if ( v == 150)
        {
			clearInterval(a);
			$("#restoreButton").css("display","none");
			$("#bottomContainer").html("<h3 id='restoreButton'>SELECT PLAYER</h3>");
		}	

}
var initWho,initPeriod,initField,initUser,initOpp;
function initState(){
	initWho = $('#whoVal').val()||0;
	initField = $('#fieldVal').val()||0;
	initOpp = $('#opponentVal').val()||0;
    initUser = $('#playerVal').val()||0;
	initPeriod = $('#periodSelect').val()||0;
	console.log('finished init.');
	
}
function restoreState(){
	$('#whoVal').val(initWho);
	$('#fieldVal').val(initField);
	$('#periodSelect').val(initPeriod);
	$('#opponentVal').val(initOpp);
	$('#player').val(initUser);
				if ($('#fieldVal').val() != "0"){
					$('#disclaimer').switchClass('opaque','not_opaque');
				}
				if ($('#fieldVal').val() == 0){
					$('#disclaimer').switchClass('not_opaque','opaque');
				}
	if ($('#periodSelect').val() == 0){	
	    $('#playerSelect').switchClass('visible', 'invisible', 500);
	    $('#fieldSelect').switchClass('invisible', 'visible', 500);
	    $('#opponentSelect').switchClass('invisible', 'visible', 500);
	    $('#whoSelect').switchClass('invisible', 'visible', 500);
	}
	console.log('state loaded.');
}	
function fadeInStats(){
	$('#statDisplay').switchClass("opaque","not_opaque",250);
}
function fadeOutStats(){
	$('#statDisplay').switchClass("not_opaque","opaque",50);
}
function getHref(a,b){
	if (id > 0){
		$('#whoVal').val(0);
		$('#opponentVal').val(0);
		$('#fieldVal').val(0);
	}
	var gpg = a ? a : $('#gpgVal').val();
	var apg = b ? b : $('#apgVal').val();
	if ( a != null ){
		$('#gpgVal').val(a);
		restoreState();
	}
	if ( b != null ){
		$('#apgVal').val(b);
		restoreState();
	}
	var id = $('#periodSelect').val();
	var who = $('#whoVal').val()||0;
	var field = $('#fieldVal').val();
	var opp = $('#opponentVal').val();
    var user = $('#playerVal').val();
    $.ajax({
		url: 'stats.js?id='+id+"&who="+who+"&field="+field+"&opp="+opp+"&user="+user+"&gpg="+gpg+"&apg="+apg,
		type: 'GET',
		dataType: 'script',
		beforeSend: function(){fadeOutStats()},
		complete: function(){fadeInStats();initState()}
	});
    return;
}

//		DOM INIT FUNCTIONS
var ready = function(){
	url = "//code.jquery.com/ui/1.8.24/jquery-ui.js";
	$.getScript(url);
	initState();
	$('#periodSelect').change(function(){
    	if ( $('#periodSelect').val() == 0 ){
			if ($('#whoVal').val() == 0 ){
	        	$('#opponentSelect').switchClass('invisible', 'visible',500);
    	    	$('#fieldSelect').switchClass('invisible', 'visible',500);
				if ($('#fieldVal').val() != "0"){
					$('#disclaimer').switchClass('opaque','not_opaque');
				}
				if ($('#fieldVal').val() == 0){
					$('#disclaimer').switchClass('not_opaque','opaque');
				}
			} 
			else {
				$('#playerSelect').switchClass('invisible','visible',500);
			}
        	$('#whoSelect').switchClass('invisible', 'visible',500);
    	}
    	else {
			$('#disclaimer').switchClass('not_opaque','opaque');
        	$('#opponentSelect').switchClass('visible', 'invisible', 500);
        	$('#fieldSelect').switchClass('visible', 'invisible', 500);
        	$('#whoSelect').switchClass('visible', 'invisible', 500);
        	$('#whoVal').val(0);
        	$('#playerSelect').switchClass('visible', 'invisible', 500);
    	}
	});
	$('#whoVal').change(function(){
    	if ( $('#whoVal').val() == 0 ){
        	$('#playerSelect').switchClass('visible', 'invisible',500);
        	$('#fieldSelect').switchClass('invisible', 'visible',500);
        	$('#opponentSelect').switchClass('invisible', 'visible',500);
				if ($('#fieldVal').val() != "0"){
					$('#disclaimer').switchClass('opaque','not_opaque');
				}
				if ($('#fieldVal').val() == 0){
					$('#disclaimer').switchClass('not_opaque','opaque');
				}
    	}
    	else {
        	$('#playerSelect').switchClass('invisible', 'visible',500);
        	$('#fieldSelect').switchClass('visible', 'invisible',500);
        	$('#opponentSelect').switchClass('visible', 'invisible',500);
			$('#disclaimer').switchClass('not_opaque','opaque');
    	}
	});
	$('#fieldVal').change(function(){
		if ($('#fieldVal').val() != "0"){
			$('#disclaimer').switchClass('opaque','not_opaque');
		}
		if ($('#fieldVal').val() == 0){
			$('#disclaimer').switchClass('not_opaque','opaque');
		}
	});
};
$(document).ready(ready)
$(document).on('page:load', ready);
//		END DOM INIT FUNCTIONS
