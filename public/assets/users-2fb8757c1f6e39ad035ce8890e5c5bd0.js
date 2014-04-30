(function() {
  jQuery(function() {
    $('#expiration').datepicker({
      dateFormat: 'yy-mm-dd'
    });
    return $('#pantry_expiration').datepicker({
      dateFormat: 'yy-mm-dd'
    });
  });

}).call(this);
