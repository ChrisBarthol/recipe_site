(function() {
  jQuery(function() {
    $('#expiration').datepicker({
      dateFormat: 'yy-mm-dd'
    });
    $('#pantry_expiration').datepicker({
      dateFormat: 'yy-mm-dd'
    });
    return $('.datepicker').datepicker({
      dateFormat: 'yy-mm-dd'
    });
  });

}).call(this);
