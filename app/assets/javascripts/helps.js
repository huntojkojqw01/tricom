$(document).on('ready', function() {
    var ToC =
      "<nav role='navigation' class='table-of-contents'>" +
        "<h2>メニュー</h2>" +
        "<ul>";

    var newLine, el, title, link;

    $("article .guide-item .guide-content h3").each(function() {
        // alert($(this).html());
      el = $(this);
      title = el.text();
      // alert();
      link = "#" + el.parent().parent().attr("id");
      newLine =
        "<li>" +
          "<a href='" + link + "'>" +
            title +
          "</a>" +
        "</li>";

      ToC += newLine;

    });

    ToC +=
       "</ul>" +
      "</nav>";
    // alert($(".guide-item").closest(".guide-content").height()-76);
    $(".menu-content").prepend(ToC);
    $(".guide-item").each(function(){
        // alert("ok");
        // alert($(this).children().height());
        $(this).css("height",$(this).children().height()+"px");
    });
    // $(.gui)
    // $(".guide-title").css("height",$(".guide-title").closest(".guide-contenti").height-76+"px")
    // $(".guide-item").css("height","24px")

    $('.show_pdf_help').click(function(){
      $('#view_pdf').attr('src','"../../assets/images/'+$(this).attr('data'));
    })
    $('#view_pdf').css("height", $(document).height()+'px');
});