$(function(){
  $('.info_link').click(function(){
    //alert($(this).text());
    $('.info_link').css({'font-weight':'normal'})
    $(this).css({'font-weight':'bold'})

    showingredient = this.text;

   //  reloadCarousel: (data) ->
   //  alert("This worked!")	

  	// GetIngredient: (value) ->
  	// $.ajax '/recipes/newingredient',
  	// 	type: 'POST',
  	// 	data: { new_ingredient: value }
  	// 	success: data ->
  	// 	  reloadCarousel data


  });




});
