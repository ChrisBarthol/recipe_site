$(function(){
  $('.info_link').click(function(){
    //alert($(this).text());
    $('.info_link').css({'font-weight':'normal'})
    $(this).css({'font-weight':'bold'})

    var t = $(this).text();
    

    $.ajax( '/recipes/newingredient',{
    	type: 'POST',
    	data: {'name': t},
    	success: function(t){

        $(document).ready(function(){
  $('.bxslider').bxSlider({
    mode: 'fade',
    captions: true,
    adaptiveHeight: true,
  });
});

    	},

    });

  });

});

$(document).ready(function(){
  $('.bxslider').bxSlider({
    mode: 'fade',
    captions: true,
    adaptiveHeight: true,
  });
});

$(document).ready(function(){
  var thescore = $('#rating2').data('score');
  $('#rating2').raty({
    readOnly: true,
    score: thescore,
    half: true,
    size: 46,
    number: 10,
    path: '/assets'
  });
});

