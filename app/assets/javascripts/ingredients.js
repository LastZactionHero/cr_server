$(document).ready(function(){
	sizeIngredientBar();
	$(window).resize(function(){sizeIngredientBar()});
	
	bindListIngredients();
	
	$(".search-bar").on('input', function(){
		var name = $(this).val()
		if(name.length > 0) {
			toggleIngredient(false);
			searchResults(name);
		} else {
			clearResults();				
			if(name.length == 0) {
				toggleIngredient(true);
			}
		}
	});
});

function searchResults(name) {
	if(name.length >= 2) {
		$.ajax({
			url: "/ingredients/search",
			data: {
				name: name
			},
			success: function(data){				
				$("#search-results").html(data);
				bindSearchResults();
			}			
		});
	} else {
		clearResults();
	}
}

function clearResults() {
	$("#search-results").html("");
}

function toggleIngredient(visible) {
	if(visible) {
		$("#ingredient").fadeIn();
	} else {
		$("#ingredient").hide();
	}
}

function bindSearchResults(){
	$(".search-result").click(function(){
		var id = $(this).attr('data_id');
		var path = $(this).attr('data_path');
		loadIngredient(id, path);
	});
}

function loadIngredient(id, path) {
	clearResults();
	updateUrlBar(path);
	
	$.ajax({
		url: "/ingredients/" + id,
		success: function(data){				
			$("#ingredient").html(data);
			toggleIngredient(true);			
		}			
	});
}

function updateUrlBar(path) {
	window.history.pushState("null", "null", path);
}

function sizeIngredientBar() {
	var windowHeight = $(window).height();
	$("#ingredient-list").css('height', windowHeight);
}

function bindListIngredients() {
	$(".list-ingredient").click(function(){
		var id = $(this).attr('data_id');
		var path = $(this).attr('data_path');
		loadIngredient(id, path);
		return false;
	});
}