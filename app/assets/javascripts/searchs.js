$(function() {
  var search = queryParameters().search

  if(search!='' && search != undefined)
    $("#search_field").val(search);
});
