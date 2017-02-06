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

var links = [
	"https://www.youtube.com/embed/OtrzWO3pz68",
	"https://www.youtube.com/embed/9mnZGyyIQ_o",
	"https://www.youtube.com/embed/Y35TJVKNarA",
	"https://www.youtube.com/embed/RD6cePCZYSU",
	"https://www.youtube.com/embed/L5BGbjtJ1mo",
	"https://www.youtube.com/embed/LNhAfNz0Zc0",
	"https://www.youtube.com/embed/GlrG1JPgCXI",
	"https://www.youtube.com/embed/UuKcRudMMmg",
	"https://www.youtube.com/embed/7RgbM1YDgXU",
	"https://www.youtube.com/embed/0EFBqqIJbcQ",
	"https://www.youtube.com/embed/opJzDOMIiHA",
	"https://www.youtube.com/embed/Fkd7HqPlO_k",
	"https://www.youtube.com/embed/jHqhy8pxXSg",
	"https://www.youtube.com/embed/wuDCAkoZSYo",
	"https://www.youtube.com/embed/qfTUkzlAU60",
	"https://www.youtube.com/embed/oUeRsFxqmqQ",
	"https://www.youtube.com/embed/AlaUYfvTaZE",
	"https://www.youtube.com/embed/SqgWrJlA7no",
	"https://www.youtube.com/embed/JwfUS0sjBIk",
	"https://www.youtube.com/embed/9WKDDuDoQt4",
	"https://www.youtube.com/embed/i12WtnRuObQ",
	"https://www.youtube.com/embed/O6AjQXq_z0Q",
	"https://www.youtube.com/embed/w5yZ_JC39Fw",

	"https://www.youtube.com/embed/Pj2RzpY2kMg",
	"https://www.youtube.com/embed/U0-ygB6s5XE",
	"https://www.youtube.com/embed/UbJfPrUBQjw",
	"https://www.youtube.com/embed/evqQN5M8IWU",
	"https://www.youtube.com/embed/prghAteSCqI",
	"https://www.youtube.com/embed/Rzi27iVyjQE",
	"https://www.youtube.com/embed/BEicap0EJog",
	"https://www.youtube.com/embed/dhhZFSnMkMk",
	"https://www.youtube.com/embed/iWxnx6Pc6tE",
	"https://www.youtube.com/embed/Xj-c_bl1w9M",
	"https://www.youtube.com/embed/km8sY5PqQnM",
	"https://www.youtube.com/embed/Kq0mzoiWETs",
	"https://www.youtube.com/embed/-Bn6tDQ8mj0",
	"https://www.youtube.com/embed/gKMEXO0Tjh8",
	"https://www.youtube.com/embed/N6xG6h9E3g0",
	"https://www.youtube.com/embed/dPY1Jd2rUPE",
	"https://www.youtube.com/embed/cqTpr-Eix9E",
	"https://www.youtube.com/embed/_puNHSkgGtE",
	"https://www.youtube.com/embed/4noqj0933Os"
];
function changeSource(link_index){
	$('.videoAppMovie').attr('src' , links[link_index]); 
}
function showSeason(season){
	$('#videoAppSeason').css('height','21px');
	$('.gameVideo').css('display',"none");
	$('.s'+season).css('display',"block");
}
var dots = 0;
var u,v,loadingInterval;
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
	clearInterval(loadingInterval);
	$('#loading').html('');		
	$('#statDisplay').switchClass("opaque","not_opaque",250);
}
function fadeOutStats(){
	$('#statDisplay').switchClass("not_opaque","opaque",50);
	loadingInterval = setInterval(function(){
		var dots_string = "";
		dots = dots % 5;
		for ( i = 0 ; i <= dots ; i++)	{
			dots_string = dots_string + ".";
		}
		$('#loading').html(dots_string + 'loading' + dots_string);		
		dots = dots + 1;
	}, 140)
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
	$('#seasonToggler').click(function(){
		var pHeight = $('#videoAppSeason').css('height');
		var childrenCount = $('#seasonToggler').parent().children().length;
		if ( pHeight.split('px')[0] > 21 ) {
			$('#videoAppSeason').css('height','21px');
		}
		else {
			$('#videoAppSeason').css('height', (childrenCount * 21) + "px");
		}
//		$('#seasonToggler').parent().css('overflow','visible');
//		alert($('#seasonToggler').parent().children().length);
//		if($('#seasonToggler').parent().css('height') == );
	});
	function changeSource(link_index){
		alert('pula');
	//	$('.videoAppMovie').attr('src' , links[0]); 
	}
};
$(document).ready(ready)
$(document).on('page:load', ready);
//		END DOM INIT FUNCTIONS
