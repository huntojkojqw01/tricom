$(document).ready(function(){
  // disable auto discover
  Dropzone.autoDiscover = false;

  // grap our upload form by its id
  user_id = $('.user-id').text();
  // $("#edit_user_"+user_id).dropzone({
  //   // restrict image size to a maximum 1MB
  //   // changed the passed param to one accepted by
  //   // our rails app
  //   paramName: "user[avatar]",
  //   // show remove links on each image upload
  //   addRemoveLinks: true,
  //   success: function(file, response){
  //     // find the remove button link of the uploaded file and give it an id
  //     // based of the fileID response from the server
  //     $(file.previewTemplate).find('.dz-remove').attr('id', user_id);
  //     // add the dz-success class (the green tick sign)
  //     $(file.previewElement).addClass("dz-success");

  //   }

  // });
  $("div#myDrop").dropzone({
    // restrict image size to a maximum 1MB
    // changed the passed param to one accepted by
    // our rails app
    url:'/users/'+user_id,
    method: 'put',
    headers: {
      'X-Transaction': 'POST Example',
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    paramName: "user[avatar]",
    // show remove links on each image upload
    addRemoveLinks: true,
    success: function(file, response){
      // find the remove button link of the uploaded file and give it an id
      // based of the fileID response from the server
      $(file.previewTemplate).find('.dz-remove').attr('id', user_id);
      // add the dz-success class (the green tick sign)
      $(file.previewElement).addClass("dz-success");

    }

  });
});