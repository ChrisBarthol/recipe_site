
$(document).ready(function(){
	$('a#add-another').click(function(){
		$('#ingredient-list li:first').clone().end().appendTo('#ingredient-list');
	});

	$('.p').click(function(){
   		alert("The paragraph was clicked.");
  	});

	$('.delete-ingredient').live('click', function(){
		if ($('#ingredient-list li').length <1)
			$(this).parent('.fields').hide);
		else
			alert('You need at least one ingredient.')
	});


});