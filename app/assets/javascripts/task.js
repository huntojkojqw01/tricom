var ready, set_positions;

set_positions = function(){
    // loop through and give each task a data-pos
    // attribute that holds its position in the DOM
    $('.panel.panel-default').each(function(i){
        $(this).attr("data-pos",i+1);
    });
}

ready = function(){
    jQuery(".best_in_place").best_in_place();
    // var old_value;
    // $(document).on('change', '.title-edit', function (e) {
    //     console.log(e.target.value);
    //     old_value = e.target.value;
    //     // $(e.target).data('bipOriginalContent', old_value);
    // });
    // $(document).on('ajax:error', '.title-edit', function (e) {
    //     alert("test")
    //     console.log(e);
    //     e.target.innerHTML = old_value;
    //     $(e.target).data('bipOriginalContent', old_value);
    // });
    // call set_positions function
    set_positions();

    $('.sortable').sortable();

    // after the order changes
    $('.sortable').sortable().bind('sortupdate', function(e, ui) {
        // array to store new order
        updated_order = []
        // set the updated positions
        set_positions();

        // populate the updated_order array with the new task positions
        $('.panel.panel-default').each(function(i){
            updated_order.push({ id: $(this).data("id"), position: i+1 });
        });

        // send the updated order via ajax
        $.ajax({
            type: "PUT",
            url: '/tasks/sort',
            data: { order: updated_order }
        });
    });
}

$(document).ready(ready);
/**
 * if using turbolinks
 */
$(document).on('page:load', ready);

//Override the default confirm dialog by rails
$.rails.allowAction = function(link){
  if (link.data("confirm") == undefined){
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}

//User click confirm button
$.rails.confirmed = function(link){
  link.data("confirm", null);
  link.trigger("click.rails");
}

//Display the confirmation dialog
$.rails.showConfirmationDialog = function(link){
  var message = link.data("confirm");
  swal({
    title: message,
    type: 'warning',
    confirmButtonText: 'OK',
    cancelButtonText: "キャンセル",
    confirmButtonColor: '#2acbb3',
    showCancelButton: true
  }).then(function(e){
    $.rails.confirmed(link);
  });
};