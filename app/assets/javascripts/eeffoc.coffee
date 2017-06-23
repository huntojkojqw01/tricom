jQuery ->
	$.fn.modal_success = ()->        
        this.modal('hide')

        #clear form input elements
        #note: handle textarea, select, etc
        this.find('form input[type="text"]').val('')

        #clear error state
        this.clear_previous_errors()
   
	$.fn.render_form_errors = (errors) ->	    
	    this.clear_previous_errors()
	    model = this.data('model')

	    $.each(errors, (field, messages) ->	    	
	      	$input = $('input[name="' + model + '[' + field + ']"]')
	      	$input.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') )
	      	$select = $('select[name="' + model + '[' + field + ']"]')
	      	$select.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') )
	    )

 	$.fn.clear_previous_errors = () ->
	    $('.form-group.has-error', this).each( () ->
	      $('.help-block', $(this)).html('')
	      $(this).removeClass('has-error')
	    )
	$.fn.setStandardTable = (object,ajax_url)->	    
	    oTable = $('.'+object+'table').DataTable({
		    "dom": 'lBfrtip',
		    "pagingType": "simple_numbers"
		    ,"oLanguage":{
		      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
		    }
		    ,
		    "aoColumnDefs": [ 
		      # { "bSortable": false, "aTargets": [ 2,3 ]},
		      # {
		      #   "targets": [2,3],
		      #   "width": '5%'
		      # }
		    ],
		    "oSearch": {"sSearch": queryParameters().search},

		    "buttons": [{
		                "extend":    'copyHtml5',
		                "text":      '<i class="fa fa-files-o"></i>',
		                "titleAttr": 'Copy'
		            },
		            {
		                "extend":    'excelHtml5',
		                "text":      '<i class="fa fa-file-excel-o"></i>',
		                "titleAttr": 'Excel'
		            },
		            {
		                "extend":    'csvHtml5',
		                "text":      '<i class="fa fa-file-text-o"></i>',
		                "titleAttr": 'CSV'
		            },
		            {
		              "extend": 'selectAll',
		              "action": ( e, dt, node, config ) ->
		                oTable.$('tr').addClass('selected')
		                oTable.$('tr').addClass('success')
		                selects = oTable.rows('tr.selected').data()
		                if selects.length == 0
		                  $("#edit_"+object).attr("disabled", true);
		                  $("#destroy_"+object).attr("disabled", true);
		                else
		                  $("#destroy_"+object).attr("disabled", false);
		                  if selects.length == 1
		                    $("#edit_"+object).attr("disabled", false);
		                  else
		                    $("#edit_"+object).attr("disabled", true);
		                $(".buttons-select-none").removeClass('disabled')




		            },
		            {
		              "extend": 'selectNone',
		              "action": ( e, dt, node, config ) ->
		                oTable.$('tr').removeClass('selected')
		                oTable.$('tr').removeClass('success')
		                selects = oTable.rows('tr.selected').data()
		                if selects.length == 0
		                  $("#edit_"+object).attr("disabled", true);
		                  $("#destroy_"+object).attr("disabled", true);
		                else
		                  $("#destroy_"+object).attr("disabled", false);
		                  if selects.length == 1
		                    $("#edit_"+object).attr("disabled", false);
		                  else
		                    $("#edit_"+object).attr("disabled", true);
		                $(".buttons-select-none").addClass('disabled')
		            }

		            ]
		  })
	    $("#edit_"+object).attr("disabled", true)
	    $("#destroy_"+object).attr("disabled", true)
	    $('.'+object+'table').on 'click', 'tr',  () ->
		    d = oTable.row(this).data()
		    if d != undefined
		      	if $(this).hasClass('selected')
			        $(this).removeClass('selected')
			        $(this).removeClass('success')
		      	else			       
			        $(this).addClass('selected')
			        $(this).addClass('success')			        
		    selects = oTable.rows('tr.selected').data()
		    if selects.length == 0
			    $("#edit_"+object).attr("disabled", true)
			    $("#destroy_"+object).attr("disabled", true)
			    $(".buttons-select-none").addClass('disabled')
		    else
			    $("#destroy_"+object).attr("disabled", false)
			    $(".buttons-select-none").removeClass('disabled')
			    if selects.length == 1
			       	$("#edit_"+object).attr("disabled", false)
			    else
			        $("#edit_"+object).attr("disabled", true)		
	    $('#destroy_'+object).click () ->
		    rows = oTable.rows('tr.selected').data()
		    objectIds = new Array();
		    if rows.length == 0
		      swal($('#message_confirm_select').text())
		    else
		      swal({
		        title: $('#message_confirm_delete').text(),
		        text: "",
		        type: "warning",
		        showCancelButton: true,
		        confirmButtonColor: "#DD6B55",
		        confirmButtonText: "OK",
		        cancelButtonText: "キャンセル",
		        closeOnConfirm: false,
		        closeOnCancel: false
		      }).then(() ->
		        len = rows.length
		        for i in [0...len]
		          objectIds[i] = rows[i][0]

		        $.ajax({
		          url: ajax_url,
		          data:{
		            focus_field: object+'_削除する',
		            datas: objectIds
		          },

		          type: "POST",

		          success: (data) ->
		            swal("削除されました!", "", "success");
		            if data.destroy_success != null
		              console.log("getAjax destroy_success:"+ data.destroy_success)
		              oTable.rows('tr.selected').remove().draw()
		            else
		              console.log("getAjax destroy_success:"+ data.destroy_success)


		          failure: () ->
		            console.log(object+"_削除する keydown Unsuccessful")

		        })
		        $("#edit_"+object).attr("disabled", true);
		        $("#destroy_"+object).attr("disabled", true);

		      ,(dismiss) ->
		        if dismiss == 'cancel'

		          selects = oTable.rows('tr.selected').data()
		          if selects.length == 0
		            $("#edit_"+object).attr("disabled", true);
		            $("#destroy_"+object).attr("disabled", true);
		          else
		            $("#destroy_"+object).attr("disabled", false);
		            if selects.length == 1
		              $("#edit_"+object).attr("disabled", false);
		            else
		              $("#edit_"+object).attr("disabled", true);
		      );
	    return oTable
	# $('#import_form').hide()   
	# $('#import_button').click ->
 #    	$('#import_form').toggle()
    
