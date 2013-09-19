(function() {
  $(function() {
    return $('.delete-ingredient').click(function() {
      if ('#ingredient-list'.length > 1) {
        return $(this).parent().remove();
      } else {
        return alert('You need at least one');
      }
    });
  });

}).call(this);
